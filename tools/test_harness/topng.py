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
            w=d.textlength(t,font=f)
            px = x - w/2 if al==30 else x
            d.text((px, h-y), t, fill=col, font=f)
    im.save(ppm[:-4]+'.png')
print('ok')
