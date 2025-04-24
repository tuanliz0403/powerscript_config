function bldJava([string]$name) {
    $compilefile = $name + ".java"
    javac $compilefile
    $exefile = $name
    if (Test-Path $exefile) {
        Write-Host "Compilation successful" -ForegroundColor Green
        $startTime = Get-Date
        java $exefile
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