from microbit import *
import time

uart.init(baudrate=9600, tx=pin0, rx=pin1)

READ_CO2 = bytearray([0xFF, 0x01, 0x86, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79]) #here 0x86 asks the sensor to send co2 and temperature data

def get_co2():
    uart.read()
    
    uart.write(READ_CO2)
    
    time.sleep_ms(100)
    
    if uart.any():
        response = uart.read(9)
        
        if response and len(response)>=9 and response[0]==0xFF and response[1]==0x86:
            co2 = (response[2]*256) + response[3]
            
            temp = response[4] - 40
            
            return co2, temp
        else:
            return None, None
    else:
        return None, None

while True:
    co2_value, temp_value = get_co2()
    
    if co2_value is not None:
        display.scroll("CO2: " + str(co2_value) + "ppm", delay=80)
        display.scroll("Temp: " + str(temp_value) + "C", delay=80)
    else:
        display.scroll("Error", delay=80)
    
    time.sleep(5)