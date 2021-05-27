// Code for VISA Driver Project
// Authors: Ryan, Ethan, Grant, Mitch

import SwiftIO

let uart = UART(Id.UART1)
while true {
    print(uart.checkBufferReceived())
    sleep(ms: 2000)
}


uart.clearBuffer()

