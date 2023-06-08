
Function Select-PsMenuItems{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ParameterSetName="Default")]
            [Parameter(Mandatory=$true,ParameterSetName="Object")][string]$MenuTitle,
        [Parameter(Mandatory=$true,ParameterSetName="Default")][string[]]$MenuItems,
        [Parameter(Mandatory=$true,ParameterSetName="Object")][object]$MenuObject,
        [Parameter(Mandatory=$true,ParameterSetName="Object")][string]$Property
    )
    DynamicParam{
        $RTParamDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $Parms = @{
            ParamName = "TitleForegroundColor"
            ValidationValues = [ConsoleColor]::GetValues([ConsoleColor])
            Mandatory = $False
        }
        $RTParamDictionary.Add($Parms.ParamName,(New-RuntimeParam @parms))
        $Parms = @{
            ParamName = "TitleBackgroundColor"
            ValidationValues = [ConsoleColor]::GetValues([ConsoleColor])
            Mandatory = $False
        }
        $RTParamDictionary.Add($Parms.ParamName,(New-RuntimeParam @parms))
        $Parms = @{
            ParamName = "IndexForegroundColor"
            ValidationValues = [ConsoleColor]::GetValues([ConsoleColor])
            Mandatory = $False
        }
        $RTParamDictionary.Add($Parms.ParamName,(New-RuntimeParam @parms))
        $Parms = @{
            ParamName = "IndexBackgroundColor"
            ValidationValues = [ConsoleColor]::GetValues([ConsoleColor])
            Mandatory = $False
        }
        $RTParamDictionary.Add($Parms.Paramname,(New-RuntimeParam @parms))
        $Parms = @{
            ParamName = "ItemForegroundColor"
            ValidationValues = [ConsoleColor]::GetValues([ConsoleColor])
            Mandatory = $False
        }
        $RTParamDictionary.Add($Parms.Paramname,(New-RuntimeParam @parms))
        $Parms = @{
            ParamName = "ItemBackgroundColor"
            ValidationValues = [ConsoleColor]::GetValues([ConsoleColor])
            Mandatory = $False
        }
        $RTParamDictionary.Add($Parms.Paramname,(New-RuntimeParam @parms))
        return $RTParamDictionary
    }end{
        if ($PSBoundParameters.TitleForegroundColor){
            $TitleForegroundColor = $PSBoundParameters.TitleForegroundColor
        }else{
            $TitleForegroundColor = "Green"
        }
        $TitleColors = @{
            ForegroundColor = $TitleForegroundColor
        }
        if ($PsBoundParameters.TitleBackgroundcolor){
            $TitleColors.Add("BackgroundColor",$PSBoundParameters.TitleBackgroundColor)
        }else{
            if ($Host.Name -eq "ConsoleHost"){
                $TitleColors.Add("BackgroundColor",$Host.UI.RawUI.BackgroundColor)
            }
        }
        $ColumnColors = @{}
        if ($PSBoundParameters.IndexForegroundColor){
            $ColumnColors.Add("IndexForegroundColor",$PSBoundParameters.IndexForegroundColor)
        }
        if ($PsBoundParameters.IndexBackgroundcolor){
            $ColumnColors.Add("IndexBackgroundColor", $PSBoundParameters.IndexBackgroundColor)
        }
        if ($PSBoundParameters.ItemForegroundColor){
            $ColumnColors.Add("ItemForegroundColor", $PSBoundParameters.ItemForegroundColor)
        }
        if ($PSBoundParameters.ItemBackgroundColor){
            $ColumnColors.Add("ItemBackgroundColor", $PSBoundParameters.ItemBackgroundColor)
        }
        if ($Property){
            $MenuItems = Invoke-Expression "`$MenuObject.$($Property)"
        }
        do{
            Write-Host $MenuTitle.ToUpper() @TitleColors
            for ($I = 0;$I -lt $MenuTitle.Length;$I++){
                Write-Host "~" -NoNewline @TitleColors
            }
            Write-Host ""
            Show-PsColumns -ColumnItems $MenuItems @ColumnColors
            Write-Host "Select Number" -NoNewline -ForegroundColor Green
            Write-Host "[0 - $($MenuItems.count - 1)]" -NoNewline -ForegroundColor Yellow
            $Choice = (Read-Host " ") -replace "\D"
        }until((([int]$Choice -lt $MenuItems.Count) -and [int]$Choice -ge 0) -and ($Choice -ne ""))
        if ($Property){
            return $MenuObject[$Choice]
        }else{
            return $MenuItems[$Choice]
        }
    }

}
Function Select-PsYN{
    $YN = @("No","Yes")
    $MenuItems = $YN | Get-Random -Count $YN.Length
    $Answer = Select-PsMenuItems -MenuTitle "Do you wish to continue" -MenuItems $MenuItems  -TitleForegroundColor Red -TitleBackgroundColor White
    switch ($Answer){
        "Yes"{return $true}
        "No"{return $false}
    }
}