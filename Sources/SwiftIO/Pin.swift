import SwiftIO

class Pin {
    
    // Variables for pin values
    var pinNum:  pinN				// Pin number
    var pinType: pinT				// Pin output type
    var pinVolt: Int				// Pin Voltage
    
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
    }
    
	func getType() -> String {
        if		(pinType == pinT.AnalogIn) 		{ return "Analog IN\n\n" } 
        else if	(pinType == pinT.AnalogOut)		{ return "Analog OUT\n\n" } 
		else if	(pinType == pinT.DigitalIn) 	{ return "Digital IN\n\n" }
        else if	(pinType == pinT.DigitalOut)	{ return "Digital OUT\n\n" }
        else if	(pinType == pinT.PWMOut) 		{ return "PWM OUT\n\n" }
        else									{ return "NULL\n\n"}
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
    
    func getPinVolt() -> String {
        if		(pinType == pinT.AnalogIn) 		{ return "Analog Input Voltage: \(pinVolt)\n" } 
        else if	(pinType == pinT.AnalogOut)		{ return "Analog Output Voltage: \(pinVolt)\n" } 
		else if	(pinType == pinT.DigitalIn) 	{ return "Digital Input Voltage: \(pinVolt)\n" }
        else if	(pinType == pinT.DigitalOut)	{ return "Digital Output Voltage: \(pinVolt)\n" }
        else if	(pinType == pinT.PWMOut) 		{ return "PWM Output Duty Cycle: \(pinVolt)\n" }
        else									{ return "NULL\n"}
    }
}