# Enable WinRM
Set-Item -Path WSMan:\localhost\Service\AllowUnencrypted -Value $true
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true

# Enable firewall rules
Enable-PSRemoting -Force
New-NetFirewallRule -DisplayName "Allow WinRM" -Direction Inbound -Protocol TCP -LocalPort 5985 -Action Allow

# Set execution policy
Set-ExecutionPolicy Unrestricted -Force

# Optional: install additional software/tools
# Write-Host "Installing tools..."
# choco install 7zip -y
