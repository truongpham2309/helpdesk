# 🚀 HelpDesk - Build & Run Scripts

## ⚡ QUICKSUPPORT (Không cần license)

### 1. Cấu hình
Sửa file `flutter/.env`:
```bash
IS_QUICKSUPPORT=true
```

### 2. Chạy (Run)
```powershell
Remove-Item -Recurse -Force "$env:APPDATA\HelpDesk*" -ErrorAction SilentlyContinue; cd flutter; flutter run -d windows --release
```

### 3. Build
```powershell
python build.py --flutter --quicksupport
```

---

## 📦 NORMAL (Đầy đủ - Cần license)

### 1. Cấu hình
Sửa file `flutter/.env`:
```bash
IS_QUICKSUPPORT=false
```

### 2. Chạy (Run)
```powershell
Remove-Item -Recurse -Force "$env:APPDATA\HelpDesk*" -ErrorAction SilentlyContinue; cd flutter; flutter run -d windows --release
```

### 3. Build
```powershell
python build.py --flutter
```

---

## 💡 Sử dụng

**NORMAL**: Production, user chính thức, cần license  
**QUICKSUPPORT**: Demo, hỗ trợ nhanh, không cần license
