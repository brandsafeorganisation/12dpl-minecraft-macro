import sys, glob, os
from PIL import Image, ImageDraw, ImageFont
for ppm in sorted(glob.glob(sys.argv[1]+'/*.ppm')):
    im=Image.open(ppm).convert('RGB'); d=ImageDraw.Draw(im); h=im.size[1]
    txt=ppm[:-4]+'.txt'
    if os.path.exists(txt):
        for line in open(txt):
            p=line.rstrip('\n').split('\t')
            if len(p)<8: continue
            x,y,s=float(p[0]),float(p[1]),float(p[2]); al=int(p[3]); col=(int(p[4]),int(p[5]),int(p[6])); t=p[7]
            try: f=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', max(6,int(s*0.8)))
            except: f=ImageFont.load_default()
            # al is a set of Windows TA_* flags, as 12d passes it on:
            # TA_CENTER 6 / TA_RIGHT 2 across, TA_BASELINE 24 / TA_BOTTOM 8
            # up and down (else the top of the text is at y)
            across = 'm' if al & 6 == 6 else ('r' if al & 2 else 'l')
            down = 's' if al & 24 == 24 else ('d' if al & 8 else 'a')
            d.text((x, h-y), t, fill=col, font=f, anchor=across+down)
    im.save(ppm[:-4]+'.png')
print('ok')
