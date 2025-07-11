# Author : Pham Minh Tuan
# Contact : tuanliz0403@gmail.com
# ~~~IMPORTANT~~~
# This is my personal config. 
# I don't claim that the functions are better than the original ones. 
# It's your preference.
# ******************************************************************************


# Jump to HCMUS
function hcmus {
    Clear-Host
    Set-Location D:\HCMUS
    l
}

# Jump to CSES
function cses {
    Set-Location C:\CSES
    l
}
# Jump to ANU
function anu {
    Set-Location D:\ANU
    l
}

# Jump to Home
function tuan {
    Set-Location ~
    l
}
function D {
    Set-Location D:\
    l
}function C {
    Set-Location C:\
    l
}
# cd but have navigation and colors
function g($Item) {
    Clear-Host
    $check = $Item -eq ".."
    if ($check) {
        Set-Location ..
        l
        return
    }
    $check = $Item.Count -eq 0
    if ($check) {
        Set-Location .
        l
        return
    }
    [string[]] $files = Get-ChildItem -Name 
    $check = $Item -isnot [int]
    if ($check) {
        Set-Location $Item
        l
        return
    }
    if ($Item -cge $files.Count -or $Item -lt 0) {
        Set-Location .
    }
    else {
        Set-Location $files[$Item]
    }
    l
}

# pwd but copy path to clipboard once done
function cur() {
    [string] $curr = Get-Location;
    Write-Host "Current path..." -ForegroundColor Yellow
    Write-Host $curr -ForegroundColor Green
    Set-Clipboard -Value $curr;
}

