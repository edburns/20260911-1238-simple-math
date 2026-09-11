BeforeAll {
    $scriptPath = Join-Path $PSScriptRoot 'math-tool.ps1'
    . $scriptPath -N 0
}

Describe 'Get-Fibonacci' {
    It 'returns zero for the first base case' {
        Get-Fibonacci -N 0 | Should -Be 0
    }

    It 'returns one for the second base case' {
        Get-Fibonacci -N 1 | Should -Be 1
    }

    It 'returns the recurrence result for a representative value' {
        Get-Fibonacci -N 6 | Should -Be 8
    }

    It 'returns one numeric pipeline value without incidental output' {
        $output = @(Get-Fibonacci -N 6)

        $output.Count | Should -Be 1
        $output[0] | Should -BeOfType ([System.Numerics.BigInteger])
    }
}

Describe 'math-tool CLI' {
    It 'writes exactly one Fibonacci result line in an isolated process' {
        $pwshPath = (Get-Process -Id $PID).Path
        $output = @(& $pwshPath -NoLogo -NoProfile -File $scriptPath -N 6)
        $exitCode = $LASTEXITCODE

        $exitCode | Should -Be 0
        $output.Count | Should -Be 1
        $output[0] | Should -BeExactly 'Fibonacci(6) = 8'
    }
}
