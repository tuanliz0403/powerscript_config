# Author : Pham Minh Tuan
# Contact : tuanliz0403@gmail.com
# ~~~IMPORTANT~~~
# This is my personal config. 
# I don't claim that the functions are better than the original ones. 
# It's your preference.
# ******************************************************************************

# Find and compile all c file in current folder
function makec() {
    [string[]] $files = Get-ChildItem -Recurse -Filter *.c -Name
    gcc $files -o main.exe -Wall -Wextra
    if (Test-Path main.exe) {
        Write-Host "Compilation successful" -ForegroundColor Green
        $startTime = Get-Date
        ./main.exe $args
        $endTime = Get-Date
        $executionTime = $endTime - $startTime
        Write-Host "Execution time: $($executionTime.TotalSeconds) seconds" -ForegroundColor Yellow
        Remove-Item main.exe
    }
    else {
        Write-Host "Compilation failed" -ForegroundColor Red
    }
}
# Find and compile all cpp file in current folder
function makecpp {
    [string[]] $files = Get-ChildItem -Recurse -Filter *.cpp -Name
    g++ $files -o main.exe -Wall -Wextra
    if (Test-Path main.exe) {
        Write-Host "Compilation successful" -ForegroundColor Green
        $startTime = Get-Date
        ./main.exe $args
        $endTime = Get-Date
        $executionTime = $endTime - $startTime
        Write-Host "Execution time: $($executionTime.TotalSeconds) seconds" -ForegroundColor Yellow
        Remove-Item main.exe
    }
    else {
        Write-Host "Compilation failed" -ForegroundColor Red
    }
}
# Find and compile requested .c file name in current folder
function bld {
    for ($i = 0; $i -lt $args.Count; $i++) {
        $args[$i] = $args[$i] + ".c"
    }
    gcc $args -o main.exe -Wall -Wextra -g
    if (Test-Path main.exe) {
        Write-Host "Compilation successful" -ForegroundColor Green
        $startTime = Get-Date
        ./main.exe
        $endTime = Get-Date
        $executionTime = $endTime - $startTime
        Write-Host "Execution time: $($executionTime.TotalSeconds) seconds" -ForegroundColor Yellow
        Remove-Item main.exe
    }
    else {
        Write-Host "Compilation failed" -ForegroundColor Red
        return
    }
}
# Find and compile requested .cpp file name in current folder
function bld+() {
    for ($i = 0; $i -lt $args.Count; $i++) {
        $args[$i] = $args[$i] + ".cpp"
    }
    g++ $args -o main.exe -Wall -Wextra -g
    if (Test-Path main.exe) {
        Write-Host "Compilation successful" -ForegroundColor Green
        $startTime = Get-Date
        ./main.exe
        $endTime = Get-Date
        $executionTime = $endTime - $startTime
        Write-Host "Execution time: $($executionTime.TotalSeconds) seconds" -ForegroundColor Yellow
        Remove-Item main.exe
    }
    else {
        Write-Host "Compilation failed" -ForegroundColor Red
        return
    }
}

