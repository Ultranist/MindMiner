<#
MindMiner  Copyright (C) 2017  Oleg Samsonov aka Quake4
https://github.com/Quake4/MindMiner
License GPL-3.0
#>

function Out-Iam ([string] $version) {
	Write-Host "MindMiner $version" -NoNewline -ForegroundColor Cyan
	Write-Host " (C) 2017-$([datetime]::Now.Year) by Oleg Samsonov aka Quake4" -ForegroundColor White
	Write-Host
}

function Out-Header {
	Out-Iam ([Config]::Version)
	Write-Host "Help, information and other see on " -NoNewline
	Write-Host "https://github.com/Quake4/MindMiner" -ForegroundColor Green
	Write-Host
	Write-Host "Configuration:" -ForegroundColor Yellow
	Write-Host $Config
}

function Out-Footer {
	Write-Host "Information:" -ForegroundColor Yellow
	Write-Host $Summary
	Write-Host
	Write-Host "Ctrl+Q/Alt+E" -NoNewline -ForegroundColor Yellow
	Write-Host " - Exit, " -NoNewline
	Write-Host "V" -NoNewline -ForegroundColor Yellow
	Write-Host " - Verbose level $($Config.Verbose) "
	if ($global:HasConfirm -eq $false -and $global:NeedConfirm -eq $true) {
		Write-Host "Y" -NoNewline -ForegroundColor Yellow
		Write-Host " - Need Your confirmation for new miners/pools"
	}
}

function Get-Confirm {
	if ($global:HasConfirm -eq $false -and $global:NeedConfirm -eq $true) {
		Write-Host "Y" -NoNewline -ForegroundColor Yellow
		Write-Host " - Need Your confirmation for new miners/pools"
		$start = [datetime]::Now
		do {
			Start-Sleep -Milliseconds 100
			while ([Console]::KeyAvailable -eq $true) {
				[ConsoleKeyInfo] $key = [Console]::ReadKey($true)
				if ($key.Key -eq [ConsoleKey]::Y -and $global:HasConfirm -eq $false -and $global:NeedConfirm -eq $true) {
					Write-Host "Thanks ..." -ForegroundColor Green
					Start-Sleep -Milliseconds 150
					$global:HasConfirm = $true
					$global:NeedConfirm = $false
				}
				Remove-Variable key
			}
		} while (([datetime]::Now - $start).TotalSeconds -lt $Config.CheckTimeout -and !$global:HasConfirm)
		Remove-Variable start
	}
	else {
		Start-Sleep $Config.CheckTimeout
	}
}