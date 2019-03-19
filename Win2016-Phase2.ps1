# After reboot:
set-ItemProperty -path "Registry::HKLM\Software\Policies\Microsoft\Netlogon\Parameters" -name "AllowNT4Crypto" -value 1

# Then configure winrm 
winrm quickconfig
Enable-PSRemoting
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
Set-Item "wsman:\localhost\client\trustedhosts" -Value '*' –Force
winrm set winrm/config/client '@{AllowUnencrypted="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
