 param (
[Parameter(Mandatory = $true)] $FileShareName, 
[Parameter(Mandatory = $true)]$StorageAccountName,
[Parameter(Mandatory = $true)] $key, 
[Parameter(Mandatory = $true)]$DriveLetter
)




$connectTestResult = Test-NetConnection -ComputerName $StorageAccountName.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"$StorageAccountName.file.core.windows.net`" /user:`"localhost\$StorageAccountName`" /pass:`"$key`""
    # Mount the drive
    New-PSDrive -Name $DriveLetter -PSProvider FileSystem -Root \\$StorageAccountName.file.core.windows.net\$FileShareName -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
 
