param (
    [Parameter(Mandatory)]
    [String] $Extension,

    [Parameter(Mandatory, ValueFromPipeLine)]
    [String] $CSS
)

[String] $NamePattern = "\s*font-family\s*:\s*'(.+?)'\s*;"
[String] $UrlPattern = "\s*src:\s*url\s*\(\s*'(.+?)'\s*\)\s*;"

[Collections.ArrayList] $Family = @()

foreach ($Line in $CSS -Split "`n") {

    if ($Line -notmatch $NamePattern) {
        Write-Host "[FAIL] No name found"
        Write-Host "       Skipping..."
        continue
    } [String] $Name = $matches[1]

    if ($Line -notmatch $UrlPattern) {
        Write-Host "[FAIL] No url found for name '$Name'"
        Write-Host "       Skipping..."
        continue
    } [String] $Url = $matches[1]

    Write-Host "[ OK ] Found: '$Name'"
    Write-Host "          At: '$Url'"
    Write-Host "       Saving..."

    $Family.Add( @{ Name = $Name; Url = $Url } )

}

foreach ($Face in $Family) {
    Write-Host "[ GO ] Fetching '$($Face.Name).$Extension' ***"
    Invoke-WebRequest -Uri $Face.Url -OutFile "$($Face.Name).$Extension"
}

Write-Host "[ ## ] Done."
