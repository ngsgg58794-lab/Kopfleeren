import os
from PIL import Image, ImageDraw, ImageFont, ImageFilter

RAW = os.environ.get('RAW', 'build/store_raw')
REPO = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
SEMI = f'{REPO}/assets/fonts/Inter-SemiBold.ttf'
REG = f'{REPO}/assets/fonts/Inter-Regular.ttf'

SCENES = [
    ('list', {'de': ('Kopf frei in Sekunden', 'Alles ablegen, was dich beschäftigt'),
              'en': ('A clear mind in seconds', 'Drop everything on your mind')}),
    ('voice', {'de': ('Einfach drauflos sprechen', 'Spracheingabe auf Deutsch & Englisch'),
               'en': ('Just speak your mind', 'Voice input in English & German')}),
    ('sorted', {'de': ('Calmdrop sortiert für dich', 'Automatisch in Kategorien – dann abhaken'),
                'en': ('Sorted for you', 'Grouped automatically – then check it off')}),
    ('dark', {'de': ('Ruhig bei Tag und Nacht', 'Mit Dunkelmodus'),
              'en': ('Calm day and night', 'With dark mode')}),
    ('language', {'de': ('Deutsch & Englisch', 'Sprache jederzeit umschalten'),
                  'en': ('English & German', 'Switch language anytime')}),
]

def gradient(w, h, top, bottom):
    g = Image.new('RGB', (1, h))
    for y in range(h):
        t = y / (h - 1)
        g.putpixel((0, y), tuple(round(a + (b - a) * t) for a, b in zip(top, bottom)))
    return g.resize((w, h))

def hexrgb(h): return tuple(int(h[i:i + 2], 16) for i in (1, 3, 5))

def rounded_mask(size, r):
    m = Image.new('L', size, 0)
    ImageDraw.Draw(m).rounded_rectangle([0, 0, size[0] - 1, size[1] - 1], r, fill=255)
    return m

def status_bar(img, dark):
    """iOS-Statusleiste (9:41, Netz, Akku) in den oberen Safe-Area-Bereich zeichnen."""
    d = ImageDraw.Draw(img)
    s = img.width / 440  # pt -> px
    c = (255, 255, 255) if dark else (14, 42, 64)
    f = ImageFont.truetype(SEMI, round(17 * s))
    d.text((round(52 * s), round(30 * s)), '9:41', font=f, fill=c, anchor='mm')
    # Netz
    x0, base = round(318 * s), round(37 * s)
    for i in range(4):
        h = round((4 + i * 2.6) * s)
        d.rounded_rectangle([x0 + i * round(5 * s), base - h, x0 + i * round(5 * s) + round(3 * s), base], round(1 * s), fill=c)
    # Akku
    bx, by, bw, bh = round(352 * s), round(24 * s), round(27 * s), round(13 * s)
    d.rounded_rectangle([bx, by, bx + bw, by + bh], round(4 * s), outline=c, width=max(2, round(1.2 * s)))
    d.rounded_rectangle([bx + round(2.5 * s), by + round(2.5 * s), bx + bw - round(2.5 * s), by + bh - round(2.5 * s)], round(2 * s), fill=c)
    d.rounded_rectangle([bx + bw + round(1.5 * s), by + round(4 * s), bx + bw + round(3.5 * s), by + bh - round(4 * s)], round(1 * s), fill=c)
    # Dynamic Island
    iw, ih = round(124 * s), round(36 * s)
    d.rounded_rectangle([(img.width - iw) // 2, round(12 * s), (img.width + iw) // 2, round(12 * s) + ih], ih // 2, fill=(0, 0, 0))

def phone(screen, width):
    scale = width / screen.width
    scr = screen.resize((width, round(screen.height * scale)), Image.LANCZOS)
    bezel = round(width * 0.035)
    r_screen = round(width * 0.125)
    body = Image.new('RGBA', (scr.width + 2 * bezel, scr.height + 2 * bezel), (0, 0, 0, 0))
    ImageDraw.Draw(body).rounded_rectangle([0, 0, body.width - 1, body.height - 1], r_screen + bezel, fill=(12, 17, 22, 255))
    body.paste(scr, (bezel, bezel), rounded_mask(scr.size, r_screen))
    return body

def wrap(text, font, maxw, draw):
    words = text.split()
    if draw.textlength(text, font=font) <= maxw:
        return [text]
    # zwei Zeilen, möglichst gleich lang
    best = min(range(1, len(words)), key=lambda i: max(
        draw.textlength(' '.join(words[:i]), font=font),
        draw.textlength(' '.join(words[i:]), font=font)))
    return [' '.join(words[:best]), ' '.join(words[best:])]

def compose(W, H, screen, title, sub, dark, phone_w_ratio, top_ratio):
    top, bottom = ((18, 64, 107), (6, 24, 42)) if dark else (hexrgb('#3FA9D8'), hexrgb('#0F5A93'))
    img = gradient(W, H, top, bottom).convert('RGBA')
    d = ImageDraw.Draw(img)
    ft = ImageFont.truetype(SEMI, round(W * 0.072))
    fs = ImageFont.truetype(REG, round(W * 0.036))
    y = round(H * 0.055)
    for line in wrap(title, ft, W * 0.86, d):
        d.text((W / 2, y), line, font=ft, fill='white', anchor='ma')
        y += round(ft.size * 1.18)
    y += round(fs.size * 0.35)
    for line in wrap(sub, fs, W * 0.86, d):
        d.text((W / 2, y), line, font=fs, fill=(255, 255, 255, 225), anchor='ma')
        y += round(fs.size * 1.35)
    p = phone(screen, round(W * phone_w_ratio))
    px, py = (W - p.width) // 2, max(y + round(H * 0.035), round(H * top_ratio))
    shadow = Image.new('RGBA', img.size, (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle([px, py + 30, px + p.width, py + p.height + 30], round(p.width * 0.16), fill=(0, 0, 0, 90))
    img = Image.alpha_composite(img, shadow.filter(ImageFilter.GaussianBlur(40)))
    img.alpha_composite(p, (px, py))
    return img.convert('RGB')

for lang, ios_dir, play_dir in [('de', 'de-DE', 'de-DE'), ('en', 'en-US', 'en-US')]:
    ios_out = f'{REPO}/fastlane/screenshots/{ios_dir}'
    play_out = f'{REPO}/fastlane/metadata/android/{play_dir}/images/phoneScreenshots'
    os.makedirs(ios_out, exist_ok=True); os.makedirs(play_out, exist_ok=True)
    for i, (scene, texts) in enumerate(SCENES, 1):
        dark = scene == 'dark'
        screen = Image.open(f'{RAW}/{lang}_{scene}.png').convert('RGB')
        if scene == 'language':
            bar = screen.crop((0, 0, screen.width, round(62 * screen.width / 440)))
            status_bar(bar, dark)
            # gleiche Abdunklung wie die Modal-Barriere darunter
            ref = screen.getpixel((screen.width // 2, round(70 * screen.width / 440)))
            clean = Image.new('RGB', bar.size, ref)
            status_bar(clean, dark)
            screen.paste(clean, (0, 0))
        else:
            status_bar(screen, dark)
        title, sub = texts[lang]
        ios = compose(1320, 2868, screen, title, sub, dark, 0.80, 0.20)
        ios.save(f'{ios_out}/{i}_{scene}.png')  # iPhone 6,9"
        # iPhone 6,5" (1284x2778): auf Breite skalieren, unten abschneiden (Handy ist dort angeschnitten)
        small = ios.resize((1284, round(2868 * 1284 / 1320)), Image.LANCZOS).crop((0, 0, 1284, 2778))
        small.save(f'{ios_out}/{i}_{scene}_6.5.png')
        compose(1080, 1920, screen, title, sub, dark, 0.66, 0.22).save(f'{play_out}/{i}_{scene}.png')

# Play: Feature-Grafik 1024x500 + Icon 512x512
icon = Image.open(f'{REPO}/assets/icon/icon.png').convert('RGB')
for lang, d_ in [('de', 'de-DE'), ('en', 'en-US')]:
    out = f'{REPO}/fastlane/metadata/android/{d_}/images'
    W, H = 1024, 500
    img = gradient(W, H, hexrgb('#3FA9D8'), hexrgb('#0F5A93')).convert('RGBA')
    # dezente Wellen rechts
    waves = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    wd = ImageDraw.Draw(waves)
    import math
    for k in range(5):
        pts = [(x, 300 + k * 38 - 22 * math.sin(2 * math.pi * (x - 520) / 260 + k * 0.7)) for x in range(520, W + 1, 4)]
        wd.line(pts, fill=(255, 255, 255, 38 - k * 5), width=10, joint='curve')
    fade = Image.linear_gradient('L').rotate(90).resize((W, H))  # links 0 -> rechts 255
    fade = fade.point(lambda v: min(255, max(0, (v - 128) * 3)))
    waves.putalpha(Image.composite(waves.getchannel('A'), Image.new('L', (W, H), 0), fade))
    img = Image.alpha_composite(img, waves)
    ic = icon.resize((210, 210), Image.LANCZOS)
    sh = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    ImageDraw.Draw(sh).rounded_rectangle([80, 155, 290, 365], 48, fill=(0, 0, 0, 80))
    img = Image.alpha_composite(img, sh.filter(ImageFilter.GaussianBlur(18)))
    img.paste(ic, (80, 145), rounded_mask(ic.size, 48))
    d = ImageDraw.Draw(img)
    d.text((330, 200), 'Calmdrop', font=ImageFont.truetype(SEMI, 84), fill='white', anchor='ls')
    d.text((333, 262), 'Finde deine innere Ruhe.' if lang == 'de' else 'Find your inner calm.',
           font=ImageFont.truetype(REG, 38), fill=(255, 255, 255, 235), anchor='ls')
    img.convert('RGB').save(f'{out}/featureGraphic.png')
    icon.resize((512, 512), Image.LANCZOS).save(f'{out}/icon.png')
print('fertig')
