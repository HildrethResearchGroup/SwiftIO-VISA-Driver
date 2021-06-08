// Code Template for VISA Driver Project
// Authors: Grant Rulon, Ryan Rumana, Ethan Vijayabaskaran, and Mitch Watkins

// Project Imports //////////////////////////////////////////////////
import SwiftIO						// Basic import for all programs
// Add more here if needed


// Project Instance Variables ///////////////////////////////////////
let uart = UART(Id.UART1)			// initializing the UART object for communication
let i2c = I2C(Id.I2C0)				// initializing the I2C object for communication
let lcd = LCD1602(i2c)				// initializing the LCD screen as a child of i2c
let led = PWMOut(Id.PWM0A)			// initializing digital control of pin
// Add more here if needed


// Project setup ////////////////////////////////////////////////////
uart.clearBuffer()					// clearing the serial buffer before first input
lcd.clear()							// clearing the lcd screen before first input		
// add any misc actions needed before the main while loop


// Project while loop ///////////////////////////////////////////////
while true {
    // prompting the user
    uart.write("Read Character: ")
    
    // waiting for a visa command
    let input = uart.read(count: 8, timeout: -1)
    
    // UInt8 array to string conversion
    var array = [String]()
    for x in input {
        let y = String(UnicodeScalar(UInt8(x)))
        array.append(y)
	}
    let stringIn = array.joined()
    
    if(stringIn == "LED on  "){
		led.setDutycycle(1)
    } else if(stringIn == "LED off "){
		led.setDutycycle(0.001)
    } else {
		lcd.write(x: 0, y: 0, stringIn)
    }

    uart.write("\n")    		// newline
    
}