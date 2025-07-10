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
        Write-Output $result
    }
    catch {
        Write-Host "❌ Error: $_"
    }
}

function calc-repl {
    Write-Host "PowerShell Smart Calculator (type 'exit' to quit, 'clear' to reset, 'history' to view history)"
    while ($true) {
        $input = Read-Host ">>>"
        if ($input -eq "exit") { break }
        if ($input -eq "") { continue }
        calc $input
    }
}
