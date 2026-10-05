#!/bin/sh
# Rendert Marketing-Screenshots (1290x2796) aus shots/en/N.png und shots/de/N.png (echte iPhone-Screenshots, Hochformat).
C=${CHROME:-/opt/pw-browsers/chromium-1194/chrome-linux/chrome}
cd "$(dirname "$0")"; mkdir -p out
for lang in en de; do
  for f in shots/$lang/*.png; do
    n=$(basename "$f" .png)
    $C --headless --no-sandbox --disable-gpu --hide-scrollbars --window-size=1290,2884 --screenshot=/tmp/m.png "file://$PWD/slides.html?n=$n&lang=$lang" >/dev/null 2>&1
    convert /tmp/m.png -crop 1290x2796+0+0 +repage -alpha off out/${lang}_0$n.png
  done
  convert out/${lang}_0*.png +append -resize 20% out/overview_$lang.png
done
