#Get public and private function definition files.
$Public = @( Get-ChildItem -Path $PSScriptRoot\src\public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\src\private\*.ps1 -ErrorAction SilentlyContinue )
$Classes = @( Get-ChildItem -Path $PSScriptRoot\src\classes\*.ps1 -ErrorAction SilentlyContinue )

#import all Classes
Foreach ($Class in $Classes) {
    Try {
        $ClassDataAsString = (get-Content $Class) -join "`n"
        Invoke-Expression $ClassDataAsString
    }
    catch {
        if ( $index -eq 2 ) {
            Write-Error -Message "Failed to import class $($class.fullName): $_"
        }
    }
}
#Dot source the Private files
Foreach ($import in $Private) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

$CurrentFunctions = Get-ChildItem function:
$PublicFunctions = @()
#Dot source the Public files
Foreach ($import in $Public) {
    Try {
        . $import.fullname
        $PublicFunctions += Get-ChildItem function: | Where-Object {$CurrentFunctions -notcontains $_}
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $PublicFunctions -Alias *