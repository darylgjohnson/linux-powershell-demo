$NETBIOS_name = “ABCDE”
$Computername = “ABCD”
$DomainName = “ABCD.local”
$password = “password123!”
$secure = ConvertTo-SecureString $password -AsPlainText -force

#	Make sure administrator has a strong, compliant password
$AdmUser = Get-LocalUser –Name “administrator”
$AdmUser | Set-LocalUser –Password $secure

# SET computer name

 
#	Make sure server has a static IPv4 address and DNS server is pointed to itself
# optionally turn off all IPv6
foreach ($id in (Get-NetAdapterBinding -ComponentID ms_tcpip6).name ) { Disable-NetAdapterBinding -Name $id -ComponentID ms_tcpip6 }
# if network is not “Ethernet0” fix these
$NICname = (Get-NetAdapter | Select-Object InterfaceAlias).interfacealias 
$myIP = (Get-NetAdapter -Name $NICname | Get-NetIPAddress).IPv4Address.tostring()
$myDNS = (Get-NetAdapter -Name $NICname | get-DNSclientServerAddress)
$myGATEWAYS = (Get-NetAdapter -Name $NICname | Get-NetRoute ).NextHop
foreach ($gw in ($myGATEWAYS)) {if ((Compare-Object -IncludeEqual -ExcludeDifferent $myIP.split(".") $gw.split(".")).count -ne 0) {$myGATEWAY = $gw }}
Get-NetAdapter -name $NICname | Remove-NetIPAddress –confirm:$false
New-NetIPAddress -InterfaceAlias $NICname -IPAddress $myIP -PrefixLength 24 -DefaultGateway $myGATEWAY
Get-NetIPAddress -InterfaceAlias $NICname | Set-DnsClientServerAddress -ServerAddresses $myDNS.serveraddresses

Get-windowsfeature	
Install-windowsfeature -name AD-Domain-Services –IncludeManagementTools
Import-Module ADDSDeployment
$secure = ConvertTo-SecureString $password -AsPlainText -force
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "WinThreshold" -DomainName $DomainName `
     -DomainNetbiosName $NETBIOS_name -ForestMode "WinThreshold" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$false `
     -SysvolPath "C:\Windows\SYSVOL" -Force:$true –safeModeAdministratorPassword $secure
