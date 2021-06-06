// Code for VISA Driver Project
// Authors: Ryan, Ethan, Grant, Mitch

import SwiftIO

// creating the UART object
let uart = UART(Id.UART1)
uart.clearBuffer()

// creating the I2C object
//let i2c = I2C(Id.I2C0)
//let lcd = LCD1602(i2c)

while true {
    sleep(ms: 2000)
    uart.write("Intro Message: Hello world \n")
    
    uart.write("Read Character: ")
    let input = uart.read(count: 5, timeout: -1)
    uart.write("\n")
    
    //uart.write("Output: \(input) \n")
    lcd.write(x: 0, y: 0, input)
    
    uart.write("\n")
    uart.write("\n")
    uart.write("\n")
}


