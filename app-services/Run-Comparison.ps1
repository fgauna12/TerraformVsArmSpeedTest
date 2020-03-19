$ErrorActionPreference = 'Stop'

function Run-TerraformTest() {
    $scriptpath = $MyInvocation.MyCommand.Path
    $dir = Split-Path $scriptpath
    Write-host "My directory is $dir"

    Set-Location $dir

    write-host "starting timer"
    $stopwatch = [system.diagnostics.stopwatch]::StartNew()

    terraform init

    terraform plan -detailed-exitcode

    terraform apply -auto-approve

    $stopwatch.Stop();

    Write-Host "time elapsed was $($stopwatch.Elapsed)"
}

Run-TerraformTest