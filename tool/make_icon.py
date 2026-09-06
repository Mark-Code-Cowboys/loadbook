#!/usr/bin/env python3
"""Regenerates assets/icon/*.png — the Loadbook placeholder mark: an
open notebook with a target roundel on warm brass #8C6A3F. Notebook and
target only — rails §4 allows press, brass, targets, notebook.
Run from the repo root, then `dart run flutter_launcher_icons`."""
from PIL import Image, ImageDraw

BRASS = (140, 106, 63, 255)
WHITE = (255, 255, 255, 255)
CREAM = (240, 236, 224, 255)


def draw_glyph(d, s, ox=0, oy=0):
    def px(x):
        return ox + x * s

    def py(y):
        return oy + y * s

    # Open notebook: two page panels meeting at a spine.
    d.polygon([(px(0.18), py(0.30)), (px(0.48), py(0.24)),
               (px(0.48), py(0.74)), (px(0.18), py(0.80))], fill=CREAM)
    d.polygon([(px(0.82), py(0.30)), (px(0.52), py(0.24)),
               (px(0.52), py(0.74)), (px(0.82), py(0.80))], fill=WHITE)
    # Spine.
    d.rectangle([px(0.485), py(0.24), px(0.515), py(0.77)], fill=BRASS)
    # Ruled lines on the left page.
    for i, y in enumerate((0.38, 0.46, 0.54, 0.62)):
        d.line([(px(0.23), py(y + 0.008)), (px(0.43), py(y - 0.004))],
               fill=BRASS, width=max(1, int(0.016 * s)))
    # Target roundel on the right page.
    cx, cy = 0.67, 0.50
    for r in (0.105, 0.065):
        d.ellipse([px(cx - r), py(cy - r), px(cx + r), py(cy + r)],
                  outline=BRASS, width=max(2, int(0.02 * s)))
    r = 0.026
    d.ellipse([px(cx - r), py(cy - r), px(cx + r), py(cy + r)],
              fill=BRASS)


img = Image.new('RGBA', (1024, 1024), BRASS)
draw_glyph(ImageDraw.Draw(img), 1024)
img.save('assets/icon/icon.png')

fg = Image.new('RGBA', (1024, 1024), (0, 0, 0, 0))
draw_glyph(ImageDraw.Draw(fg), 640, ox=192, oy=192)
fg.save('assets/icon/icon_foreground.png')
print('icons written')
