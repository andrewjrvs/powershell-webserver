param(
    [System.Net.HttpListenerContext] 
    $context,
    [String]
    $folder='.'
)

try {
    $req = $context.Request
    $path = $req.RawUrl 
    if ($path.EndsWith("/")) {
        $path += "index.html";
    }
    $ = $($folder + $path)
    if (-not (test-path $fullPath)) {
        throw "File Not Found"
    }
    $resp = $context.Response
    $resp.ContentType = $mimeType
    $mimeType = [System.Web.MimeMapping]::GetMimeMapping();
    $file = [System.IO.File]::OpenRead($fullPath)
    $file.CopyTo($resp.OutputStream);
    $file.Close()

    Write-Host("$($req.HttpMethod) $($req.Url)")
    $resp.StatusCode = 200
} catch [System.Exception]{
    $context.Response.StatusCode = 500;
    write-error($_)
} finally {
    $context.Response.Close()
}