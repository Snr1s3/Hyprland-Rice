

def get_brightness():
    try:
        base_path = "/sys/class/backlight/intel_backlight/"
        with open(base_path + "brightness", 'r') as f_bright, open(base_path + "max_brightness", 'r') as f_max:
            current_brightness = int(f_bright.read().strip())
            max_brightness = int(f_max.read().strip())
        return round((current_brightness / max_brightness) * 100)
    except Exception as e:
        return str(e)
    

a=get_brightness()

if a <=10:
    print(str(a) + "% 🌑")
elif a <=25:
    print(str(a) + "% 🌒")
elif a <=50:
    print(str(a) + "% 🌓")
elif a <=75:
    print(str(a) + "% 🌔")
else:    
    print(str(a) + "% 🌕")

