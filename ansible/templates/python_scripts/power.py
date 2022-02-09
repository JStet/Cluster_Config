import gpiozero
import time
import sys


def short(gpio_pin):
    relay = gpiozero.OutputDevice(gpio_pin, active_high=True, initial_value=False)
    relay.on()
    time.sleep(1.5)
    relay.off()


pin_dict = {"old-pc":5,"raspi1":6,"raspi2":13,"raspi3":19,"raspi4":26}
all_lst = pin_dict.keys()

short(pin_dict[sys.argv[1]])
