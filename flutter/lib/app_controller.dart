import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

import 'package:dio/dio.dart' as d;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'common.dart';
import 'models/platform_model.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';

/// Trạng thái license chuẩn hoá để thực thi hành động nhất quán
enum LicenseStatusEnum { valid, invalid, expired, disabled, error, unknown }

class LicenseEvent {
  final LicenseStatusEnum status;
  final String? message;
  final String? expiresAt;
  final String? hardwareId;
  LicenseEvent({required this.status, this.message, this.expiresAt, this.hardwareId});
}

class AppController extends GetxController {
      Timer? _licenseCheckTimer;
  StreamSubscription<FileSystemEvent>? _licWatchSub;
  Timer? _licDebounce;
  bool _isChecking = false;
  StreamSubscription<LicenseEvent>? _licenseEventSub;
      DateTime? _lastChecked;
      String? _lastStatus;
      String? _lastHardwareId;
  bool _lockdownTriggered = false;
  final StreamController<LicenseEvent> _licenseEvents = StreamController<LicenseEvent>.broadcast();
  Stream<LicenseEvent> get licenseEvents => _licenseEvents.stream;
  final Rx<LicenseStatusEnum> licenseState = LicenseStatusEnum.unknown.obs;

      /// Khởi động kiểm tra license tự động (mặc định dùng env hoặc 5s)
      void startLicenseAutoCheck({Duration? interval}) {
        _licenseCheckTimer?.cancel();
        final iv = interval ?? Duration(seconds: kLicCheckSec);
        _licenseCheckTimer = Timer.periodic(iv, (_) => _autoCheckLicense());
        debugPrint('[autoCheck] Đã khởi động kiểm tra license tự động mỗi ${iv.inSeconds}s');
      }

      /// Dừng kiểm tra license tự động
      void stopLicenseAutoCheck() {
        _licenseCheckTimer?.cancel();
        _licenseCheckTimer = null;
        debugPrint('[autoCheck] Đã dừng kiểm tra license tự động');
      }

      /// Gọi lại kiểm tra license khi app foreground hoặc có sự kiện nhập key/gia hạn
      Future<void> triggerLicenseCheck() async {
        debugPrint('[autoCheck] Trigger kiểm tra license do sự kiện/lifecycle');
        await _autoCheckLicense();
      }

      /// Hàm kiểm tra license tự động, xử lý mọi trường hợp
      Future<void> _autoCheckLicense() async {
        // Bypass license check for quicksupport mode
        if (isQuickSupport) {
          debugPrint('[autoCheck] QuickSupport mode - bypass license check');
          licenseStatus.value = 'valid';
          licenseMessage.value = 'QuickSupport Mode';
          isLicensed.value = true;
          return;
        }
        if (_isChecking) {
          debugPrint('[autoCheck] Bỏ qua vì đang kiểm tra...');
          return;
        }
        _isChecking = true;
        try {
          ServerConfig? serverConfig = await getServerConfig();
          if (serverConfig == null || serverConfig.licenseKey.trim().isEmpty) {
            if (!_lockdownTriggered) {
              debugPrint('[autoCheck] Không có licenseKey, hiển thị dialog nhập license');
              _lockdownTriggered = true;
              try { _licenseCheckTimer?.cancel(); } catch (_) {}
              try { _licWatchSub?.cancel(); } catch (_) {}
              try { _licDebounce?.cancel(); } catch (_) {}
              await _initConfigBlocked();
              showDialogRequestLicenseKey();
            }
            return;
          }
          String hardwareId = await platformFFI.getDeviceId();
          // Giải mã licenseKey nếu cần trước khi gửi API
          String keyToSend = serverConfig.licenseKey.trim();
          try {
            final decrypted = await _decryptLicense(keyToSend);
            if (decrypted.isNotEmpty) keyToSend = decrypted;
          } catch (_) {}
          final ApiResponse apiResponse = await _apiClient.ping(
            licenseKey: keyToSend,
            hardwareId: hardwareId,
          );
          _lastChecked = DateTime.now();
          // Luôn cập nhật UI và phát sự kiện theo status API trả về
          final String nextStatus = apiResponse.status ?? '';
          final String nextMsg = apiResponse.message ?? '';
          final String nextExp = apiResponse.expiresAt ?? '';

          licenseStatus.value = nextStatus;
          licenseMessage.value = nextMsg;
          expiresAt.value = nextExp;
          licenseKeyDisplay.value = serverConfig.licenseKey;
          debugPrint('[autoCheck] Cập nhật từ API: status=$nextStatus, expiresAt=$nextExp');
          _lastStatus = nextStatus;
          _lastHardwareId = hardwareId;

          // Phát sự kiện để áp dụng chính sách (lockdown, vv.).
          // _lockdownTriggered sẽ ngăn hiển thị dialog lặp lại.
          _emitLicenseEvent(apiResponse, hardwareId: hardwareId);
        } catch (e) {
          debugPrint('[autoCheck] Lỗi khi kiểm tra license: $e');
          // Nếu lỗi mạng, có thể tăng khoảng thời gian kiểm tra lại
          if (_licenseCheckTimer != null) {
            _licenseCheckTimer!.cancel();
            Future.delayed(const Duration(minutes: 2), () {
              startLicenseAutoCheck();
            });
            debugPrint('[autoCheck] Mất mạng, sẽ thử lại sau 2 phút');
          }
        } finally {
          _isChecking = false;
        }
      }

      @override
      void onClose() {
        stopLicenseAutoCheck();
        try { _licWatchSub?.cancel(); } catch (_) {}
        try { _licDebounce?.cancel(); } catch (_) {}
        try { _licenseEventSub?.cancel(); } catch (_) {}
        try { _licenseEvents.close(); } catch (_) {}
        super.onClose();
      }
    /// Hàm reload lại thông tin license, có thể gọi từ UI hoặc sau khi đổi key
    Future<void> reloadLicenseInfo() async {
      debugPrint('[reloadLicenseInfo] Bắt đầu reload thông tin license');
      ServerConfig? serverConfig = await getServerConfig();
      if (serverConfig != null && serverConfig.licenseKey.trim().isNotEmpty) {
        debugPrint('[reloadLicenseInfo] Có licenseKey, gọi fetchAndUpdateLicenseInfo');
        await fetchAndUpdateLicenseInfo(serverConfig.licenseKey);
      } else {
        debugPrint('[reloadLicenseInfo] Không có licenseKey, bỏ qua');
      }
    }
  static AppController get to => Get.find<AppController>();
  late final ApiClient _apiClient;
  RxString expiresAt = ''.obs;
  RxString licenseStatus = ''.obs;
  RxString licenseMessage = ''.obs;
  RxString licenseHardwareId = ''.obs;
  RxString licenseKeyDisplay = ''.obs;
  final _isInProgress = false.obs;
  // Cờ tổng để gate tính năng theo trạng thái license
  final RxBool isLicensed = false.obs;


  String get kIdServer => dotenv.env['ID_SERVER'] ?? '';
  String get kRelayServer => dotenv.env['REPLAY_SERVER'] ?? '';
  String get kApiServer => dotenv.env['API_SERVER'] ?? '';
  String get kKey => dotenv.env['KEY'] ?? '';
  String get kServerLic => dotenv.env['SERVER_LIC'] ?? '';
  int get kLicCheckSec => int.tryParse(dotenv.env['LIC_CHECK_SEC'] ?? '5') ?? 5;
  bool get isQuickSupport {
    // Check environment variable from system first, then dotenv fallback
    try {
      // Check system environment variable first
      final sysEnv = Platform.environment['IS_QUICKSUPPORT']?.toLowerCase() ?? '';
      if (sysEnv.isNotEmpty) {
        return sysEnv == 'true' || sysEnv == '1';
      }
      // Fallback to dotenv if system env not set
      final dotEnv = dotenv.env['IS_QUICKSUPPORT']?.toLowerCase() ?? '';
      return dotEnv == 'true' || dotEnv == '1';
    } catch (e) {
      debugPrint('[isQuickSupport] Error checking env vars: $e');
      return false;
    }
  }

  // Đường dẫn tuyệt đối tới thư mục config của HelpDesk
  String get configDirPath {
    if (Platform.isWindows) {
      final appData = Platform.environment['APPDATA'] ?? '';
      if (appData.isEmpty) return Directory.current.path;
      // Sử dụng thư mục riêng cho QuickSupport
      return isQuickSupport ? 
        '$appData/HelpDeskQS/config' :
        '$appData/HelpDesk/config';
    } else if (Platform.isLinux || Platform.isMacOS) {
      final home = Platform.environment['HOME'] ?? '';
      if (home.isEmpty) return Directory.current.path;
      // Sử dụng thư mục riêng cho QuickSupport
      return isQuickSupport ?
        '$home/.config/helpdeskqs' :
        '$home/.config/helpdesk';
    }
    return Directory.current.path;
  }

  /// Watch for HelpDesk2.toml being created shortly after startup and delete it.
  /// Some components may create `HelpDesk2.toml` after this process's initial
  /// startup; call this to watch the config directory for a short period and
  /// remove the toml if it appears.
  Future<void> _watchAndDeleteRustdeskToml(Duration timeout) async {
    try {
      // Xác định thư mục cần quét dựa trên biến thể
      String dirToScan = '';
      
      if (Platform.isWindows) {
        final appData = Platform.environment['APPDATA'] ?? '';
        if (appData.isNotEmpty) {
          // Nếu QuickSupport thì quét HelpDeskQS, nếu full thì quét HelpDesk
          dirToScan = isQuickSupport ? 
            '$appData/HelpDeskQS/config' :
            '$appData/HelpDesk/config';
        }
      } else if (Platform.isLinux || Platform.isMacOS) {
        final home = Platform.environment['HOME'] ?? '';
        if (home.isNotEmpty) {
          // Nếu QuickSupport thì quét helpdeskqs, nếu full thì quét helpdesk
          dirToScan = isQuickSupport ?
            '$home/.config/helpdeskqs' :
            '$home/.config/helpdesk';
        }
      }
      
      // Fallback về configDirPath nếu không xác định được
      if (dirToScan.isEmpty) {
        dirToScan = configDirPath;
      }
      
      // Chỉ xóa file *2.toml khi là QuickSupport
      if (!isQuickSupport) {
        debugPrint('[watchAndDelete] Bản Full - bỏ qua việc xóa file');
        return;
      }
      
      final deadline = DateTime.now().add(const Duration(seconds: 3));
      debugPrint('[watchAndDelete] Bắt đầu scan HelpDeskQS2.toml liên tục trong 3 giây (QuickSupport)');
      debugPrint('[watchAndDelete] Quét thư mục: $dirToScan');
      
      while (DateTime.now().isBefore(deadline)) {
        try {
          final dir = Directory(dirToScan);
          if (!await dir.exists()) {
            await Future.delayed(const Duration(milliseconds: 200));
            continue;
          }
          
          final list = await dir.list().toList();
          for (final ent in list) {
            if (ent is File) {
              final p = ent.path.replaceAll('\\', '/');
              final name = p.split('/').last.toLowerCase();
              // Xóa HelpDeskQS2.toml (hoặc helpdeskqs2.toml trên Linux)
              if (name == 'helpdeskqs2.toml') {
                try {
                  await ent.delete();
                  debugPrint('[watchAndDelete] Đã phát hiện và xóa HelpDeskQS2.toml: $p');
                } catch (e) {
                  debugPrint('[watchAndDelete] Lỗi khi xóa HelpDeskQS2.toml: $e');
                }
              }
            }
          }
        } catch (e) {
          debugPrint('[watchAndDelete] Lỗi khi quét thư mục $dirToScan: $e');
        }
        await Future.delayed(const Duration(milliseconds: 200));
      }
      debugPrint('[watchAndDelete] Kết thúc scan HelpDeskQS2.toml sau 3 giây');
    } catch (e) {
      debugPrint('[watchAndDelete] Lỗi scan HelpDesk2.toml: $e');
    }
  }

  // Encrypt the license key before saving to disk.
  Future<String> _encryptLicense(String plain) async {
    try {
      final deviceId = await platformFFI.getDeviceId();
      final keyBytes = sha256.convert(utf8.encode(deviceId)).bytes;
      final key = encrypt.Key(Uint8List.fromList(keyBytes));
      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      final encrypted = encrypter.encrypt(plain, iv: iv);
      // store iv + ciphertext as base64
      final out = base64Encode(iv.bytes + encrypted.bytes);
      return out;
    } catch (e) {
      debugPrint('[encryptLicense] Lỗi: $e');
      return '';
    }
  }

  // Decrypt the license key read from disk. Returns empty string on failure.
  Future<String> _decryptLicense(String cipherBase64) async {
    try {
      if (cipherBase64.trim().isEmpty) return '';
      final raw = base64Decode(cipherBase64);
      if (raw.length < 17) return '';
      final ivBytes = raw.sublist(0, 16);
      final ctBytes = raw.sublist(16);
      final deviceId = await platformFFI.getDeviceId();
      final keyBytes = sha256.convert(utf8.encode(deviceId)).bytes;
      final key = encrypt.Key(Uint8List.fromList(keyBytes));
      final iv = encrypt.IV(Uint8List.fromList(ivBytes));
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      final encrypted = encrypt.Encrypted(Uint8List.fromList(ctBytes));
      final dec = encrypter.decrypt(encrypted, iv: iv);
      return dec;
    } catch (e) {
      debugPrint('[decryptLicense] Lỗi: $e');
      return '';
    }
  }

  String get licKeyPath => isQuickSupport ? '' : '$configDirPath/key.lic';
  String get rustdeskTomlPath => '$configDirPath/HelpDesk2.toml';

  @override
  onInit() {
    super.onInit();
    debugPrint('[onInit] Khởi tạo AppController');
    _apiClient = ApiClient(baseUrl: kServerLic);
    startupLicenseFlow();
    _startLicenseFileWatcher();
    // Đăng ký lắng nghe sự kiện license để áp dụng luồng hành vi
    try {
      _licenseEventSub?.cancel();
      _licenseEventSub = _licenseEvents.stream.listen(_handleLicenseEvent);
    } catch (e) {
      debugPrint('[onInit] Không thể subscribe licenseEvents: $e');
    }
  }

  /// Kịch bản khởi động: kiểm tra file lic.key, xử lý logic kích hoạt hoặc xác thực license
  Future<void> startupLicenseFlow() async {
      // Bypass license flow for quicksupport mode
      if (isQuickSupport) {
        debugPrint('[startupLicenseFlow] QuickSupport mode - bypass license flow');
        licenseStatus.value = 'valid';
        licenseMessage.value = 'QuickSupport Mode';
        isLicensed.value = true;
        
        // Initialize ServerConfig with kKey for QuickSupport mode
        debugPrint('[startupLicenseFlow] QuickSupport mode - initialize ServerConfig with kKey');
        ServerConfig serverConfig = await getServerConfig() ?? ServerConfig();
        serverConfig.key = kKey;
        serverConfig.idServer = kIdServer;
        serverConfig.relayServer = kRelayServer;
        serverConfig.apiServer = kApiServer;
        serverConfig.licenseKey = 'QUICKSUPPORT';
        await setServerConfig(null, null, serverConfig);
        debugPrint('[startupLicenseFlow] QuickSupport mode - ServerConfig initialized');
        
        // Small grace delay to allow other components to pick up ServerConfig
        await Future.delayed(const Duration(milliseconds: 200));
        
        // Watch and delete HelpDesk2.toml if it exists or gets created
        debugPrint('[startupLicenseFlow] QuickSupport mode - start watching HelpDesk2.toml');
        await _watchAndDeleteRustdeskToml(const Duration(seconds: 10));
        
        return;
      }
      debugPrint('[startupLicenseFlow] Bắt đầu kiểm tra license khi khởi động');
    // Skip license file check for QuickSupport mode
    if (licKeyPath.isEmpty) {
      debugPrint('[startupLicenseFlow] QuickSupport mode - skip license file check');
      return;
    }
    final licFile = File(licKeyPath);
    debugPrint('[startupLicenseFlow] Lic file path: $licKeyPath');
    if (await licFile.exists()) {
      debugPrint('[startupLicenseFlow] ĐÃ CÓ file key.lic, đọc key và kiểm tra với API');
      final savedLicenseKeyRaw = await licFile.readAsString();
      final savedLicenseKeyDecrypted = await _decryptLicense(savedLicenseKeyRaw);
      String savedLicenseKey = savedLicenseKeyDecrypted.isNotEmpty
          ? savedLicenseKeyDecrypted
          : savedLicenseKeyRaw;
      // If file was not encrypted (decrypt returned empty but raw has content),
      // do NOT auto-migrate here. We will use the raw content for API check,
      // but avoid overwriting the file on startup. Encryption should only be
      // performed when the user actively provides/activates the license (see
      // the activation dialog flow where we already write encrypted data).
      if (savedLicenseKeyDecrypted.isEmpty && savedLicenseKeyRaw.trim().isNotEmpty) {
        final rawTrim = savedLicenseKeyRaw.trim();
        debugPrint('[startupLicenseFlow] Phát hiện file key.lic ở dạng thuần (chưa mã hóa). raw="$rawTrim"');
        debugPrint('[startupLicenseFlow] Không tự động migrate tại startup; sẽ chỉ mã hóa khi kích hoạt (activation) từ người dùng.');
      }
      String hardwareId = await platformFFI.getDeviceId();
      debugPrint('[startupLicenseFlow] Gọi API check license với key: $savedLicenseKey, hardware_id: $hardwareId');
      final ApiResponse apiResponse = await _apiClient.check(
        licenseKey: savedLicenseKey.trim(),
        hardwareId: hardwareId,
      );
      debugPrint('[startupLicenseFlow] Kết quả check: status=${apiResponse.status}, message=${apiResponse.message}');
      if (apiResponse.status == 'valid') {
        // Gọi fetchAndUpdateLicenseInfo trước để log đúng thứ tự mong muốn
        await fetchAndUpdateLicenseInfo(savedLicenseKey.trim());
        debugPrint('[startupLicenseFlow] License hợp lệ, cập nhật ServerConfig. Đợi fetch+reload xong rồi mới xóa HelpDesk2.toml');
        ServerConfig serverConfig = await getServerConfig() ?? ServerConfig();
        serverConfig.licenseKey = savedLicenseKey.trim();
        serverConfig.key = kKey;
        serverConfig.idServer = kIdServer;
        serverConfig.relayServer = kRelayServer;
        serverConfig.apiServer = kApiServer;
        await setServerConfig(null, null, serverConfig);
        // Ensure local state is refreshed before deleting the toml file
        try {
          await reloadLicenseInfo();
        } catch (e) {
          debugPrint('[startupLicenseFlow] reloadLicenseInfo lỗi: $e');
        }
        // Small grace delay to allow other components to react to the new ServerConfig
        await Future.delayed(const Duration(milliseconds: 200));
        // If the toml already exists, delete it immediately and also start a watcher
        // to catch recreations. If it does not exist, wait for it to be created and
        // delete when it appears.
        // Scan HelpDesk2.toml liên tục trong 10 giây, nếu phát hiện thì xóa ngay
        await _watchAndDeleteRustdeskToml(const Duration(seconds: 10));
          // Nếu file ban đầu là plaintext (chưa giải mã được),
          // thì sau khi API xác thực valid, mã hóa và ghi lại file.
          if (savedLicenseKeyDecrypted.isEmpty && savedLicenseKeyRaw.trim().isNotEmpty) {
            try {
              final encAfterValidate = await _encryptLicense(savedLicenseKeyRaw.trim());
              if (encAfterValidate.isNotEmpty) {
                try {
                  debugPrint('[startup-migrate] Sau khi valid, ghi file mã hóa: $licKeyPath');
                  await licFile.writeAsString(encAfterValidate);
                  final verify2 = await licFile.readAsString();
                  final len2 = await licFile.length();
                  debugPrint('[startup-migrate] Ghi thành công, kích thước=${len2} bytes, bắt đầu=${verify2.substring(0, verify2.length>16?16:verify2.length)}');
                } catch (e) {
                  debugPrint('[startup-migrate] Lỗi khi ghi key.lic sau validate: $e');
                }
              } else {
                debugPrint('[startup-migrate] Mã hóa sau validate trả về chuỗi rỗng, bỏ qua ghi');
              }
            } catch (e) {
              debugPrint('[startup-migrate] Lỗi khi mã hóa sau validate: $e');
            }
          }
        // Bắt đầu kiểm tra license định kỳ sau khi hợp lệ
        startLicenseAutoCheck(interval: Duration(seconds: kLicCheckSec));
        _emitLicenseEvent(apiResponse, hardwareId: hardwareId);
      } else if (apiResponse.status == 'invalid' || apiResponse.status == 'expired') {
        debugPrint('[startupLicenseFlow] License invalid/expired, xóa key.lic và yêu cầu nhập lại');
        await licFile.delete();
        await _initConfigBlocked();
        showDialogRequestLicenseKey();
        stopLicenseAutoCheck();
        _emitLicenseEvent(apiResponse, hardwareId: hardwareId);
      } else if (apiResponse.status == 'error') {
        debugPrint('[startupLicenseFlow] Lỗi hệ thống, giữ nguyên key.lic và hiện dialog');
        Get.dialog(
          CustomAlertDialog(
            title: Text(translate('System Error!')),
            content: Text(apiResponse.message ?? translate('An unknown error occurred. Please try again.')),
            actions: [
              dialogButton(translate('Close'), onPressed: () => Get.back()),
            ],
          ),
          barrierDismissible: false,
        );
        _emitLicenseEvent(apiResponse, hardwareId: hardwareId);
      }
    } else {
      // KHÔNG có file lic.key (kích hoạt lần đầu)
      await _initConfigBlocked();
      // KHÔNG tạo file lic.key ở đây, chỉ tạo khi nhập license hợp lệ
      showDialogRequestLicenseKey();
    }
  }

  /// Khởi tạo ServerConfig với key rỗng để chặn kết nối
  Future<void> _initConfigBlocked() async {
    debugPrint('[_initConfigBlocked] Khởi tạo ServerConfig với key rỗng để chặn kết nối');
    ServerConfig serverConfig = ServerConfig(
      idServer: kIdServer,
      relayServer: kRelayServer,
      apiServer: kApiServer,
      key: '',
      licenseKey: '',
    );
    await setServerConfig(null, null, serverConfig);
  }

  /// Khởi động watcher HelpDesk2.toml sau khi khởi tạo ServerConfig
  Future<void> startupTomlWatcher() async {
    try {
      debugPrint('[startupLicenseFlow] Luôn khởi động watcher HelpDesk2.toml (30s) để xóa file tồn tại hoặc tái tạo');
      await _watchAndDeleteRustdeskToml(const Duration(seconds: 30));
      debugPrint('[startupLicenseFlow] Đã chạy watcher (30s) cho HelpDesk2.toml');
    } catch (e) {
      debugPrint('[startupLicenseFlow] Không thể khởi động watcher: $e');
    }
  }

  /// Luồng mới: luôn lấy licenseKey từ local, sau đó gọi API để lấy thông tin license mới nhất và cập nhật UI
  Future<void> checkKeyAndFetchInfo() async {
      debugPrint('[checkKeyAndFetchInfo] Bắt đầu kiểm tra key và lấy thông tin license');
    ServerConfig? serverConfig = await getServerConfig();
    if (serverConfig == null) {
      debugPrint('[checkKeyAndFetchInfo] Chưa có ServerConfig, khởi tạo mặc định và yêu cầu nhập key');
      await _initConfigBlocked();
      showDialogRequestLicenseKey();
      return;
    } else if (serverConfig.licenseKey.trim().isEmpty) {
      debugPrint('[checkKeyAndFetchInfo] ServerConfig không có licenseKey, yêu cầu nhập key');
      await _initConfigBlocked();
      showDialogRequestLicenseKey();
      return;
    }
    debugPrint('[checkKeyAndFetchInfo] Có licenseKey, gọi fetchAndUpdateLicenseInfo');
    await fetchAndUpdateLicenseInfo(serverConfig.licenseKey);
  }

  /// Gọi API check license và cập nhật các biến trạng thái để hiển thị lên UI
  Future<void> fetchAndUpdateLicenseInfo(String licenseKey) async {
      debugPrint('[fetchAndUpdateLicenseInfo] Gọi API check license và cập nhật trạng thái UI với key: $licenseKey');
    try {
      // If the stored licenseKey is encrypted, try to decrypt it before calling API.
      String keyToSend = licenseKey;
      try {
        final maybe = await _decryptLicense(licenseKey);
        if (maybe.isNotEmpty) {
          debugPrint('[fetchAndUpdateLicenseInfo] Phát hiện licenseKey được mã hoá, đã giải mã trước khi gọi API');
          keyToSend = maybe;
        }
      } catch (e) {
        debugPrint('[fetchAndUpdateLicenseInfo] Không thể giải mã licenseKey: $e');
      }

      String hardwareId = await platformFFI.getDeviceId();
      debugPrint('[fetchAndUpdateLicenseInfo] Gọi API check với hardwareId: $hardwareId');
      final ApiResponse apiResponse = await _apiClient.check(
        licenseKey: keyToSend,
        hardwareId: hardwareId,
      );
      debugPrint('[fetchAndUpdateLicenseInfo] Kết quả: status=${apiResponse.status}, message=${apiResponse.message}');
      licenseStatus.value = apiResponse.status ?? '';
      licenseMessage.value = apiResponse.message ?? '';
      expiresAt.value = apiResponse.expiresAt ?? '';
      licenseKeyDisplay.value = licenseKey;
      if (apiResponse.status == 'invalid') {
        debugPrint('[fetchAndUpdateLicenseInfo] License hết hạn hoặc không hợp lệ, show dialog');
        showDialogExpiredApiKey();
        expiresAt.value = '';
      }
      _emitLicenseEvent(apiResponse, hardwareId: hardwareId);
    } catch (err) {
      debugPrint('[fetchAndUpdateLicenseInfo] Lỗi: $err');
      licenseStatus.value = 'error';
      licenseMessage.value = err.toString();
      expiresAt.value = '';
      _emitLicenseEvent(ApiResponse(status: 'error', message: err.toString(), expiresAt: null));
    }
  }

  Future<ApiResponse?> checkLicenseOnStartup(ServerConfig serverConfig) async{
    // Hàm này không còn cần thiết nữa, mọi thứ đã chuyển sang fetchAndUpdateLicenseInfo
    return null;
  }

  Future<(bool, String?)> checkKey(String licenseKey, String hardwareId) async{
      debugPrint('[checkKey] Kiểm tra licenseKey: $licenseKey với hardwareId: $hardwareId');
    try {
      String keyToSend = licenseKey;
      try {
        final decrypted = await _decryptLicense(licenseKey);
        if (decrypted.isNotEmpty) keyToSend = decrypted;
      } catch (_) {}
      final ApiResponse apiResponse = await _apiClient.check(
        licenseKey: keyToSend,
        hardwareId: hardwareId,
      );
      debugPrint('[checkKey] Kết quả: status=${apiResponse.status}, message=${apiResponse.message}');
      switch (apiResponse.status) {
        case 'valid':
          debugPrint('[checkKey] License hợp lệ');
          Get.snackbar(translate("Successful"), apiResponse.message ?? "", colorText: Colors.green, instantInit: true, snackPosition: SnackPosition.BOTTOM);
          return (true, apiResponse.expiresAt);
        case 'invalid':
          debugPrint('[checkKey] License không hợp lệ');
          Get.snackbar(translate("Warning"), apiResponse.message ?? translate("Invalid License."), colorText: Colors.amber, instantInit: true, snackPosition: SnackPosition.BOTTOM);
          break;
        case 'error':
          debugPrint('[checkKey] Lỗi server');
          Get.snackbar(translate("Error"), apiResponse.message ?? translate("Server error"), colorText: Colors.red, instantInit: true, snackPosition: SnackPosition.BOTTOM);
          break;
        default:
          debugPrint('[checkKey] Trạng thái không xác định');
          Get.snackbar(translate("Information"), apiResponse.message ?? translate("Unknown response"), colorText: Colors.orange, instantInit: true, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (err) {
      debugPrint('[checkKey] Lỗi: $err');
      if (err is Exception) {
        Get.snackbar(
          translate("Error"),
          err.toString().replaceFirst('Exception: ', ''),
          colorText: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          instantInit: true,
        );
      } else {
        Get.snackbar(translate("Error"), "Error: $err",
            colorText: Colors.red,
            instantInit: true,
            snackPosition: SnackPosition.BOTTOM
        );
      }
    }
    return (false, null);
  }

  void showDialogExpiredApiKey(){
      debugPrint('[showDialogExpiredApiKey] Hiển thị dialog license hết hạn');
    gFFI.dialogManager.show((setState, close, context) {
      return CustomAlertDialog(
        title: Text(translate("License expired")),
        content: Text(translate("The key has expired. Please update to continue using the application.")),
        actions: [
          dialogButton(translate('Close'), onPressed: (){
            exit(0);
          }),
        ],
      );
    });
  }

  void showDialogRequestLicenseKey(){
      debugPrint('[showDialogRequestLicenseKey] Hiển thị dialog nhập license key');
    final keyCtrl = TextEditingController(text: "");

    gFFI.dialogManager.show((setState, close, context) {
      Widget buildField(String label, TextEditingController controller) {
        if (isDesktop) {
          return Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(translate(label)),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                    controller: controller,
                    onChanged: (value){
                      setState(() {
                        keyCtrl.text = value;
                      });
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    )).workaroundFreezeLinuxMint(),
              ),
            ],
          );
        }
        return TextFormField(
            controller: controller,
            decoration: InputDecoration(
                labelText: label,
                )).workaroundFreezeLinuxMint();
      }

      return CustomAlertDialog(
        title: Row(
          children: [Expanded(child: Text(translate('License Key Required')))],
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 500),
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => Column(
                      children: [
                        buildField(translate('Key'), keyCtrl),
                        if (_isInProgress.value)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: LinearProgressIndicator(),
                          ),
                      ],
                    )),
              ],
            ),
          ),
        ),
        actions: [
          dialogButton(translate('Cancel'), onPressed: () {
            exit(0);
          }, isOutline: true),
          dialogButton(
            translate('OK'),
            onPressed: (keyCtrl.text.trim().isEmpty || _isInProgress.value) ? null : () async{
              _isInProgress.value = true;
              try{
                String hardwareId = await platformFFI.getDeviceId();
                // Gửi license_key + hardware_id lên API check.php
                final ApiResponse apiResponse = await _apiClient.check(
                  licenseKey: keyCtrl.text.trim(),
                  hardwareId: hardwareId,
                );
                if(apiResponse.status == 'valid'){
                  // Lưu file lic.key (skip for QuickSupport mode)
                  if (!isQuickSupport && licKeyPath.isNotEmpty) {
                    final licFile = File(licKeyPath);
                    final enc = await _encryptLicense(keyCtrl.text.trim());
                    if (enc.isNotEmpty) {
                      try {
                        debugPrint('[activation] Ghi file mã hóa: $licKeyPath');
                        await licFile.writeAsString(enc);
                        final verify = await licFile.readAsString();
                        final len = await licFile.length();
                        debugPrint('[activation] Ghi thành công, kích thước=${len} bytes, bắt đầu=${verify.substring(0, verify.length>16?16:verify.length)}');
                      } catch (e) {
                        debugPrint('[activation] Lỗi khi ghi key.lic: $e');
                      }
                    } else {
                      debugPrint('[activation] Mã hóa trả về chuỗi rỗng, bỏ qua ghi file');
                    }
                  } else {
                    debugPrint('[activation] QuickSupport mode - skip saving key.lic');
                  }
                  // Cập nhật ServerConfig cho phép kết nối
                  ServerConfig serverConfig = await getServerConfig() ?? ServerConfig();
                  serverConfig.licenseKey = keyCtrl.text.trim();
                  serverConfig.key = kKey;
                  serverConfig.idServer = kIdServer;
                  serverConfig.relayServer = kRelayServer;
                  serverConfig.apiServer = kApiServer;
                  await setServerConfig(null, null, serverConfig);
                  // Ensure app state reloads before deleting the toml file
                  try {
                    await AppController.to.reloadLicenseInfo();
                  } catch (e) {
                    debugPrint('[activation] reloadLicenseInfo lỗi: $e');
                  }
                  // Small grace delay to allow other components to pick up ServerConfig
                  await Future.delayed(const Duration(milliseconds: 200));
                  // If toml exists now, delete it; otherwise wait for creation and delete
                  // Scan HelpDesk2.toml liên tục trong 10 giây, nếu phát hiện thì xóa ngay
                  await _watchAndDeleteRustdeskToml(const Duration(seconds: 10));
                  // Bắt đầu auto-check sau khi kích hoạt thành công
                  startLicenseAutoCheck(interval: Duration(seconds: kLicCheckSec));
                  close();
                  showToast(translate('Successful'));
                } else {
                  // Không hợp lệ, báo lỗi, giữ nguyên key = ''
                  showToast(apiResponse.message ?? translate('Invalid License.'));
                }
              } catch(e){
                if (e is Exception) {
                  Get.snackbar(
                    translate("Error"),
                    e.toString().replaceFirst('Exception: ', ''),
                    colorText: Colors.red,
                    snackPosition: SnackPosition.BOTTOM,
                    instantInit: true,
                  );
                } else {
                  Get.snackbar(translate("Error"), "Error: $e",
                      colorText: Colors.red,
                      instantInit: true,
                      snackPosition: SnackPosition.BOTTOM
                  );
                }
              } finally {
                await Future.delayed(const Duration(seconds: 1));
                _isInProgress.value = false;
              }
            },
          ),
        ],
      );
    });
  }

  /// Theo dõi thay đổi file key.lic để trigger kiểm tra realtime khi người dùng thay/nhập lại key
  void _startLicenseFileWatcher() {
    // Skip watcher for QuickSupport mode
    if (isQuickSupport || licKeyPath.isEmpty) {
      debugPrint('[watch:key.lic] QuickSupport mode - skip file watcher');
      return;
    }
    try {
      final dir = Directory(configDirPath);
      if (!dir.existsSync()) return;
      _licWatchSub?.cancel();
      _licWatchSub = dir.watch(events: FileSystemEvent.create | FileSystemEvent.modify | FileSystemEvent.delete).listen((evt) {
        final p = evt.path.replaceAll('\\', '/');
        final name = p.split('/').last.toLowerCase();
        if (name == 'key.lic') {
          _licDebounce?.cancel();
          _licDebounce = Timer(const Duration(milliseconds: 400), () async {
            debugPrint('[watch:key.lic] Phát hiện thay đổi (${evt.type}), trigger kiểm tra license');
            await triggerLicenseCheck();
          });
        }
      }, onError: (e) {
        debugPrint('[watch:key.lic] Lỗi watcher: $e');
      });
      debugPrint('[watch:key.lic] Đã bật watcher key.lic tại $configDirPath');
    } catch (e) {
      debugPrint('[watch:key.lic] Không thể bật watcher: $e');
    }
  }
  
  // Áp dụng luồng trạng thái -> hành động chung cho toàn app
  Future<void> _handleLicenseEvent(LicenseEvent evt) async {
    switch (evt.status) {
      case LicenseStatusEnum.valid:
        isLicensed.value = true;
        debugPrint('[policy] License hợp lệ -> bật tính năng');
        break;
      case LicenseStatusEnum.invalid:
        isLicensed.value = false;
        debugPrint('[policy] License không hợp lệ -> xóa key.lic và yêu cầu kích hoạt lại');
        await _deleteInvalidLicenseFile(evt.status);
        _enforceLockdownImmediate(evt.status);
        break;
      case LicenseStatusEnum.expired:
        isLicensed.value = false;
        debugPrint('[policy] License đã hết hạn -> xóa key.lic và yêu cầu kích hoạt lại');
        await _deleteInvalidLicenseFile(evt.status);
        _enforceLockdownImmediate(evt.status);
        break;
      case LicenseStatusEnum.disabled:
        isLicensed.value = false;
        debugPrint('[policy] License đã bị vô hiệu hóa -> xóa key.lic và yêu cầu kích hoạt lại');
        await _deleteInvalidLicenseFile(evt.status);
        _enforceLockdownImmediate(evt.status);
        break;
      case LicenseStatusEnum.error:
        isLicensed.value = false;
        debugPrint('[policy] License bị lỗi -> xóa key.lic và yêu cầu kích hoạt lại');
        await _deleteInvalidLicenseFile(evt.status);
        _enforceLockdownImmediate(evt.status);
        break;
      case LicenseStatusEnum.unknown:
        // Không làm gì
        break;
    }
  }

  Future<void> _deleteInvalidLicenseFile(LicenseStatusEnum status) async {
    try {
      // Skip file deletion for QuickSupport mode
      if (isQuickSupport || licKeyPath.isEmpty) {
        debugPrint('[deleteInvalidLicense] QuickSupport mode - skip file deletion');
        return;
      }
      final licFile = File(licKeyPath);
      if (licFile.existsSync()) {
        licFile.deleteSync();
        String reason = '';
        switch (status) {
          case LicenseStatusEnum.invalid:
            reason = 'license không hợp lệ';
            break;
          case LicenseStatusEnum.expired:
            reason = 'license đã hết hạn';
            break;
          case LicenseStatusEnum.disabled:
            reason = 'license đã bị vô hiệu hóa';
            break;
          case LicenseStatusEnum.error:
            reason = 'license bị lỗi';
            break;
          default:
            reason = 'license không hợp lệ';
        }
        debugPrint('[deleteInvalidLicense] Đã xóa file key.lic vì $reason');
      }
      // Ngắt tất cả các kết nối remote đang hoạt động
      await _closeAllActiveConnections(status);
      // Reset ServerConfig về trạng thái chặn kết nối
      await _initConfigBlocked();
      debugPrint('[deleteInvalidLicense] Đã reset ServerConfig về trạng thái blocked');
      // Reset lockdown flag khi xóa key để cho phép hiển thị dialog lại
      _lockdownTriggered = false;
    } catch (e) {
      debugPrint('[deleteInvalidLicense] Lỗi khi xóa key.lic: $e');
    }
  }

  /// Ngắt tất cả các kết nối remote đang hoạt động khi license không hợp lệ
  /// Đóng tất cả kết nối INCOMING (máy khác đang remote vào máy này)
  Future<void> _closeAllActiveConnections(LicenseStatusEnum status) async {
    try {
      debugPrint('[closeAllConnections] BẮT ĐẦU ngắt TẤT CẢ kết nối INCOMING do license không hợp lệ');
      
      String reason = '';
      switch (status) {
        case LicenseStatusEnum.invalid:
          reason = 'License không hợp lệ';
          break;
        case LicenseStatusEnum.expired:
          reason = 'License đã hết hạn';
          break;
        case LicenseStatusEnum.disabled:
          reason = 'License đã bị vô hiệu hóa';
          break;
        case LicenseStatusEnum.error:
          reason = 'License bị lỗi';
          break;
        default:
          reason = 'License không hợp lệ';
      }
      
      debugPrint('[closeAllConnections] Lý do: $reason');
      
      // Gọi Rust API để đóng TẤT CẢ các kết nối incoming
      // (máy khác đang điều khiển máy này)
      try {
        await bind.mainCloseAllIncomingConnections();
        debugPrint('[closeAllConnections] ✓ ĐÃ GỬI LỆNH đóng tất cả kết nối incoming');
      } catch (e) {
        debugPrint('[closeAllConnections] ✗ LỖI khi gọi mainCloseAllIncomingConnections: $e');
      }
      
      // Đợi một chút để đảm bảo các kết nối được đóng
      await Future.delayed(const Duration(milliseconds: 500));
      
      debugPrint('[closeAllConnections] ✓ HOÀN TẤT ngắt tất cả kết nối incoming. Lý do: $reason');
    } catch (e) {
      debugPrint('[closeAllConnections] ✗ LỖI NGHIÊM TRỌNG khi xử lý ngắt kết nối: $e');
      debugPrint('[closeAllConnections] Stack trace: ${StackTrace.current}');
    }
  }

  void _enforceLockdownImmediate(LicenseStatusEnum status) {
    if (_lockdownTriggered) return;
    _lockdownTriggered = true;
    try { _licenseCheckTimer?.cancel(); } catch (_) {}
    try { _licWatchSub?.cancel(); } catch (_) {}
    try { _licDebounce?.cancel(); } catch (_) {}
    
    String logMessage = '';
    String dialogTitle = '';
    String dialogContent = '';
    
    switch (status) {
      case LicenseStatusEnum.invalid:
            logMessage = 'License is invalid, show dialog and require re-entry';
            dialogTitle = translate('License is invalid');
            dialogContent = translate('Your license is invalid. Please enter a new license key.');
        break;
      case LicenseStatusEnum.expired:
        logMessage = 'License đã hết hạn, hiển thị thông báo và yêu cầu nhập lại';
        dialogTitle = translate('License has expired');
        dialogContent = translate('Your license has expired. Please enter a new license key.');
        break;
      case LicenseStatusEnum.disabled:
        logMessage = 'License đã bị vô hiệu hóa, hiển thị thông báo và yêu cầu nhập lại';
        dialogTitle = translate('License has been disabled');
        dialogContent = translate('Your license has been disabled. Please enter a new license key.');
        break;
      case LicenseStatusEnum.error:
        logMessage = 'License bị lỗi, hiển thị thông báo và yêu cầu nhập lại';
        dialogTitle = translate('License error occurred');
        dialogContent = translate('License encountered an unknown error. Please enter a new license key.');
        break;
      default:
        logMessage = 'License không hợp lệ, hiển thị thông báo và yêu cầu nhập lại';
        dialogTitle = translate('Invalid License');
        dialogContent = translate('Your license has been disabled or is no longer valid.');
    }
    
    debugPrint('[lockdown] $logMessage');
    // Hiển thị dialog thông báo, sau đó cho nhập lại license
    gFFI.dialogManager.show((setState, close, context) {
      return CustomAlertDialog(
        title: Text(dialogTitle),
        content: Text(dialogContent),
        actions: [
          dialogButton(translate('OK'), onPressed: () async {
            close();
            debugPrint('[lockdown] Đóng dialog thông báo, hiển thị dialog nhập license');
            // Đợi dialog đóng xong rồi mới hiện dialog nhập license
            await Future.delayed(const Duration(milliseconds: 300));
            showDialogRequestLicenseKey();
          }),
        ],
      );
    });
  }

  /// API: kiểm tra ngay, trả về trạng thái đã chuẩn hoá, không hiển thị dialog
  Future<LicenseStatusEnum> checkLicenseNow() async {
    try {
      final cfg = await getServerConfig();
      if (cfg == null || cfg.licenseKey.trim().isEmpty) return LicenseStatusEnum.unknown;
      final hw = await platformFFI.getDeviceId();
      String keyToSend = cfg.licenseKey.trim();
      try {
        final decrypted = await _decryptLicense(keyToSend);
        if (decrypted.isNotEmpty) keyToSend = decrypted;
      } catch (_) {}
      final ApiResponse res = await _apiClient.check(licenseKey: keyToSend, hardwareId: hw);
      return _mapStatus(res.status);
    } catch (_) {
      return LicenseStatusEnum.error;
    }
  }

  void _emitLicenseEvent(ApiResponse api, {String? hardwareId}) {
    final st = _mapStatus(api.status);
    licenseState.value = st;
    try {
      _licenseEvents.add(LicenseEvent(status: st, message: api.message, expiresAt: api.expiresAt, hardwareId: hardwareId));
    } catch (e) {
      debugPrint('[licenseEvents] emit error: $e');
    }
  }

  LicenseStatusEnum _mapStatus(String? raw) {
    switch ((raw ?? '').toLowerCase()) {
      case 'valid':
        return LicenseStatusEnum.valid;
      case 'invalid':
        return LicenseStatusEnum.invalid;
      case 'expired':
        return LicenseStatusEnum.expired;
      case 'disabled':
        return LicenseStatusEnum.disabled;
      case 'error':
        return LicenseStatusEnum.error;
      default:
        return LicenseStatusEnum.unknown;
    }
  }
}

class ApiClient {
  late final Dio _dio;

  ApiClient({required String baseUrl}) {
      debugPrint('[ApiClient] Khởi tạo với baseUrl: $baseUrl');
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
      },
    );
    _dio = Dio(options);
  }

  Future<ApiResponse> _post(String path, {required String licenseKey, required String hardwareId}) async {
      debugPrint('[_post] Gửi POST $path với licenseKey: $licenseKey, hardwareId: $hardwareId');
    final formData = d.FormData.fromMap({
      'license_key': licenseKey.trim(),
      'hardware_id': hardwareId.trim(),
    });

    try {
      final response = await _dio.post(path, data: formData);
      debugPrint('[_post] Nhận response: ${response.data}');
      return ApiResponse.fromJson(Map<String, dynamic>.from(response.data));
    } on DioException catch (e) {
      // Phân biệt lỗi nghiệp vụ (invalid/expired/disabled...) và lỗi mạng thực sự
      if (e.response != null && e.response?.data is Map) {
        final data = Map<String, dynamic>.from(e.response!.data);
        debugPrint('[_post] Lỗi nghiệp vụ từ server: $data');
        // Trả về ApiResponse để luồng xử lý bên trên quyết định hành động, tránh backoff như lỗi mạng
        return ApiResponse.fromJson(data);
      }
      final msg = e.message ?? translate('Connection or server response error');
      debugPrint('[_post] Lỗi mạng/không có response: $msg');
      throw Exception(msg);
    } catch (e) {
      debugPrint('[_post] Lỗi không xác định: $e');
      throw Exception(translate("An unknown error has occurred. Please try again"));
    }
  }


  Future<ApiResponse> ping({required String licenseKey, required String hardwareId}) {
    debugPrint('[ping] Gọi /ping.php để kiểm tra license');
    return _post('/ping.php', licenseKey: licenseKey, hardwareId: hardwareId);
  }

  Future<ApiResponse> check({required String licenseKey, required String hardwareId}) {
    debugPrint('[check] Gọi /check.php để activate/verify license');
    return _post('/check.php', licenseKey: licenseKey, hardwareId: hardwareId);
  }
}

class ApiResponse {
  final String? status;
  final String? message;
  final String? expiresAt;

  ApiResponse({this.status, this.message, this.expiresAt});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      message: json['message'],
      expiresAt: json['expires_at'],
    );
  }
}