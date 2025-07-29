<#
.SYNOPSIS
    PowerShell Smart Calculator REPL
.DESCRIPTION
    Lightweight terminal calculator with history, color output, and smart input handling.
.AUTHOR
    Minh Tuan Pham
.VERSION
    1.1
#>

# Global state
$global:last = 0
$global:calcHistory = @()

# Expression evaluator
function _cal_expr {
    param (
        [string]$expr
    )

    $expr = $expr.Trim()

    switch ($expr.ToLower()) {
        "cls" {
            Clear-Host
            return
        }
        "history" {
            foreach ($line in $global:calcHistory) {
                Write-Host $line -ForegroundColor Yellow
            }
            return
        }
    }

    # Replace 'ans' or '_' with last result
    $expr = $expr -replace '\b(ans|_)\b', $global:last.ToString()

    # Prepend last result if expression starts with an operator
    if ($expr -match '^[+\*/%^]' -or ($expr -match '^-{1}' -and $expr -notmatch '^-?\d')) {
        $expr = "$global:last $expr"
    }

    # Shorthand: "log", "ln", "sqrt", "root" with ans or fast syntax
    if ($expr -match '^log\s+(\S+)\s+(\S+)$') {
        $base = $Matches[1]
        $value = $Matches[2]
        $expr = "[math]::Log($value, $base)"
    }
    elseif ($expr -match '^log\s+(\S+)$') {
        $expr = "[math]::Log10($($Matches[1]))"
    }
    elseif ($expr -match '^log$') {
        $expr = "[math]::Log10($global:last)"
    }

    if ($expr -match '^ln$') {
        $expr = "[math]::Log($global:last)"
    }

    if ($expr -match '^sqrt$') {
        $expr = "[math]::Sqrt($global:last)"
    }

    if ($expr -match '^root\s+(\S+)\s+(\S+)$') {
        $expr = "[math]::Pow($($Matches[2]), 1/$($Matches[1]))"
    }
    elseif ($expr -match '^root\s+(\S+)$') {
        $expr = "[math]::Sqrt($($Matches[1]))"
    }
    elseif ($expr -match '^root$') {
        $expr = "[math]::Sqrt($global:last)"
    }

    # Only do regex replacements if expression doesn't already contain [math]::Log or Log10
    if ($expr -notmatch '\[math\]::Log') {
        $expr = $expr -replace 'log\(([^,()]+?),\s*([^()]+?)\)', '[math]::Log($2, $1)'
        $expr = $expr -replace 'log\(([^()]+?)\)', '[math]::Log10($1)'
    }

    # Replace ln(x)
    $expr = $expr -replace 'ln\(([^()]+?)\)', '[math]::Log($1)'

    # Replace sqrt(x)
    $expr = $expr -replace 'sqrt\(([^()]+?)\)', '[math]::Sqrt($1)'

    # Replace root(x, n)
    $expr = $expr -replace 'root\(([^,]+?),\s*([^()]+?)\)', '[math]::Pow($1, 1/$2)'

    # Replace ** or ^ with [math]::Pow()
    $expr = $expr -replace '(\d+(?:\.\d*)?)\s*(\*\*|\^)\s*(\d+(?:\.\d*)?)', '[math]::Pow($1, $3)'

    # Unknown/invalid input check
    if ($expr -notmatch '[\d\)\(]') {
        Write-Host "❓ Unknown command or invalid expression: $expr" -ForegroundColor Magenta
        return
    }

    try {
        $result = Invoke-Expression $expr
        $global:last = $result
        $global:calcHistory += "$expr = $result"
        Write-Host $result -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Error: $_" -ForegroundColor Red
    }
}


# Main REPL
function cal {
    Write-Host "`n🎉 PowerShell Smart Calculator" -ForegroundColor Cyan
    Write-Host "👤 Author: Minh Tuan Pham" -ForegroundColor DarkGray
    Write-Host "Type 'q' to quit, 'cls' to clear screen, 'history' to view history" -ForegroundColor DarkGray
    Write-Host "Supports: + - * / ^ log(x), log base x, ln(x), sqrt(x), root n x, ans, _`n" -ForegroundColor DarkGray

    while ($true) {
        Write-Host -NoNewline ">>> " -ForegroundColor Cyan
        $input = Read-Host
        if ($input -eq "q") { break }
        if ($inp
