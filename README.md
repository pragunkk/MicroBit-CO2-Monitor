# CO₂ Monitoring System Using micro:bit and MH-Z19E Sensor

## 1. Introduction

This project explores interfacing a BBC micro:bit with the MH-Z19E CO₂ sensor using the UART communication protocol. The main objective was to develop the system in ARM Cortex-M0 assembly language. A working product was developed using Python (via the micro:bit’s MicroPython IDE) to validate the hardware setup and logic used, and we then tried to implement it in Assembly. However, due to technical limitations and time constraints, the assembly implementation was not functional, therefore we stuck to the python implementation. The protocol used to communicate with the sensor also remains the same as the assembly idea.

### Demo Video:
https://iiitbac-my.sharepoint.com/:v:/g/personal/pragun_kirani_iiitb_ac_in/EbtaywGwC3VEgZh9BCtjwMUBJX2YXOTy4h0m4-A6_DjCEQ?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=2J7q3I

---

## 2. Components Used

* BBC micro:bit v2 [Provided]
* MH-Z19E CO₂ Sensor (NDIR) [PURCHASED]
* Logic Level Shifter (5V ↔ 3.3V) [PURCHASED]
* Jumper wires [PURCHASED]
* Breadboard [PURCHASED]
* 5V Power Supply (for the MH-Z19E sensor) (Initially in form of USB-C breakout board [PURCHASED], switched to using Arduino [Already had one] since we couldn't solder the header pins)
* **IMPORTANT**: The arduino was only used to power the sensor via its 5V port and GND pin. It was not programmed at all, and was just plugged into the wall socket.
---

## 3. Objectives

* Interface the MH-Z19E sensor with the micro:bit using UART.
* Prototype and test the system in Python to verify hardware correctness, sensor communication and project viability.
* Attempt to implement UART communication using ARM Cortex-M0 assembly.

---

## 4. System Architecture

### Hardware Connections

* MH-Z19E TX (5V) → Logic Level Shifter → Micro:bit P1 (UART RX)
* Micro:bit P0 (UART TX) → Logic Level Shifter → MH-Z19E RX
* MH-Z19E VCC → 5V Supply (arduino 5V)
* GND → Common ground (microbit, arduino, mhz19e GNDs are connected to Logic level shifter GND)

### Communication Protocol

* **UART Settings:** 9600 baud, 8 data bits, no parity, 1 stop bit
* **Response Format:** Starts with `FF 86` followed by high and low CO₂ bytes

    ```
    CO₂ ppm = HIGH_BYTE × 256 + LOW_BYTE
    ```

---

## 5. Software Development

### Python-Based Prototype (Successful)

Using MicroPython on the Micro:bit, we were able to:

* Send the correct 9-byte command to the MH-Z19E using the built-in UART library.
* Receive a valid response containing high and low bytes.
* Calculate the CO₂ ppm and Temperature value and display it over the serial console via sliding text.

### Assembly Approach (Unsuccessful)

We attempted to write UART routines in ARM Cortex-M0 assembly to:

* Initialize UART registers.
* Transmit the sensor query command.
* Receive the 9-byte response.
* Parse and display the CO₂ ppm value by either showing bars on the LED matrix or via displaying numbers.

Despite repeated debugging, the following issues prevented successful implementation:

* Bit-Banging manually to implement the UART protocol proved to be a difficult task.
* Incomplete understanding of Micro:bit-specific UART register mapping.
* Difficulties in synchronizing UART transmit/receive at 9600 baud, with precise timing specifications.
* Lack of readily available online resources for this specific use-case.

---

## 6. Challenges Faced

* **ARM Cortex-M0 Learning Curve:** ARM Cortex-M0 being a new language proved hard to learn and even harder to implement.
* **Assembly Language Limitations:** Writing UART in pure ARM Cortex-M0 assembly on the Micro:bit without standard libraries for UART proved very difficult. Trying to code/implement low-level timing and register operations was tedious and didn't yield any positive results.
* **Voltage Incompatibility:** The MH-Z19E operates at 5V, while the Micro:bit uses 3.3V. A logic level shifter was essential to prevent damage and ensure data integrity.
* **UART Framing Issues:** Even in Python, ensuring correct timing and byte framing required proper delay values and buffer handling. This issue was, of course, worse in assembly.

---

## 7. Outcome

While the original goal to develop the system fully in assembly was not achieved, the fallback Python implementation demonstrated:

* Successful communication with the MH-Z19E sensor.
* Accurate CO₂ readings in ppm.
* Passable temperature readings thanks to the small built-in temperature sensor in the MH-Z19E.
* A working UART interface at 9600 baud using MicroPython.

This confirmed that the hardware and command logic were correct, and the main limitations were in the assembly level UART implementation.

---

## 8. Video Demonstration

We have attached a video demonstration as well with this report. The testing has been done in a room with quite high levels of CO₂. To further prove the sensor’s potency, we have used a candle to increase the level of CO₂ near the sensor, which was perfectly read by the sensor. The sensor shows 500ppm when it is being initialized, which takes quite some time. We have also utilized the temperature sensor within it.

---

## 9. Conclusion

This project served as a valuable hands-on exercise in embedded systems design. Although the assembly language approach was not fully successful, the Python prototype confirmed the viability of the hardware setup and UART protocol. The process highlighted the challenges of low-level programming and the importance of debugging tools and documentation when working with microcontrollers.
