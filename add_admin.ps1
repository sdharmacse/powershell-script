# Copyright (c) 2021 Teradici Corporation
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

# Make sure this file has Windows line endings

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

$STAGE_FILE = "C:\Teradici\stage2.txt"

# Service account needs to be in Domain Admins group for realm join to work on CentOS
Add-ADGroupMember -Identity "Domain Admins" -Members "${account_name}"

# Write a stage file so we can tall this stage is complete
Set-Content -Path $STAGE_FILE -Value 'stagecomplete'

