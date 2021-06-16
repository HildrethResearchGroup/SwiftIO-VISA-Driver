// Code Template for VISA Driver Project
// Authors: Grant Rulon, Ryan Rumana, Ethan Vijayabaskaran, and Mitch Watkins

// Project Imports //////////////////////////////////////////////////
import SwiftIO						// Basic import for all programs
// Add more here if needed


// Project Instance Variables ///////////////////////////////////////
let uart = UART(Id.UART0)			// initializing the UART object for communication
let i2c = I2C(Id.I2C0)				// initializing the I2C object for communication
let lcd = LCD1602(i2c)				// initializing the LCD screen as a child of i2c
let scpi = SCPI()
// Add more here if needed


// Project setup ////////////////////////////////////////////////////
uart.clearBuffer()					// clearing the serial buffer before first input
lcd.clear()							// clearing the lcd screen before first input	
// add any misc actions needed before the main while loop

// Project while loop ///////////////////////////////////////////////
while true {
    // prompting the user
    uart.write("Ready for Command:")
    
    // waiting for a visa command
    let input = uart.read(count: 64, timeout: -1)
    
    // UInt8 array to string conversion
    var array = [String]()
    for x in input {
        let y = String(UnicodeScalar(UInt8(x)))
        array.append(y)
	}
    let stringIn = array.joined()
    
    // writing the string to the display for the user to see
    uart.write(" \(stringIn)\n")
    
    // pass the string into the VISA class and write the output to the screen
    uart.write(scpi.trimCommand(stringIn))
}