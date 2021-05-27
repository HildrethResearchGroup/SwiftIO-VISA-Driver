// Code for VISA Driver Project
// Authors: Ryan, Ethan, Grant, Mitch

import SwiftIO

let uart = UART(Id.UART1)

print(uart.checkBufferReceived())

uart.clearBuffer()

uart.write(56)
uart.write(54)
uart.write(57)
uart.write(56)

print(uart.readByte(timeout: -1))