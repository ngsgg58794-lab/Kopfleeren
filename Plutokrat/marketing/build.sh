#!/bin/sh
# Rendert Marketing-Screenshots (1290x2796). Eigene Bildschirmfotos: nach shots/1.png ... 6.png legen (iPhone-Screenshot, Hochformat), dann ./build.sh slides
C=${CHROME:-/opt/pw-browsers/chromium-1194/chrome-linux/chrome}
cd "$(dirname "$0")"
if [ "$1" != "slides" ]; then   # Platzhalter-Bildschirme aus screens.html erzeugen
  for n in 1 2 3 4 5 6; do
    $C --headless --no-sandbox --disable-gpu --hide-scrollbars --force-device-scale-factor=3 --window-size=390,932 --screenshot=/tmp/s$n.png "file://$PWD/screens.html?n=$n" >/dev/null 2>&1
    convert /tmp/s$n.png -crop 1170x2532+0+0 +repage -alpha off shots/$n.png
  done
fi
for n in 1 2 3 4 5 6; do
  $C --headless --no-sandbox --disable-gpu --hide-scrollbars --window-size=1290,2884 --screenshot=/tmp/m$n.png "file://$PWD/slides.html?n=$n" >/dev/null 2>&1
  convert /tmp/m$n.png -crop 1290x2796+0+0 +repage -alpha off out/en_0$n.png
done
