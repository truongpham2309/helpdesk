on run {daemon_file, agent_file, user}

  set sh1 to "echo " & quoted form of daemon_file & " > /Library/LaunchDaemons/com.carriez.RustDesk_service.plist && chown root:wheel /Library/LaunchDaemons/com.carriez.RustDesk_service.plist;"

  set sh2 to "echo " & quoted form of agent_file & " > /Library/LaunchAgents/com.carriez.RustDesk_server.plist && chown root:wheel /Library/LaunchAgents/com.carriez.RustDesk_server.plist;"

  -- Try HelpDesk pref dir first, fall back to RustDesk if present
  set sh3 to "if [ -f /Users/" & user & "/Library/Preferences/com.carriez.HelpDesk/HelpDesk.toml ]; then cp -rf /Users/" & user & "/Library/Preferences/com.carriez.HelpDesk/HelpDesk.toml /var/root/Library/Preferences/com.carriez.HelpDesk/; \
  elif [ -f /Users/" & user & "/Library/Preferences/com.carriez.RustDesk/RustDesk.toml ]; then cp -rf /Users/" & user & "/Library/Preferences/com.carriez.RustDesk/RustDesk.toml /var/root/Library/Preferences/com.carriez.RustDesk/; fi;"

  set sh4 to "if [ -f /Users/" & user & "/Library/Preferences/com.carriez.HelpDesk/HelpDesk2.toml ]; then cp -rf /Users/" & user & "/Library/Preferences/com.carriez.HelpDesk/HelpDesk2.toml /var/root/Library/Preferences/com.carriez.HelpDesk/; \
  elif [ -f /Users/" & user & "/Library/Preferences/com.carriez.RustDesk/RustDesk2.toml ]; then cp -rf /Users/" & user & "/Library/Preferences/com.carriez.RustDesk/RustDesk2.toml /var/root/Library/Preferences/com.carriez.RustDesk/; fi;"

  set sh5 to "launchctl load -w /Library/LaunchDaemons/com.carriez.RustDesk_service.plist;"

  set sh to sh1 & sh2 & sh3 & sh4 & sh5

  do shell script sh with prompt "RustDesk wants to install daemon and agent" with administrator privileges
end run
