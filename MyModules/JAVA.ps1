function bldJava {
    param([string]$name)
    if ($name -notlike '*.java') {
        $compilefile = "$name.java"
    } else {
        $compilefile = $name
    }
    javac $compilefile
    $exefile = "$name.class"
    if (Test-Path $exefile) {
        Write-Host "Compilation successful" -ForegroundColor Green
        $startTime = Get-Date
        java $name
        $endTime = Get-Date
        $executionTime = $endTime - $startTime
        Write-Host "Execution time: $($executionTime.TotalSeconds) seconds" -ForegroundColor Yellow
        Remove-Item $exefile
    }
    else {
        Write-Host "Compilation failed" -ForegroundColor Red
    }
}
function bldj {
    param([string]$name, [string[]]$args)
    $compilefile = $name
    Write-Host $args
    java --enable-preview $compilefile $args
}