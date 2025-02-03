function bldhask([string]$name) {
    $compilefile = $name + ".hs"
    ghc $compilefile
    $exefile = $name + ".exe"
    if (Test-Path $exefile) {
        Write-Host "Compilation successful" -ForegroundColor Green
        $startTime = Get-Date
        Start-Process $exefile
        $endTime = Get-Date
        $executionTime = $endTime - $startTime
        Write-Host "Execution time: $($executionTime.TotalSeconds) seconds" -ForegroundColor Yellow
        Remove-Item $exefile
    }
    else {
        Write-Host "Compilation failed" -ForegroundColor Red
        return
    }
}