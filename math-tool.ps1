[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateRange(0, [int]::MaxValue)]
    [int] $N
)

function Get-Fibonacci {
    [OutputType([System.Numerics.BigInteger])]
    param(
        [Parameter(Mandatory)]
        [ValidateRange(0, [int]::MaxValue)]
        [int] $N
    )

    $previous = [System.Numerics.BigInteger]::Zero
    $current = [System.Numerics.BigInteger]::One

    for ($index = 0; $index -lt $N; $index++) {
        $next = $previous + $current
        $previous = $current
        $current = $next
    }

    return $previous
}

if ($MyInvocation.InvocationName -ne '.') {
    $value = Get-Fibonacci -N $N
    Write-Output "Fibonacci($N) = $value"
}
