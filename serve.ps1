param(
    [string]$root = (Split-Path -Parent $MyInvocation.MyCommand.Path)
)

$port = 8080
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "Serving $root on http://localhost:$port/"

try {
    while ($listener.IsListening) {
        $ctx = $listener.GetContext()
        $req = $ctx.Request
        $res = $ctx.Response

        $path = [Uri]::UnescapeDataString($req.Url.AbsolutePath)
        if ($path -eq "/") { $path = "/index.html" }
        $local = Join-Path $root $path.TrimStart('/')

        if (Test-Path -LiteralPath $local -PathType Leaf) {
            $bytes = [IO.File]::ReadAllBytes($local)
            $ext = [IO.Path]::GetExtension($local).ToLower()
            switch ($ext) {
                ".html" { $res.ContentType = "text/html; charset=utf-8" }
                ".css"  { $res.ContentType = "text/css; charset=utf-8" }
                ".js"   { $res.ContentType = "application/javascript; charset=utf-8" }
                ".png"  { $res.ContentType = "image/png" }
                ".jpg"  { $res.ContentType = "image/jpeg" }
                ".gif"  { $res.ContentType = "image/gif" }
                ".ico"  { $res.ContentType = "image/x-icon" }
                ".json" { $res.ContentType = "application/json; charset=utf-8" }
                ".txt"  { $res.ContentType = "text/plain; charset=utf-8" }
                default  { $res.ContentType = "application/octet-stream" }
            }
            $res.StatusCode = 200
            $res.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            $res.StatusCode = 404
            $err = [Text.Encoding]::UTF8.GetBytes("404 Not Found: $path")
            $res.OutputStream.Write($err, 0, $err.Length)
        }
        $res.Close()
    }
} finally {
    $listener.Stop()
    $listener.Close()
}
