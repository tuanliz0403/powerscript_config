# Author : Pham Minh Tuan
# Contact : tuanliz0403@gmail.com
# ~~~IMPORTANT~~~
# This is my personal config. 
# I don't claim that the functions are better than the original ones. 
# It's your preference.
# ******************************************************************************

# Create new folder and jump to it
function mkd ($FolderName) {
    mkdir $FolderName
    Set-Location "$FolderName"
}
# Start a process
function st($Item) {
    [string[]]$files = Get-ChildItem -Name 
    if ($Item -is [int]) {
        if ($Item -lt 0 -or $Item -cge $files.Count) {
            Write-Host "Invalid arguments" -ForegroundColor Red
        }
        else {
            Write-Host "Running $($files[$Item])..." -ForegroundColor Cyan
            Start-Process $files[$Item]
        }
    }
    else {
        if (Test-Path $Item) {
            Write-Host "Running $Item..." -ForegroundColor Cyan
            Start-Process $Item
        }
        else {
            Write-Host "File not found" -ForegroundColor Red
        }
    }
}

# Create multiple files
function nf() {
    Clear-Host
    for ($i = 0; $i -lt $args.Count; $i++) {
        Write-Host "#$i : Creating " $args[$i] -ForegroundColor Cyan
        New-Item -ItemType File -Name $args[$i] | Out-Null 
    }    
    l
} 

# Remove multiple files and send them to recycle bin
function rf () {
    # Clear-Host
    $currentPath = Get-Location
    for ($i = 0; $i -lt $args.Count; $i++) {
        $item = Join-Path -Path $currentPath -ChildPath $args[$i]
        if (Test-Path $item) {
            try {
                $filename = $args[$i]
                Write-Host "#$i : Moving" -NoNewline -ForegroundColor Cyan
                Write-Host $filename -NoNewline -ForegroundColor white
                Write-Host " to Recycle Bin" -ForegroundColor Cyan
                [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($item, 'OnlyErrorDialogs', 'SendToRecycleBin')
                Write-Host "Successfully moved " -NoNewline -ForegroundColor Green
                Write-Host $filename -NoNewline -ForegroundColor white
                Write-Host " to Recycle Bin" -ForegroundColor Green
            }
            catch {
                $filename = $args[$i]
                Write-Host "Failed to move " -NoNewline -ForegroundColor Red
                Write-Host $filename -NoNewline -ForegroundColor white
                Write-Host "  to Recycle Bin: $_" -ForegroundColor Red
            }
        }
        else {
            $filename = $args[$i]
            Write-Host "#Item not found: " -NoNewline -ForegroundColor Red
            Write-Host $filename -ForegroundColor white
        }
    }
    l
}

# Create multiple files and open them in VSCODE
function cf() {
    Clear-Host
    code -n .
    for ($i = 0; $i -lt $args.Count; $i++) {
        Write-Host "#$i : Creating " $args[$i] -ForegroundColor Cyan
        New-Item -ItemType File -Name $args[$i] | Out-Null 
        code $args[$i]
    }    
    l
} 
