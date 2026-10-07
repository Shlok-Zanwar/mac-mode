"""
Generate high quality crisp icons for MacMode:
- assets/apple.ico
- assets/windows.ico
Supports 16x16, 24x24, 32x32, 48x48, 64x64, 128x128, 256x256 resolutions.
"""

import os
import re
from PIL import Image, ImageDraw, ImageFilter

def parse_and_render_svg_path(d_str, width=512, height=512, padding=36, fill_color=(255, 255, 255, 255)):
    tokens = []
    for cmd, num in re.findall(r'([MmLlHhVvCcSsQqTtZz])|([-+]?[0-9]*\.?[0-9]+(?:[eE][-+]?[0-9]+)?)', d_str):
        if cmd:
            tokens.append(cmd)
        elif num:
            tokens.append(float(num))

    subpaths = []
    current_subpath = []
    curr_x, curr_y = 0.0, 0.0
    start_x, start_y = 0.0, 0.0
    
    i = 0
    cmd = None
    while i < len(tokens):
        t = tokens[i]
        if isinstance(t, str):
            cmd = t
            i += 1
        
        if cmd in ('M', 'm'):
            x = tokens[i]
            y = tokens[i+1]
            i += 2
            if cmd == 'm':
                curr_x += x
                curr_y += y
            else:
                curr_x = x
                curr_y = y
            start_x, start_y = curr_x, curr_y
            if current_subpath:
                subpaths.append(current_subpath)
            current_subpath = [(curr_x, curr_y)]
            cmd = 'L' if cmd == 'M' else 'l'
        elif cmd in ('C', 'c'):
            x1, y1 = tokens[i], tokens[i+1]
            x2, y2 = tokens[i+2], tokens[i+3]
            x, y = tokens[i+4], tokens[i+5]
            i += 6
            if cmd == 'c':
                p0 = (curr_x, curr_y)
                p1 = (curr_x + x1, curr_y + y1)
                p2 = (curr_x + x2, curr_y + y2)
                p3 = (curr_x + x, curr_y + y)
            else:
                p0 = (curr_x, curr_y)
                p1 = (x1, y1)
                p2 = (x2, y2)
                p3 = (x, y)
            for step in range(1, 31):
                t = step / 30.0
                bx = (1-t)**3 * p0[0] + 3*(1-t)**2 * t * p1[0] + 3*(1-t) * t**2 * p2[0] + t**3 * p3[0]
                by = (1-t)**3 * p0[1] + 3*(1-t)**2 * t * p1[1] + 3*(1-t) * t**2 * p2[1] + t**3 * p3[1]
                current_subpath.append((bx, by))
            curr_x, curr_y = p3
        elif cmd in ('Z', 'z'):
            current_subpath.append((start_x, start_y))
            curr_x, curr_y = start_x, start_y
            subpaths.append(current_subpath)
            current_subpath = []
        else:
            i += 1
            
    if current_subpath:
        subpaths.append(current_subpath)
        
    all_pts = [pt for sp in subpaths for pt in sp]
    min_x = min(pt[0] for pt in all_pts)
    max_x = max(pt[0] for pt in all_pts)
    min_y = min(pt[1] for pt in all_pts)
    max_y = max(pt[1] for pt in all_pts)
    
    bbox_w = max_x - min_x
    bbox_h = max_y - min_y
    scale = min((width - 2*padding) / bbox_w, (height - 2*padding) / bbox_h)
    
    target_cx = width / 2.0
    target_cy = height / 2.0
    src_cx = min_x + bbox_w / 2.0
    src_cy = min_y + bbox_h / 2.0
    
    # Create canvas
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    
    # We create outline shadow for visibility on light taskbars
    border_img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    b_draw = ImageDraw.Draw(border_img)
    
    scaled_subpaths = []
    for sp in subpaths:
        s_sp = [
            (target_cx + (pt[0] - src_cx) * scale, target_cy + (pt[1] - src_cy) * scale)
            for pt in sp
        ]
        scaled_subpaths.append(s_sp)
        b_draw.polygon(s_sp, fill=(30, 30, 30, 140))
        
    border_img = border_img.filter(ImageFilter.GaussianBlur(radius=3))
    
    # Foreground image
    fg_img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    fg_draw = ImageDraw.Draw(fg_img)
    for s_sp in scaled_subpaths:
        fg_draw.polygon(s_sp, fill=fill_color)
        
    # Composite
    img = Image.alpha_composite(img, border_img)
    img = Image.alpha_composite(img, fg_img)
    
    return img

def render_windows_logo(size=512, gap=28, margin=48):
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    win_blue = (0, 120, 212, 255)
    sq_size = (size - 2 * margin - gap) / 2
    
    # Top-left
    draw.rectangle([margin, margin, margin + sq_size, margin + sq_size], fill=win_blue)
    # Top-right
    draw.rectangle([margin + sq_size + gap, margin, margin + 2 * sq_size + gap, margin + sq_size], fill=win_blue)
    # Bottom-left
    draw.rectangle([margin, margin + sq_size + gap, margin + sq_size, margin + 2 * sq_size + gap], fill=win_blue)
    # Bottom-right
    draw.rectangle([margin + sq_size + gap, margin + sq_size + gap, margin + 2 * sq_size + gap, margin + 2 * sq_size + gap], fill=win_blue)
    
    return img

def main():
    assets_dir = os.path.dirname(os.path.abspath(__file__))
    apple_svg = 'M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M15.97 6.37c.62-.75 1.04-1.8 1.01-2.87-.9.04-2 .6-2.65 1.35-.58.67-1.08 1.74-1.01 2.79 1.01.08 2.03-.52 2.65-1.27z'
    
    apple_hires = parse_and_render_svg_path(apple_svg, width=512, height=512, padding=36, fill_color=(250, 250, 252, 255))
    windows_hires = render_windows_logo(size=512, gap=28, margin=48)
    
    sizes = [(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)]
    
    apple_ico_path = os.path.join(assets_dir, 'apple.ico')
    apple_hires.save(apple_ico_path, format='ICO', sizes=sizes)
    print(f"Generated {apple_ico_path} with sizes: {sizes}")
    
    windows_ico_path = os.path.join(assets_dir, 'windows.ico')
    windows_hires.save(windows_ico_path, format='ICO', sizes=sizes)
    print(f"Generated {windows_ico_path} with sizes: {sizes}")

if __name__ == '__main__':
    main()
