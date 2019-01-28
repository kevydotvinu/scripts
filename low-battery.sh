while true;
do if [ $(acpi -b | cut -d" " -f4 | grep -o '[0-9]*') -le 20 ]; then
	notify-send -i "/usr/share/icons/Adwaita/32x32/devices/ac-adapter.png" "Plug-in AC adapter"
fi
sleep 15s
done
