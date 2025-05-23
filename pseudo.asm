; UART CONFIGURATION
    MOV     TX_PIN, P0              ; Set P0 as TX (sensor RX)
    MOV     RX_PIN, P1              ; Set P1 as RX (sensor TX)
    CALL    UART_INIT               ; Init UART at 9600 baud


; MAIN LOOP
MAIN_LOOP:
    ; SEND READ CO2 COMMAND
    MOV     CMD_BUF, [0xFF, 0x01, 0x86, 0x00, 0x00, 0x00, 0x00, 0x00, 0x79]
    CALL    UART_WRITE, CMD_BUF, 9

    ; Delay to wait for sensor response (100ms)
    CALL    SLEEP_MS, 100

    ; READ SENSOR RESPONSE
    CALL    UART_READ, RESP_BUF, 9
    CMP     LEN(RESP_BUF), 9
    JNE     SHOW_NO_RESPONSE

    ; VALIDATE RESPONSE HEADER
    CMP     RESP_BUF[0], 0xFF
    JNE     SHOW_HEADER_ERROR
    CMP     RESP_BUF[1], 0x86
    JNE     SHOW_HEADER_ERROR

    ; CHECKSUM VALIDATION
    
    CALL    CALC_CHECKSUM, RESP_BUF+1, 7     ; Sum RESP[1]toRESP[7]
    MOV     EXPECTED_CS, RETURN_VALUE
    CMP     RESP_BUF[8], EXPECTED_CS
    JNE     SHOW_CHECKSUM_ERROR

    
    ; PARSE CO2 AND TEMP (EXTRACT VALUES)
    
    MOV     CO2_HIGH, RESP_BUF[2]
    MOV     CO2_LOW, RESP_BUF[3]
    SHL     CO2_HIGH, 8
    OR      CO2_HIGH, CO2_LOW
    MOV     CO2_VALUE, CO2_HIGH

    MOV     TEMP_RAW, RESP_BUF[4]
    SUB     TEMP_RAW, 40
    MOV     TEMP_C, TEMP_RAW

    
    ; DISPLAY CO2 LEVEL AS BARS ON LED MATRIX
    
    ; Levels: 0–400, 400–800, ..., 1600–2000
    CMP     CO2_VALUE, 400
    JLT     SHOW_1_BAR
    CMP     CO2_VALUE, 800
    JLT     SHOW_2_BARS
    CMP     CO2_VALUE, 1200
    JLT     SHOW_3_BARS
    CMP     CO2_VALUE, 1600
    JLT     SHOW_4_BARS
    JMP     SHOW_5_BARS

; DISPLAYING
SHOW_1_BAR:
    CALL    DRAW_LED_ROWS, 1
    JMP     DELAY_AND_REPEAT

SHOW_2_BARS:
    CALL    DRAW_LED_ROWS, 2
    JMP     DELAY_AND_REPEAT

SHOW_3_BARS:
    CALL    DRAW_LED_ROWS, 3
    JMP     DELAY_AND_REPEAT

SHOW_4_BARS:
    CALL    DRAW_LED_ROWS, 4
    JMP     DELAY_AND_REPEAT

SHOW_5_BARS:
    CALL    DRAW_LED_ROWS, 5
    JMP     DELAY_AND_REPEAT

SHOW_NO_RESPONSE:
    CALL    DISPLAY_CHAR, 'N'
    JMP     DELAY_AND_REPEAT

SHOW_HEADER_ERROR:
    CALL    DISPLAY_CHAR, 'H'
    JMP     DELAY_AND_REPEAT

SHOW_CHECKSUM_ERROR:
    CALL    DISPLAY_CHAR, 'E'
    JMP     DELAY_AND_REPEAT


; WAIT AND REPEAT

DELAY_AND_REPEAT:
    CALL    SLEEP_MS, 5000
    JMP     MAIN_LOOP
