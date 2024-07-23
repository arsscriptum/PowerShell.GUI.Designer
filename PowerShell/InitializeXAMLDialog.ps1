<#
#̷𝓍   𝓐𝓡𝓢 𝓢𝓒𝓡𝓘𝓟𝓣𝓤𝓜
#̷𝓍   🇵​​​​​🇴​​​​​🇼​​​​​🇪​​​​​🇷​​​​​🇸​​​​​🇭​​​​​🇪​​​​​🇱​​​​​🇱​​​​​ 🇸​​​​​🇨​​​​​🇷​​​​​🇮​​​​​🇵​​​​​🇹​​​​​ 🇧​​​​​🇾​​​​​ 🇬​​​​​🇺​​​​​🇮​​​​​🇱​​​​​🇱​​​​​🇦​​​​​🇺​​​​​🇲​​​​​🇪​​​​​🇵​​​​​🇱​​​​​🇦​​​​​🇳​​​​​🇹​​​​​🇪​​​​​.🇶​​​​​🇨​​​​​@🇬​​​​​🇲​​​​​🇦​​​​​🇮​​​​​🇱​​​​​.🇨​​​​​🇴​​​​​🇲​​​​​
#>


[CmdletBinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Mandatory = $False, Position = 0)]
        [string]$XAMLPath = "..\Designer\MainWindow.xaml",

        #If enabled all objects will be named $Formname_Objectname
        #Example: $PSGUI_lbDialogs
        #If not it would look like
        #Example: $lbDialogs
        #By using namespaces the possibility that a variable will be overwritten is mitigated.
        [switch]
        $UseFormNameAsNamespace = $True
    )




function Initialize-XAMLDialog
{
    <#
            .Synopsis
            XAML-Loader
            .DESCRIPTION
            Loads the xaml file and sets global variables for all elements.
            .EXAMPLE
            Initialize-XAMLDialog "..\Dialogs\MyForm.xaml"
            .Notes
            - namespace-class removed and namespace added
            - absolute and relative paths
            - creating variables for each object
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $True, Position = 0)]
        [string]$XAMLPath,

        #If enabled all objects will be named $Formname_Objectname
        #Example: $PSGUI_lbDialogs
        #If not it would look like
        #Example: $lbDialogs
        #By using namespaces the possibility that a variable will be overwritten is mitigated.
        [switch]
        $UseFormNameAsNamespace = $True
    )


    [void][System.Reflection.Assembly]::LoadWithPartialName('PresentationFramework')
    [void][System.Reflection.Assembly]::LoadWithPartialName('PresentationCore')
    [void][System.Reflection.Assembly]::LoadWithPartialName('WindowsBase')
    [void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
    [void][System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')
    [void][System.Reflection.Assembly]::LoadWithPartialName('System')
    [void][System.Reflection.Assembly]::LoadWithPartialName('System.Xml')
    [void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows')

    #Build the GUI
    [xml]$xaml = Get-Content $XAMLPath 
     
    $reader=(New-Object System.Xml.XmlNodeReader $xaml)
    $Window=[Windows.Markup.XamlReader]::Load( $reader )

    #AutoFind all controls 
    $xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")  | ForEach-Object {  
        #New-Variable  -Name $_.Name -Value $Window.FindName($_.Name) -Force -Scope Global
        Write-Host "Variable named: Name $($_.Name)"
    }
$Window.ShowDialog() | Out-Null


}



Initialize-XAMLDialog $XAMLPath


