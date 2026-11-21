# Genera los iconos PNG de la App (Tetris Neon) usando System.Drawing.
# Uso:  powershell -ExecutionPolicy Bypass -File tools\generar-iconos.ps1
Add-Type -AssemblyName System.Drawing

$outDir = Join-Path $PSScriptRoot '..\assets\icons'
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

function New-Icon([int]$size, [string]$name, [bool]$maskable) {
    $bmp = New-Object System.Drawing.Bitmap $size, $size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = 'AntiAlias'
    $g.InterpolationMode = 'HighQualityBicubic'

    # Fondo degradado oscuro
    $rect = New-Object System.Drawing.Rectangle 0, 0, $size, $size
    $bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect, ([System.Drawing.Color]::FromArgb(255, 20, 8, 40)), ([System.Drawing.Color]::FromArgb(255, 5, 5, 11)), 45
    $g.FillRectangle($bg, $rect)

    # Zona segura (las maskable necesitan ~80% central)
    $area = if ($maskable) { $size * 0.62 } else { $size * 0.78 }
    $cell = $area / 4
    $ox = ($size - $cell * 4) / 2
    $oy = ($size - $cell * 4) / 2

    # Bloques: T morada arriba, I cyan, L naranja, S verde (composicion 4x4)
    $blocks = @(
        @(0, 0, 162, 0, 255), @(1, 0, 162, 0, 255), @(2, 0, 162, 0, 255), @(1, 1, 162, 0, 255),
        @(3, 0, 0, 243, 255), @(3, 1, 0, 243, 255), @(3, 2, 0, 243, 255), @(3, 3, 0, 243, 255),
        @(0, 1, 255, 102, 0), @(0, 2, 255, 102, 0), @(0, 3, 255, 102, 0), @(1, 3, 255, 102, 0),
        @(1, 2, 253, 29, 134), @(2, 2, 253, 29, 134), @(2, 1, 253, 29, 134), @(2, 3, 253, 29, 134)
    )
    $pad = [Math]::Max(1, $cell * 0.06)
    foreach ($b in $blocks) {
        $x = $ox + $b[0] * $cell + $pad
        $y = $oy + $b[1] * $cell + $pad
        $w = $cell - 2 * $pad
        $col = [System.Drawing.Color]::FromArgb(255, $b[2], $b[3], $b[4])

        # Brillo exterior (glow)
        for ($i = 3; $i -ge 1; $i--) {
            $glow = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(28, $b[2], $b[3], $b[4]))
            $e = $i * $cell * 0.06
            $g.FillRectangle($glow, [single]($x - $e), [single]($y - $e), [single]($w + 2 * $e), [single]($w + 2 * $e))
            $glow.Dispose()
        }
        $r = New-Object System.Drawing.RectangleF ([single]$x), ([single]$y), ([single]$w), ([single]$w)
        $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush $r, ([System.Drawing.Color]::White), $col, 90
        $blend = New-Object System.Drawing.Drawing2D.Blend
        $blend.Factors = [single[]]@(0, 1, 0.75)
        $blend.Positions = [single[]]@(0, 0.3, 1)
        $grad.Blend = $blend
        $g.FillRectangle($grad, $r)
        $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(110, 255, 255, 255)), ([single]([Math]::Max(1, $cell * 0.03)))
        $g.DrawRectangle($pen, [single]$x, [single]$y, [single]$w, [single]$w)
        $grad.Dispose(); $pen.Dispose()
    }

    $path = Join-Path $outDir $name
    $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose(); $bg.Dispose()
    Write-Output "Creado: $path"
}

New-Icon 192 'icon-192.png' $false
New-Icon 512 'icon-512.png' $false
New-Icon 512 'icon-maskable-512.png' $true
New-Icon 180 'apple-touch-icon.png' $false
New-Icon 32 'favicon-32.png' $false
