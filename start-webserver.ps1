
$baseUrl = "http://localhost:4202/"
$server = New-Object System.Net.HttpListener





try {
    $server.Prefixes.Add($baseUrl)
    $server.Start()
} catch [System.Exception]{
    Write-Host("$($_.Exception.Message + " " + $_.InvocationInfo.PositionMessage)")
    Write-Host("Fatal Error; Server could not be started.")
    exit
}
Write-Host("Listening on $baseUrl ...")
$u = $null
while ($server.IsListening -and (-not ($u -and $u.Key.ToString() -eq "Escape"))){
    $u = [System.Console]::ReadKey();
    .\process-request.ps1 $server.GetContext()
}
$server.Stop()