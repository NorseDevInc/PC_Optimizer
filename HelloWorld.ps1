#Add-Type -AssemblyName PresentationFramework

$inputXAML = @"
<Window x:Class="WpfApp1.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:WpfApp1"
        mc:Ignorable="d"
        Title="Hello World" Height="317" Width="427" ResizeMode="NoResize">
    <Grid>
        <Grid.ColumnDefinitions>
            <ColumnDefinition/>
        </Grid.ColumnDefinitions>
        <Label x:Name="HelloText" Content="Hello World!" HorizontalAlignment="Center" Margin="0,93,0,0" VerticalAlignment="Top" FontSize="22" FontFamily="Verdana" Visibility="Hidden"/>
        <Button x:Name="HelloButton" Content="Say Hello!" HorizontalAlignment="Center" Margin="0,176,0,0" VerticalAlignment="Top" Height="33" Width="161"/>

    </Grid>
</Window>
"@
$inputXAML = $inputXAML -replace 'mc:Ignorable="d"','' -replace "x:N", "N" -replace '^<Win.*', '<Window'
[XML]$XAML = $inputXAML


#Load our XAML into the form and create the form object
$reader = New-Object System.Xml.XmlNodeReader $XAML
try {
    $psform = [Windows.Markup.XamlReader]::Load($reader)
} catch {
    Write-Host $_.Exception
    throw
}


#Automatically create a variable for each control object in the form that has a custom name
$XAML.SelectNodes("//*[@Name]") | ForEach-Object {
    try {
        Set-Variable -Name "var_$($_.Name)" -Value $psform.FindName($_.Name) -ErrorAction Stop
    } catch {
        throw
    }
}

Get-Variable var_*


#Make the function that will be called when the button is pressed
function ButtonPressed {
    if($var_HelloText.Visibility -eq "Hidden") {
        $var_HelloText.Visibility = "Visible"        
    } else {
        $var_HelloText.Visibility = "Hidden"
    }
}


$var_HelloButton.Add_Click({ButtonPressed})

$psform.ShowDialog()