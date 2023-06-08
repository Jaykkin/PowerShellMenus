Function Show-PsColumns{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)][string[]]$ColumnItems
    )
    DynamicParam{
        $RTParamDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
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
        $IndexColor = @{}
        if ($PSBoundParameters.IndexForegroundColor){
            $IndexColor.Add("ForegroundColor", $PSBoundParameters.IndexForegroundColor)
        }
        if ($PsBoundParameters.IndexBackgroundcolor){
            $IndexColor.Add("BackgroundColor", $PSBoundParameters.IndexBackgroundColor)
        }
        if ($PSBoundParameters.ItemForegroundColor){
            $ItemForegroundColor = $PSBoundParameters.ItemForegroundColor
        }else{
            $ItemForegroundColor = "Yellow"
        }
        $ItemColor = @{
            ForegroundColor = $ItemForegroundColor
        }
        if ($PSBoundParameters.ItemBackgroundColor){
            $ItemColor.Add("BackgroundColor", $PSBoundParameters.ItemBackgroundColor)
        }
        $WindowWidth = $Host.UI.RawUI.BufferSize.Width
        $CurrentForeground = $Host.UI.RawUI.ForegroundColor
        $CurrentBackground = $Host.UI.RawUI.BackgroundColor

        # Get the length of widest item in the array
        $ItemWidth = ($ColumnItems | Measure-Object -Maximum -Property Length).Maximum
    
        # Calculate how many spaces to add for the index based on the count of items.  
        # Ex [50] would be 5 spaces + add 1 for the space needed between the column
        [int]$PaddingSize = (" [$($ColumnItems.Count)] ").length
    
        # Calculate how many columns are available on the screen
        $ColumnWidth = $ItemWidth + $PaddingSize
        $NumberOfColumns = [math]::Truncate($WindowWidth/$ColumnWidth)

        # Check to see if the last column is going to wrap.  If so, remove 1 column
        if (($ColumnWidth * $NumberOfColumns) -gt $WindowWidth){
            $NumberOfColumns--
        }

        # Calculate how many items will be in each column
        $ColumnLength = [math]::Ceiling($ColumnItems.Count/$NumberOfColumns)

        # Determine if there are half the number of columns to items
        $SingleColumn = $ColumnItems.count -le 10

        # Find the current location of the cursor
        $StartPosition = $Host.UI.RawUI.CursorPosition
        $StartYPosition = $StartPosition.Y
        $X = 0 # Current Column Row
        $I = 0 # Current Menu Index
        ForEach ($Item in $ColumnItems){
            if (!$SingleColumn){
                if ($X -ge $ColumnLength){
                    $X = 0
                    $StartPosition.X = $StartPosition.X + $ColumnWidth
                }
            }else{
                $ColumnLength = $ColumnItems.Count
            }
            $CurrBufferSize = $Host.UI.RawUI.BufferSize.Height
            $StartPosition.Y = $StartYPosition + $X
            $Host.UI.RawUI.CursorPosition = $StartPosition
            Write-Host "[$I] " -NoNewline @IndexColor
            Write-Host "$Item" @ItemColor
            $X++
            $I++
        }

        # Set the position to the bottom of the menu
        $StartPosition.Y = $StartYPosition + $ColumnLength
        $StartPosition.X = 0
        $Host.UI.RawUI.CursorPosition = $StartPosition

        # Set the text color back to what it was before drawing the menu
        $Host.UI.RawUI.BackgroundColor = $CurrentBackground
        $Host.UI.RawUI.ForegroundColor = $CurrentForeground
    }
}
Function New-RuntimeParam{
    Param(
        [Parameter(Mandatory=$true)]$ParamName,
        [Parameter(Mandatory=$true)][string[]]$ValidationValues,
        [Parameter(Mandatory=$false)]$ParamSetName,
        [Parameter(Mandatory=$false)][bool]$Mandatory,
        [Parameter(Mandatory=$false)][switch]$UseStringArray

    )
    $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
    $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
    $ParameterAttribute.Mandatory = $Mandatory
    $ParameterAttribute.ParameterSetName = $ParamSetName
    $AttributeCollection.Add($ParameterAttribute)
    $ParamName_OnlineVoiceRoutingPolicy = $ParamName
    $ValidateSetAttribute = New-Object System.Management.Automation.ValidatesetAttribute($ValidationValues)
    $AttributeCollection.Add($ValidateSetAttribute)
    if ($UseStringArray){
        $RuntimeParam = New-Object System.Management.Automation.RuntimeDefinedParameter($ParamName_OnlineVoiceRoutingPolicy, [string[]], $AttributeCollection)
    }else{
        $RuntimeParam = New-Object System.Management.Automation.RuntimeDefinedParameter($ParamName_OnlineVoiceRoutingPolicy, [string], $AttributeCollection)
    }
    return $RuntimeParam
}