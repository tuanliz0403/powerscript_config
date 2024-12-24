# Author : Pham Minh Tuan
# Contact : tuanliz0403@gmail.com
# ~~~IMPORTANT~~~
# This is my personal config. 
# I don't claim that the functions are better than the original ones. 
# It's your preference.
# ******************************************************************************

# Clear the screen
function cl {
    Clear-Host 
    l
}

# Return power of a and b and copy to clipboard
function pow() {
    $res = [math]::Pow($args[0], $args[1])
    $baseNumber = $args[0]
    $expo = $args[1]
    Write-Host "$baseNumber ^ $expo = $res"
    Set-Clipboard -Value $res
}

# Return root of a and copy to clipboard
function rt() {
    $res = [math]::Pow($args[0], 1 / $args[1])
    $base = $args[0]
    $expo = $args[1]
    Write-Host "$expo √ $base = $res"
    Set-Clipboard -Value $res
}

# Read file in hex
function hex {
    param (
        [string]$FileName, 
        [int]$BytesPerLine = 8   
    )
    $FilePath = if ([System.IO.Path]::IsPathRooted($FileName)) {
        $FileName
    }
    else {  
        Join-Path -Path (Get-Location) -ChildPath $FileName
    }
    if (-not (Test-Path $FilePath)) {
        Write-Error "File not found: $FilePath"
        return
    }
    try {
        $fileBytes = [System.IO.File]::ReadAllBytes($FilePath)
    }
    catch {
        Write-Error "Failed to read file: $($_.Exception.Message)" -ForegroundColor Red
        return
    }
    $offset = 0
    $clipboardValue = ""
    if ($fileBytes.Length) {
        Write-Host "Reading file [$FileName]: " -ForegroundColor Green
    }
    else {
        Write-Host "File [$FileName] is empty. " -ForegroundColor Red
    }
    while ($offset -lt $fileBytes.Length) {
        $hexLine = ($fileBytes[$offset..([Math]::Min($offset + $BytesPerLine - 1, $fileBytes.Length - 1))] |
            ForEach-Object { '{0:X2}' -f $_ }) -join ' '
        $asciiLine = ($fileBytes[$offset..([Math]::Min($offset + $BytesPerLine - 1, $fileBytes.Length - 1))] |
            ForEach-Object { if ($_ -ge 32 -and $_ -le 126) { [char]$_ } else { '.' } }) -join ''
        '{0:X8}  {1,-10}  {2}' -f $offset, $hexLine, $asciiLine
        $offset += $BytesPerLine
        $clipboardValue += $asciiLine
    }
    Set-Clipboard -Value $clipboardValue
    if ($MyInvocation.InvocationName -eq '.\Read-HexFile.ps1' -and $args.Count -ge 1) {
        Read-HexFile -FileName $args[0]
    }
}
    
    
# Read file in bin
function bin {
    param (
        [string]$FileName, 
        [int]$BytesPerLine = 8
    )
    $FilePath = if ([System.IO.Path]::IsPathRooted($FileName)) {
        $FileName
    }
    else {
        Join-Path -Path (Get-Location) -ChildPath $FileName
    }
    if (-not (Test-Path $FilePath)) {
        Write-Error "File not found: $FilePath"
        return
    }
    try {
        $fileBytes = [System.IO.File]::ReadAllBytes($FilePath)
    }
    catch {
        Write-Error "Failed to read file: $($_.Exception.Message)" -ForegroundColor Red
        return
    }
    $offset = 0
    $clipboardValue = ""
    if ($fileBytes.Length) {
        Write-Host "Reading file [$FileName]: " -ForegroundColor Green
    }
    else {
        Write-Host "File [$FileName] is empty. " -ForegroundColor Red
    }
    while ($offset -lt $fileBytes.Length) {
        $binaryLine = ($fileBytes[$offset..([Math]::Min($offset + $BytesPerLine - 1, $fileBytes.Length - 1))] |
            ForEach-Object { '{0:B8}' -f $_ }) -join ' '
        $asciiLine = ($fileBytes[$offset..([Math]::Min($offset + $BytesPerLine - 1, $fileBytes.Length - 1))] |
            ForEach-Object { if ($_ -ge 32 -and $_ -le 126) { [char]$_ } else { '.' } }) -join ''
        '{0:X8}  {1,-25}  {2}' -f $offset, $binaryLine, $asciiLine
        $offset += $BytesPerLine
        $clipboardValue += $asciiLine
    }
    Set-Clipboard -Value $clipboardValue
    if ($MyInvocation.InvocationName -eq '.\Read-BinFile.ps1' -and $args.Count -ge 1) {
        Read-BinFile -FileName $args[0]
    }
}



# Get meta data
function metadata {
    <#
        .SYNOPSIS
            Get file metadata from files in a target folder.
        
        .DESCRIPTION
            Retreives file metadata from files in a target path, or file paths, to display information on the target files.
            Useful for understanding application files and identifying metadata stored in them. Enables the administrator to view metadata for application control scenarios.

        .NOTES
            Author: Aaron Parker
            Twitter: @stealthpuppy
        
        .LINK
            https://github.com/aaronparker/Install-VisualCRedistributables

        .OUTPUTS
            [System.Array]

        .PARAMETER Path
            A target path in which to scan files for metadata.

        .PARAMETER Include
            Gets only the specified items.

        .EXAMPLE
            Get-FileMetadata -Path "C:\Users\aaron\AppData\Local\GitHubDesktop"

            Description:
            Scans the folder specified in the Path variable and returns the metadata for each file.
    #>
    [CmdletBinding(SupportsShouldProcess = $False)]
    [OutputType([Array])]
    Param (
        [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, `
                HelpMessage = 'Specify a target path, paths or a list of files to scan for metadata.')]
        [Alias('FullName', 'PSPath')]
        [string[]]$Path,

        [Parameter(Mandatory = $False, Position = 1, ValueFromPipeline = $False, `
                HelpMessage = 'Gets only the specified items.')]
        [Alias('Filter')]
        [string[]]$Include = @('*.exe', '*.dll', '*.ocx', '*.msi', '*.ps1', '*.vbs', '*.js', '*.cmd', '*.bat')
    )
    Begin {
        # Measure time taken to gather data
        $StopWatch = [system.diagnostics.stopwatch]::StartNew()

        # RegEx to grab CN from certificates
        $FindCN = "(?:.*CN=)(.*?)(?:,\ O.*)"

        Write-Verbose "Beginning metadata trawling."
        $Files = @()
    }
    Process {
        # For each path in $Path, check that the path exists
        ForEach ($Loc in $Path) {
            If (Test-Path -Path $Loc -IsValid) {
                # Get the item to determine whether it's a file or folder
                If ((Get-Item -Path $Loc).PSIsContainer) {
                    # Target is a folder, so trawl the folder for .exe and .dll files in the target and sub-folders
                    Write-Verbose "Getting metadata for files in folder: $Loc"
                    $items = Get-ChildItem -Path $Loc -Recurse -Include $Include
                }
                Else {
                    # Target is a file, so just get metadata for the file
                    Write-Verbose "Getting metadata for file: $Loc"
                    $items = Get-Item -Path $Loc
                }

                # Create an array from what was returned for specific data and sort on file path
                $Files += $items | Select-Object @{Name = "Path"; Expression = { $_.FullName } }, `
                @{Name = "Owner"; Expression = { (Get-Acl -Path $_.FullName).Owner } }, `
                @{Name = "Vendor"; Expression = { $(((Get-AcDigitalSignature -Path $_ -ErrorAction SilentlyContinue).Subject -replace $FindCN, '$1') -replace '"', "") } }, `
                @{Name = "Company"; Expression = { $_.VersionInfo.CompanyName } }, `
                @{Name = "Description"; Expression = { $_.VersionInfo.FileDescription } }, `
                @{Name = "Product"; Expression = { $_.VersionInfo.ProductName } }, `
                @{Name = "ProductVersion"; Expression = { $_.VersionInfo.ProductVersion } }, `
                @{Name = "FileVersion"; Expression = { $_.VersionInfo.FileVersion } }
            }
            Else {
                Write-Error "Path does not exist: $Loc"
            }
        }
    }
    End {

        # Return the array of file paths and metadata
        $StopWatch.Stop()
        Write-Verbose "Metadata trawling complete. Script took $($StopWatch.Elapsed.TotalMilliseconds) ms to complete."
        Return $Files | Sort-Object -Property Path
    }
}

# wget on window
function wget() {
    foreach ($link in $args) {
        Invoke-WebRequest $link -OutFile ./
    }
}

# Get char
function tochar() {
    foreach ($char in $args) {
        [System.Convert]::ToChar($char) | Write-Host -NoNewline
    }
}


