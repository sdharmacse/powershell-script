# Copyright (c) 2021 Teradici Corporation
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

#
# Script downloaded from https://activedirectorypro.com/create-bulk-users-active-directory/
# on 2019.03.22. Modified for Teradici use.
#

Write-Output "Waiting for AD services"

$Count = 240 # Wait 20 mins

Do {
    Write-Host "." -NoNewline -ForegroundColor Gray
    Start-Sleep -Seconds 5
    # Query AD for the local computer
    Get-ADComputer $env:COMPUTERNAME | Out-Null

    if ($? -eq $true) {
        break;
    }
    else {
        $Count--;
        if ($Count -le 0) {
            throw 'Wait for AD services timed out'
        }
    }
} While ($Count -gt 0)

#Store the data from ADUsers.csv in the $ADUsers variable
$ADUsers = Import-csv ${csv_file}

Write-Output "Creating new AD Domain Users from CSV file..."

#Loop through each row containing user details in the CSV file 
foreach ($User in $ADUsers) {
    #Read user data from each field in each row and assign the data to a variable as below

    $Username = $User.username
    $Password = $User.password
    $Firstname = $User.firstname
    $Lastname = $User.lastname
    $Isadmin = $User.isadmin

    #Check to see if the user already exists in AD
    if (Get-ADUser -F { SamAccountName -eq $Username }) {
        #If user does exist, give a warning
        Write-Warning "A user account with username $Username already exist in Active Directory."
    }
    else {
        #User does not exist then proceed to create the new user account

        #Account will be created in the OU provided by the $OU variable read from the CSV file
        New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@${domain_name}" `
            -Name "$Firstname $Lastname" `
            -GivenName $Firstname `
            -Surname $Lastname `
            -Enabled $True `
            -DisplayName "$Lastname, $Firstname" `
            -AccountPassword (convertto-securestring $Password -AsPlainText -Force) -ChangePasswordAtLogon $False

        if ($Isadmin -eq "true") {
            Add-ADGroupMember `
                -Identity "Domain Admins" `
                -Members $Username
        }
    }
}
