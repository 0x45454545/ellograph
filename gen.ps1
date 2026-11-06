param (
    [Parameter(Mandatory, ValueFromPipeLine)]
    [IO.FileSystemInfo[]] $Files
)

$Title = (Get-Culture).TextInfo.ToTitleCase

foreach ($File in $Files) {

    $Full = $Title.Invoke($File.BaseName)

    $Family, $Weight, $Style = $Full -Split '-'

    $NoPath = $File.Name

    $Human = "$Family $Weight"
    $Out   = "$Family-$Weight"

    if ($Style) {
        $Human += " $Style"
        $Out   += "-$Style"
    }

    Write-Host "[ ## ] Generating '$Out.otf' from '$NoPath'"

    fontforge -lang=ff -c "Open('$NoPath'); SetFontNames('$Full', '$Family', '$Human', '$Weight'); Generate('Compiled/$Out.otf')"
}
