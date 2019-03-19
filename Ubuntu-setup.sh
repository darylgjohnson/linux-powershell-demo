Settting up Ubuntu 18.04.2 LTS:
	apt-get update
# From https://github.com/PowerShell/PowerShell/issues/3708
apt install krb5-multidev libkrb5-dev gss-ntlmssp -y
# and this is from https://github.com/PowerShell/PowerShell/issues/3708
apt install liblttng-ust0 liburcu6 liblttng-ust-ctl4 -y
# From https://github.com/PowerShell/PowerShell/releases/tag/v6.1.3
wget https://github.com/PowerShell/PowerShell/releases/download/v6.1.3/powershell_6.1.3-1.ubuntu.18.04_amd64.deb
dpkg –i powershell_6.1.3-1.ubuntu.18.04_amd64.deb

#Then if Windows is ready Start PowerShell:

pwsh
# $ABCDE = get-credential
# ABCDE\administrator
# Password123!
# Enter-PSsession –ComputerName 192.168.219.131 –Credential $ABCDE –Authentication Negotiate
