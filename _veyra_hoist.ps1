$ErrorActionPreference = 'Stop'
$file = 'index.html'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$content = [System.IO.File]::ReadAllText($file, $utf8NoBom)
$nl = "`r`n"

function Replace-Or-Fail {
    param([string]$label, [string]$find, [string]$replace)
    if (-not $script:content.Contains($find)) { throw "anchor not found: $label" }
    $script:content = $script:content.Replace($find, $replace)
    Write-Host "  ok: $label"
}

# 1. Extract the VeyraOps img (targeted via alt="VeyraOps")
$imgPattern = '(?s)    <img src="data:image/jpeg;base64,([A-Za-z0-9+/=]+)" alt="VeyraOps">'
$m = [regex]::Match($content, $imgPattern)
if (-not $m.Success) { throw "VeyraOps img not found" }
$b64 = $m.Groups[1].Value
$oldImg = $m.Value
Write-Host ("base64 length: {0}" -f $b64.Length)

# 2. Replace the <img> with a <div>
$newDiv = '    <div class="vo-logo" role="img" aria-label="VeyraOps"></div>'
Replace-Or-Fail 'img -> div' $oldImg $newDiv

# 3. Splash CSS rule
$oldSplash = '  #vo-splash img{' + $nl +
             '    display:block; width:100%; max-width:340px; height:auto; margin:0 auto;' + $nl +
             '  }'
$newSplash = '  #vo-splash .vo-logo{' + $nl +
             '    display:block; width:100%; max-width:340px; aspect-ratio:760/287;' + $nl +
             '    margin:0 auto; background-image:var(--vo-logo);' + $nl +
             '    background-size:contain; background-repeat:no-repeat; background-position:center;' + $nl +
             '  }'
Replace-Or-Fail 'splash rule' $oldSplash $newSplash

# 4. Splash media query rule
Replace-Or-Fail 'splash media' `
    '    #vo-splash img{ max-width:440px; }' `
    '    #vo-splash .vo-logo{ max-width:440px; }'

# 5. Inject --vo-logo into refonte :root
$rootAnchor = '  --room-5:#073676; --room-6:#073676; --room-7:#073676; --room-tbd:#5E6B7E;'
$rootAdd = $rootAnchor + $nl +
           '  /* Logo VeyraOps - hoisted once, referenced via background-image. */' + $nl +
           '  --vo-logo:url("data:image/jpeg;base64,' + $b64 + '");'
Replace-Or-Fail 'root --vo-logo' $rootAnchor $rootAdd

# 6. Footer pastille CSS
$footAnchor = '.foot-host .host-org{background:rgba(255,255,255,.10);border:1px solid rgba(255,255,255,.24);color:#fff;}'
$footAdd = $footAnchor + $nl +
           '.foot-host .vo-lbl{margin-top:18px;}' + $nl +
           '.foot-host .host-org-veyra{display:inline-flex;align-items:center;justify-content:center;min-height:var(--tap);padding:10px 22px;border-radius:var(--r-pill);background:#fff;border:1px solid rgba(255,255,255,.24);margin-top:9px;}' + $nl +
           '.foot-host .host-org-veyra .vo-mark{display:block;width:110px;aspect-ratio:760/287;background-image:var(--vo-logo);background-size:contain;background-repeat:no-repeat;background-position:center;}'
Replace-Or-Fail 'footer css' $footAnchor $footAdd

# 7. Footer pastille HTML
$htmlAnchor = '      Illinois Bamileke Association' + $nl + '    </a>'
$htmlAdd = $htmlAnchor + $nl + $nl +
           '    <div class="host-lbl vo-lbl">Powered by</div>' + $nl +
           '    <div class="host-org host-org-veyra" aria-label="VeyraOps"><span class="vo-mark"></span></div>'
Replace-Or-Fail 'footer html' $htmlAnchor $htmlAdd

# 8. Write back
[System.IO.File]::WriteAllText($file, $content, $utf8NoBom)
Write-Host "done"
