# Author : Pham Minh Tuan
# Contact : tuanliz0403@gmail.com
# ~~~IMPORTANT~~~
# This is my personal config. 
# I don't claim that the functions are better than the original ones. 
# It's your preference.
# ******************************************************************************

# List all file with given name
function lf ($FileName) {
    # Tìm tên file kiểu main.***, dùng flag Recurse (giống backtrack), flag filter (filter tên), flag name (để lấy tên file thôi, không xuất ra size hay blah blah) 
    $folders = Get-ChildItem -Recurse -Filter $FileName* -Name
    if ($folders.Count -eq 0) {
        Write-Host "No files found with the name pattern [" -NoNewline -ForegroundColor Red
        Write-Host "$FileName" -NoNewline -ForegroundColor White
        Write-Host "]." -ForegroundColor Red
    }
    else {
        Write-Host "Files found with the name pattern [" -NoNewline -ForegroundColor Yellow
        Write-Host "$FileName" -NoNewline -ForegroundColor White
        Write-Host "]:" -ForegroundColor Yellow
        $index = 1
        foreach ($folder in $folders) {
            Write-Host "$index. $folder" -ForegroundColor Green
            $index++
        }
        Set-Clipboard -Value ($folders -join "`n")
        Write-Host "The file list has been copied to the clipboard." -ForegroundColor Magenta
    }
}

# List all file with given file extension
function le ($FileName) {
    # Tìm đuôi file kiểu ***.cpp, dùng flag Recurse (giống backtrack), flag filter (filter tên), flag name (để lấy tên file thôi, không xuất ra size hay blah blah) 
    $files = Get-ChildItem -Recurse -Filter *.$FileName -Name
    if ($files.Count -eq 0) {   
        Write-Host "No files found with the extension ." -NoNewline -ForegroundColor Yellow
        Write-Host ".${FileName}" -NoNewline -ForegroundColor White
        Write-Host "." -ForegroundColor Red
    }
    else {
        Write-Host "Files found with the extension :" -NoNewline -ForegroundColor Yellow
        Write-Host ".${FileName}" -NoNewline -ForegroundColor White
        Write-Host " :" -ForegroundColor Yellow
        $index = 1
        foreach ($file in $files) {
            Write-Host "$index. $file" -ForegroundColor Green
            $index++
        }C:\Users\tuanl\OneDrive\Documents\PowerShell\
        Set-Clipboard -Value ($files -join "`n")
        Write-Host "The list has been copied to the clipboard." -ForegroundColor Magenta
    }
}

# Find a file
function find ($FileName) {
    Get-ChildItem -Recurse -Filter $FileName
}

# List all file and folders in current directory
function l () {
    $currdir = Split-Path -Path (Get-Location) -Leaf
    Write-Host "List of items in " -NoNewline -ForegroundColor Yellow
    Write-Host $currdir -NoNewline -ForegroundColor White
    Write-Host " are:" -ForegroundColor Yellow
    Write-Host "=============================" -ForegroundColor Cyan
    [string[]]$files = Get-ChildItem -Name
    for ($i = 0; $i -lt $files.Count; $i++) {
        Write-Host ("{0,2}. {1}" -f $i, $files[$i]) -ForegroundColor Green
    }
    Write-Host "=============================" -ForegroundColor Cyan
    Write-Host "Total items: $($files.Count)" -ForegroundColor Red
}