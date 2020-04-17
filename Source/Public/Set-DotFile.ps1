Function Set-Dotfile {
    <#
    .SYNOPSIS
    Hide dotfiles (.*) similar to *nix shells.

    .DESCRIPTION
    Set the file attribute to Hidden for files beginning with a period (.*).

    .PARAMETER Path
    Full or relative Path to a directory or comma separated list of directories
    containing dotfiles.

    .PARAMETER Recurse
    Recurse through sub-directories.

    .PARAMETER Force
    The name of a file to write failed computer names to. Defaults to errors.txt.
      #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]

    Param(
        [Parameter()]
        [SupportsWildcards()]
        [string[]] $Path = '.',
        [Parameter()]
        [switch] $Recurse,
        [Parameter()]
        [switch] $Force
    )

    Begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $VerbosePreference = $PSCmdlet.SessionState.PSVariable.GetValue('VerbosePreference')
        }
        if (-not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
        }
        if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
            $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
        }
        Write-Verbose ('[{0}] Confirm={1} ConfirmPreference={2} WhatIf={3} WhatIfPreference={4}' -f $MyInvocation.MyCommand, $Confirm, $ConfirmPreference, $WhatIf, $WhatIfPreference)
    }

    Process {
        <# Pre-impact code #>

        # -Confirm --> $ConfirmPreference = 'Low'
        # ShouldProcess intercepts WhatIf* --> no need to pass it on
        if ($Force -or $PSCmdlet.ShouldProcess("ShouldProcess?")) {
            Write-Verbose ('[{0}] Reached command' -f $MyInvocation.MyCommand)
            # Variable scope ensures that parent session remains unchanged
            $ConfirmPreference = 'None'
        }

        Get-ChildItem -Path $Path -Recurse:$Recurse -Force:$Force | `
            Where-Object {$_.name -like ".*" -and $_.attributes -match 'Hidden' `
                -eq $false} | `
            Set-ItemProperty -name Attributes `
                -value ([System.IO.FileAttributes]::Hidden)

        <# Post-impact code #>
    }
}
