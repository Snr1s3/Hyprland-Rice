#pip install pyalsaaudio
#sudo dnf install alsa-lib-devel python3-devel

import alsaaudio
import os
import sys

def get_mic_volume():
    try:
        mixer = alsaaudio.Mixer('Capture')
        return mixer.getvolume()[0]
    except alsaaudio.ALSAAudioError:
        return "No microphone found"

def increase_mic_volume(increase_by):
    try:
        mixer = alsaaudio.Mixer('Capture')
        current_volume = mixer.getvolume()[0]
        new_volume = min(100, current_volume + increase_by)
        mixer.setvolume(new_volume)
        return new_volume
    except alsaaudio.ALSAAudioError:
        return "No microphone found"
    
def decrease_mic_volume(decrease_by):
    try:
        mixer = alsaaudio.Mixer('Capture')
        current_volume = mixer.getvolume()[0]
        new_volume = min(100, current_volume - decrease_by)
        mixer.setvolume(new_volume)
        return new_volume
    except alsaaudio.ALSAAudioError:
        return "No microphone found"

def toggle_mic():
    try:
        mixer = alsaaudio.Mixer('Capture')
        current_volume = mixer.getvolume()[0]
        if current_volume == 0:
            mixer.setvolume(100)
            return 100
        else:
            mixer.setvolume(0)
            return 0
    except alsaaudio.ALSAAudioError:
        return "No microphone found"
volumeBkp=100
backup_file = '/home/snr1s3/.config/waybar/scriptsPy/micScripts/backup_volume.txt'
backup_dir = os.path.dirname(backup_file)

def toggle_mic():
    try:
        global volumeBkp
        mixer = alsaaudio.Mixer('Capture')
        current_volume = mixer.getvolume()[0]
        if current_volume == 0:
            with open('/home/snr1s3/.config/waybar/scriptsPy/micScripts/backup_volume.txt', 'r') as f:
                volumeBkp = int(f.read())
            mixer.setvolume(volumeBkp)
            print (volumeBkp)
            return mixer.getvolume()[0]
        else:
            volumeBkp=current_volume
            print (volumeBkp)
            with open('/home/snr1s3/.config/waybar/scriptsPy/micScripts/backup_volume.txt', 'w') as f:
                f.write("Mic "+str(volumeBkp))
            mixer.setvolume(0)
            return 0
    except alsaaudio.ALSAAudioError:
        return "No microphone found"
    except FileNotFoundError:
        if not os.path.isfile(backup_file):
            os.makedirs(backup_dir, exist_ok=True)
            with open(backup_file, 'w') as f:
                f.write("Mic "+str(volumeBkp))

#MAIN
var = int(sys.argv[1])
if var == 1:
    print("Mic "+str(increase_mic_volume(100))+ " %")
elif var == 2:
    print("Mic "+str(decrease_mic_volume(100))+ " %")
else:
    print("Mic "+str(get_mic_volume())+ " %")
    
