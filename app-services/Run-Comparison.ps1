$ErrorActionPreference = 'Stop'
$resourceGroup = "rg-temp2-temp-001"

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Write-host "My directory is $dir"
Set-Location $dir

function Invoke-TerraformTest() { 

    write-host "starting timer"
    $stopwatch = [system.diagnostics.stopwatch]::StartNew()

    terraform init

    terraform plan -detailed-exitcode

    terraform apply -auto-approve

    $stopwatch.Stop();

    Write-Host "terraform: time elapsed was $($stopwatch.Elapsed)"
}

function Invoke-ArmTest() {

    write-host "starting timer"
    $stopwatch = [system.diagnostics.stopwatch]::StartNew()

    
    az group create -g $resourceGroup -l eastus

    az group deployment create -g $resourceGroup --template-file appservices.json

    $stopwatch.Stop();

    Write-Host "arm: time elapsed was $($stopwatch.Elapsed)"
}

function Reset-All {
    terraform destroy -auto-approve
    
    write-host 'deleting resource group created by arm template'
    az group delete -g $resourceGroup -y
}

Invoke-TerraformTest
Invoke-ArmTest
Reset-All


