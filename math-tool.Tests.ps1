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

Describe 'Get-Factorial' {
    It 'returns one for the zero base case' {
        Get-Factorial -N 0 | Should -Be 1
    }

    It 'returns one for the first base case' {
        Get-Factorial -N 1 | Should -Be 1
    }

    It 'returns the product for a representative value' {
        Get-Factorial -N 5 | Should -Be 120
    }

    It 'returns one numeric pipeline value without incidental output' {
        $output = @(Get-Factorial -N 5)

        $output.Count | Should -Be 1
        $output[0] | Should -BeOfType ([System.Numerics.BigInteger])
    }
}

Describe 'math-tool CLI' {
    BeforeAll {
        $pwshPath = (Get-Process -Id $PID).Path
    }

    It 'writes exactly one Fibonacci result line in an isolated process' {
        $output = @(& $pwshPath -NoLogo -NoProfile -File $scriptPath -N 6)
        $exitCode = $LASTEXITCODE

        $exitCode | Should -Be 0
        $output.Count | Should -Be 1
        $output[0] | Should -BeExactly 'Fibonacci(6) = 8'
    }

    It 'writes exactly one Fibonacci result line when the operation is selected explicitly' {
        $output = @(& $pwshPath -NoLogo -NoProfile -File $scriptPath -N 6 -Operation fibonacci)
        $exitCode = $LASTEXITCODE

        $exitCode | Should -Be 0
        $output.Count | Should -Be 1
        $output[0] | Should -BeExactly 'Fibonacci(6) = 8'
    }

    It 'writes exactly one factorial result line when factorial is selected' {
        $output = @(& $pwshPath -NoLogo -NoProfile -File $scriptPath -N 5 -Operation factorial)
        $exitCode = $LASTEXITCODE

        $exitCode | Should -Be 0
        $output.Count | Should -Be 1
        $output[0] | Should -BeExactly 'Factorial(5) = 120'
    }

    It 'dispatches to the calculation matching the selected operation' {
        $fibonacci = @(& $pwshPath -NoLogo -NoProfile -File $scriptPath -N 5 -Operation fibonacci)
        $factorial = @(& $pwshPath -NoLogo -NoProfile -File $scriptPath -N 5 -Operation factorial)

        $fibonacci[0] | Should -BeExactly 'Fibonacci(5) = 5'
        $factorial[0] | Should -BeExactly 'Factorial(5) = 120'
    }

    It 'rejects an unsupported operation instead of producing a result line' {
        $output = @(& $pwshPath -NoLogo -NoProfile -File $scriptPath -N 5 -Operation triangular 2>&1)
        $exitCode = $LASTEXITCODE

        $exitCode | Should -Not -Be 0
        $output -join "`n" | Should -Not -Match '(Fibonacci|Factorial)\(5\) ='
    }
}
