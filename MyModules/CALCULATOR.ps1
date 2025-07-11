# Global variables
$global:last = 0
$global:calcHistory = @()

function calc {
    param (
        [string]$expr
    )

    $expr = $expr.Trim()

    # Handle special commands
    switch ($expr.ToLower()) {
        "clear" {
            $global:last = 0
            Write-Output "Result cleared (0)"
            return
        }
        "history" {
            $global:calcHistory | ForEach-Object { Write-Host $_ }
            return
        }
        default {}
    }

    # Support for "ans" keyword
    $expr = $expr -replace '\bans\b', $global:last.ToString()

    # Support leading operator like +3, *2, etc.
    if ($expr -match '^[+\-*/%]') {
        $expr = "$global:last $expr"
    }

    try {
        # Power operator support: replace ** with ^ (PowerShell's syntax)
        $safeExpr = $expr -replace '\*\*', '^'

        $result = Invoke-Expression $safeExpr
        $global:last = $result
        $global:calcHistory += "$expr = $result"
        Write-Host $result -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Error: $_"
    }
}

function repl {
    Write-Host "REPL Activated. Author: Minh Tuan Pham" -ForegroundColor Green
    Write-Host "exit-clear-history" -ForegroundColor Yellow
    while ($true) {
        $input = Read-Host "Minh Tuan Pham>>>"
        if ($input -eq "exit") { break }
        if ($input -eq "") { continue }
        calc $input
    }
}
