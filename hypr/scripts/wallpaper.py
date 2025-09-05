import os
import random
import time

wallpaper_dir = r'/home/nic/Wallpapers/'

wallpapers = os.listdir(wallpaper_dir)

os.chdir(wallpaper_dir)


while True:
    wallpaper = random.choice(wallpapers)
    os.system(f"swww img {wallpaper} --transition-type center --transition-fps 60")
    time.sleep(3600)
