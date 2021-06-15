import SwiftIO

class Pin {
    
    // Variables for pin values
    var pinNum:  pinN				// Pin number
    var pinType: pinT				// Pin output type
    var pinVolt: Float				// Pin Voltage
    var pinDuty: Float				// Pin Duty Cycle
    
	enum pinN {
		case Zero, One, Two, Three, Four, Five, Six, Seven, 
        	 Eight, Nine, Ten, Eleven, Twelve, Thirteen, NULL
	}
    
    enum pinT {
		case AnalogIn, AnalogOut, DigitalIn, DigitalOut, PWMOut, NULL
	}
    
    init(_ type: String, _ num: Int){
        if(num == 0)	  	{ pinNum = pinN.Zero }
        else if(num == 1) 	{ pinNum = pinN.One }
        else if(num == 2) 	{ pinNum = pinN.Two }
        else if(num == 3) 	{ pinNum = pinN.Three }
        else if(num == 4) 	{ pinNum = pinN.Four }
        else if(num == 5) 	{ pinNum = pinN.Five }
        else if(num == 6) 	{ pinNum = pinN.Six }
        else if(num == 7) 	{ pinNum = pinN.Seven }
        else if(num == 8) 	{ pinNum = pinN.Eight }
        else if(num == 9) 	{ pinNum = pinN.Nine }
        else if(num == 10)	{ pinNum = pinN.Ten }
        else if(num == 11)	{ pinNum = pinN.Eleven }
        else if(num == 12)	{ pinNum = pinN.Twelve }
        else if(num == 13)	{ pinNum = pinN.Thirteen }
        else 			  	{ pinNum = pinN.NULL }
        
        if(type == "AnalogIn") 			{ pinType = pinT.AnalogIn}
        else if(type == "AnalogOut") 	{ pinType = pinT.AnalogOut}
        else if(type == "DigitalIn") 	{ pinType = pinT.DigitalIn}
    	else if(type == "DigitalOut") 	{ pinType = pinT.DigitalOut}
        else if(type == "PWMOut") 		{ pinType = pinT.PWMOut}
        else 							{ pinType = pinT.NULL}
        
        pinVolt = 0
        pinDuty = 0.0
    }
    
    init(_ num: Int){
        if(num == 0)	  	{ pinNum = pinN.Zero }
        else if(num == 1) 	{ pinNum = pinN.One }
        else if(num == 2) 	{ pinNum = pinN.Two }
        else if(num == 3) 	{ pinNum = pinN.Three }
        else if(num == 4) 	{ pinNum = pinN.Four }
        else if(num == 5) 	{ pinNum = pinN.Five }
        else if(num == 6) 	{ pinNum = pinN.Six }
        else if(num == 7) 	{ pinNum = pinN.Seven }
        else if(num == 8) 	{ pinNum = pinN.Eight }
        else if(num == 9) 	{ pinNum = pinN.Nine }
        else if(num == 10)	{ pinNum = pinN.Ten }
        else if(num == 11)	{ pinNum = pinN.Eleven }
        else if(num == 12)	{ pinNum = pinN.Twelve }
        else if(num == 13)	{ pinNum = pinN.Thirteen }
        else 			  	{ pinNum = pinN.NULL }
        
        pinType = pinT.NULL
        pinVolt = 0
        pinDuty = 0.0
    }
    
	func getType() -> String {
        if		(pinType == pinT.AnalogIn) 		{ return "Analog IN\n" } 
        else if	(pinType == pinT.AnalogOut)		{ return "Analog OUT\n" } 
		else if	(pinType == pinT.DigitalIn) 	{ return "Digital IN\n" }
        else if	(pinType == pinT.DigitalOut)	{ return "Digital OUT\n" }
        else if	(pinType == pinT.PWMOut) 		{ return "PWM OUT\n" }
        else									{ return "NULL\n"}
    }
    
    func setType(_ type: String){
        if(type == "AnalogIn") 			{ pinType = pinT.AnalogIn}
        else if(type == "AnalogOut") 	{ pinType = pinT.AnalogOut}
        else if(type == "DigitalIn") 	{ pinType = pinT.DigitalIn}
    	else if(type == "DigitalOut") 	{ pinType = pinT.DigitalOut}
        else if(type == "PWMOut") 		{ pinType = pinT.PWMOut}
        else 							{ pinType = pinT.NULL}
    }
    
    func getPinNum() -> Int {
        if	   (pinNum == pinN.Zero) 		{ return 0 }
        else if(pinNum == pinN.One) 		{ return 1 }
        else if(pinNum == pinN.Two) 		{ return 2 }
        else if(pinNum == pinN.Three) 		{ return 3 }
        else if(pinNum == pinN.Four) 		{ return 4 }
        else if(pinNum == pinN.Five) 		{ return 5 }
        else if(pinNum == pinN.Six) 		{ return 6 }
        else if(pinNum == pinN.Seven) 		{ return 7 }
        else if(pinNum == pinN.Eight) 		{ return 8 }
        else if(pinNum == pinN.Nine) 		{ return 9 }
        else if(pinNum == pinN.Ten) 		{ return 10 }
        else if(pinNum == pinN.Eleven) 		{ return 11 }
        else if(pinNum == pinN.Twelve) 		{ return 12 }
        else if(pinNum == pinN.Thirteen) 	{ return 13 }
        else 								{ return -1 }				
    }
    
    func getPinVolt() {
        if		(pinType == pinT.AnalogIn) 		{ uart.write("Analog Input Voltage: \(pinVolt)\n") } 
        else if	(pinType == pinT.AnalogOut)		{ uart.write("Analog Output Voltage: \(pinVolt)\n") } 
		else if	(pinType == pinT.DigitalIn) 	{ uart.write("Digital Input Voltage: \(pinVolt)\n") }
        else if	(pinType == pinT.DigitalOut)	{ uart.write("Digital Output Voltage: \(pinVolt)\n") }
        else									{ uart.write("NULL\n") }
    }
    
    func getPinDutyCycle() {
        if(self.getPinNum() == 4 || self.getPinNum() == 5 || self.getPinNum() == 10 || 
           self.getPinNum() == 11 || self.getPinNum() == 12 || self.getPinNum() == 13 ){
            uart.write("Source PWM Output Duty Cycle: \(pinDuty)\n")
        } else {
			uart.write("Pin not capable of PWM Output")
        }
    }
    
    func setDutyCycle(_ input: Float) {
        self.setType("PWMOut")
        self.pinDuty = input
        if(self.getPinNum() == 4){
            let output = PWMOut(Id.PWM0A)
            output.setDutycycle(input)
        } else if(self.getPinNum() == 5) {
        	let output = PWMOut(Id.PWM1A)
            output.setDutycycle(input)
        } else if(self.getPinNum() == 10) {
        	let output = PWMOut(Id.PWM2B)
            output.setDutycycle(input)
        } else if(self.getPinNum() == 11) {
        	let output = PWMOut(Id.PWM2A)
            output.setDutycycle(input)
        } else if(self.getPinNum() == 12) {
        	let output = PWMOut(Id.PWM3B)
            output.setDutycycle(input)
        } else if(self.getPinNum() == 13) {
        	let output = PWMOut(Id.PWM3A)
            output.setDutycycle(input)
        } else { 
            uart.write("Invalid source pin selected \n") 
        }
        uart.write("PWM duty cycle set \n")
    }
}