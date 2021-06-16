// Code Template for VISA Driver Project
// Authors: Grant Rulon, Ryan Rumana, Ethan Vijayabaskaran, and Mitch Watkins

// Project Imports //////////////////////////////////////////////////
import SwiftIO						// Basic import for all programs
// Add more here if needed


// String extensions due to missing foundation library //////////////
extension String{
    // programmatic .contains method
    func contains(_ word: String) -> Bool{
        var start = startIndex
        repeat{
            let subString = self[start..<endIndex]
            if subString.hasPrefix(word){
                return true
            }
            start = self.index(after: start)
        }while start != endIndex
        return false
    }
    
    // programmatic method to remove white space
    func components(withMaxLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }
}


// Class definition  ///////////////////////////////////////////////
class SCPI {
    
    // variables representing the Analog pins
    // They are labeled A0 - A5 on the board as well
    let pinA0 = Pin("AnalogIn", 0)
    let pinA1 = Pin("AnalogIn", 1)
    let pinA2 = Pin("AnalogIn", 2)
    let pinA3 = Pin("AnalogIn", 3)
    let pinA4 = Pin("AnalogIn", 4)
    let pinA5 = Pin("AnalogIn", 5)
    
    // variables representing the Digital pins
    // They are labeled D0 - D13 on the board as well
    let pinDN  = Pin(-1)	// NULL pin, for a base case
    let pinD0  = Pin(0)		// taken up by UART
    let pinD1  = Pin(1)		// taken up by UART
    let pinD2  = Pin(2)
    let pinD3  = Pin(3)
    let pinD4  = Pin(4)
    let pinD5  = Pin(5)
    let pinD6  = Pin(6)
    let pinD7  = Pin(7)
    let pinD8  = Pin(8)
    let pinD9  = Pin(9)
    let pinD10 = Pin(10)
    let pinD11 = Pin(11)
    let pinD12 = Pin(12)
    let pinD13 = Pin(13)
    
    // variables that are not pins
    var source: Pin
    
    // init function, required to have default class settings
    init(){
        source = pinDN
    }
    
    // trim command function:
    // takes input string from main class, which is padded with spaces to 
    // be 64 bytes and removes the whitespace everywhere but inside of the
    // DISP command, because those spaces are a string literal.
    //
    // Note: these methods were implemented this way due to the lack of
    // Foundation library support and the lack of the associated complex 
    // string commands
    func trimCommand(_ inStr: String) -> String {
        let noSpaces = inStr.split(separator: " ", omittingEmptySubsequences: true)
        var input: String = ""
        var display = false
        for x in noSpaces { 
            if(display){ 
                if(String(x).contains(")")){
                    input += " "
                    display = false
                } else {
                    input += " "
                }
            }
            if(String(x).contains("DISP") || String(x).contains("DISPlay")) { display = true }
            input += String(x) 
        }
        
        // starting the recursive parsing function
		return(parseCommand(input))
    }
    
    // This method is a recursive parsing function
    // It will peel commands off of the front, call the associated method, 
    // and then call that method will call this one again. Once the string
    // that is being passed around is empty, the functions will fall through,
    // returning the appropriate error code to the main class.
    func parseCommand(_ input: String) -> String {
        // example string we need to parse : [SOURce(#)]APPLy:SIN 1e4,1,0.1
        
        // initializing the error code
        var errorCode: Int = 0

        // Parsing the string by commands ////////////////////////////////////
        
        // empty command case (base case)
        if(input.isEmpty || input == "" || input == " "){
			errorCode = 0 } 
        
        // command separator case
        else if(input.hasPrefix(":")){
            var output = input
            output.removeFirst(1)
            return(parseCommand(output)) } 
        
        // query case
        else if(input.contains("?")){
            return(Query(input)) } 
        
        // cases associated with the source command, both with and without 
        // command separator notation
        else if(input.hasPrefix("SOURce(")){
            return(parseSource(input, 7, false))
        } else if(input.hasPrefix("SOUR(")){ 
            return(parseSource(input, 5, false))
        } else if(input.hasPrefix("[SOURce(")){
            return(parseSource(input, 8, true))
        } else if(input.hasPrefix("[SOUR(")){ 
            return(parseSource(input, 6, true))
        } 
        
        // cases associated with the Display command
        else if(input.hasPrefix("DISPlay")){
            return(doDSP(input, 8))
        } else if(input.hasPrefix("DISP")){
            return(doDSP(input, 5))
        } 
        
        // cases associated with the Voltage command
        else if(input.hasPrefix("VOLTage")){
            return(voltage(input, 7))
        } else if(input.hasPrefix("VOLT")){
            return(voltage(input, 4))
        } 
        
        // cases associated with the PWM command
        else if(input.hasPrefix("PWM")){
            return(PWM(input, 3)) } 
        
        // You could add more case here:
        //
        //
        //
        //
        
        // case that gives an unknown command error, which causes immediate fallthrough
        else {
			errorCode = 1
        }
        
        // returning the feedback in the form or error codes
        return Feedback(errorCode)
    }
    
    // Function that handles all of the source commands
    // most of this is just string manipulation, which is 
    // very space inefficient without powerful Foundation commands
    func parseSource(_ input: String, _ length: Int, _ Bracket: Bool) -> String{
        // chopping off the ends of the string we don't need
		var next = input
        next.removeFirst(length)
        let closeParenthesis = next.firstIndex(of: ")") ?? next.endIndex
		let pinNumStr = next[..<closeParenthesis]
        
        // the number separated from the string
        let pinNum = Int(pinNumStr) ?? -1
        
        // calling the set source mthod with the pin number
        setSource(pinNum)
        
        // returning the rest of the commands on the string
        var last = input
        var closeBracket: String.Index
        if(Bracket){ closeBracket = input.firstIndex(of: "]") ?? next.endIndex }
        else{ closeBracket = input.firstIndex(of: ")") ?? next.endIndex }
        last.remove(at: closeBracket)
        let out = last[closeBracket...]
        
        // output message that will appear in user GUI
        uart.write("Assigned SOURce to Pin \(pinNum)\n")
        
        // returning the rest of the string for eventua fall through
        return(parseCommand(String(out)))
    }
    
    // Function that handles the voltage assignment for the pin
    //
    // Note: at this time SwiftIO board is not capable of 
    // Analog output. It may be possible through the I2C bus, but
    // that was beyond the scope of our study.
    func voltage(_ input: String, _ length: Int) -> String{
        // parsing the string to get the associated value
		var middle = input
        middle.removeFirst(length)
        let endNum = middle.firstIndex(of: ":") ?? middle.endIndex
        let pinVoltStr = middle[..<endNum]
        
        // setting the voltage value we want and telling the user
        let Voltage = Float(pinVoltStr) ?? -1
        uart.write("Setting source pin to \(Voltage) volts\n")
        
        // gently letting the user know that functionality doesnt work
        uart.write("SwiftIO board is not currently capable of Analog output\n")
        
        // returning the commands that follow if they exist
        if(middle.contains(":")){
			var remaining = String(middle[endNum...])
            remaining.removeFirst() 
            return(parseCommand(String(remaining)))
        } else {
			return(parseCommand(""))
        }
    }
    
    // Function responsible for PWM output on the digital pins
    // works by parsing the string and then passing the relevant information 
    // to the pin that will be outputting the signal
    func PWM(_ input: String, _ length: Int) -> String {
        // parsing the string to get the associated value
		var middle = input
        middle.removeFirst(length)
        let endNum = middle.firstIndex(of: ":") ?? middle.endIndex
        let pinPercentStr = middle[..<endNum]
        
        // The value we want for the duty cycle
        let Percent = Float(pinPercentStr) ?? -1
        
        // telling the source pin to adopt that value in an object oriented way
        source.setDutyCycle(Percent)
        
        // returning the commands that follow if they exist
        if(middle.contains(":")){
			var remaining = String(middle[endNum...])
            remaining.removeFirst() 
            return(parseCommand(String(remaining)))
        } else {
			return(parseCommand(""))
        }
    }
    
    // Function responsible for the Query command
    func Query(_ input: String) -> String {
        // Case for a source query
		if(input.contains("SOURce?") || input.contains("SOUR?")){ 
            return("Current source is \(getSource())\n\n") } 
        
        // Case for a voltage query on the source pin
        else if(input.contains("SOURce.VOLT?") || input.contains("SOURce.VOLTage?") || 
                  input.contains("SOUR.VOLT?") || input.contains("SOUR.VOLTage?")){
            source.getPinVolt()
            return(parseCommand("")) } 
        
        // case for a duty cycle query on the PWM command
        else if(input.contains("SOURce.PWM?") || input.contains("SOUR.PWM?")){
            source.getPinDutyCycle()
            return(parseCommand("")) } 
        
        // You could add more case here:
        //
        //
        //
        //
        
        // Case for the unknown query error, which causes immediate fallthrough
        else {
            return Feedback(2)
        }
    }
    
    
    // Function to handle the display commands
    func doDSP(_ input: String, _ length: Int) -> String {
        // clear the screen and prepare 
        lcd.clear()
        
        // string parsing to isolate message in question
        var middle = input
        middle.removeFirst(length)
        let closeParenthesis = middle.firstIndex(of: ")") ?? middle.endIndex
    	var remaining = String(middle[closeParenthesis...])
        remaining.removeFirst()
        
        // output is the message intended to be printed
        let output = middle[..<closeParenthesis]
        
        // since the screen can do 16 characters without running off the end or 
        // needing 2 lines, this case simply prints it normally
        if(output.count <= 16) {
            lcd.write(x: 0, y: 0, String(output)) }
        
        // If the message is between 16 and 40 characters, it is short enough to 
        // display with the scroll left command associated with the LCD
        else if(output.count > 16 && output.count <= 40){
            lcd.write(x: 0, y: 0, String(output))
            for _ in 16...output.count-1 {
                sleep(ms: 1000)
                lcd.scrollLeft()
            }
        } 
        
        // If the message is greater than 40 characters, we break it up into strings of size
        // 40 or less and the patches them together on the screen so that they seamlessly fit
        else {
            let parts = String(output).components(withMaxLength: 40)
            var y = true
            for x in parts {
				lcd.write(x: 0, y: 0, String(x))
                if(y){
					for _ in 16...x.count {
                		sleep(ms: 400)
                		lcd.scrollLeft()
            		}
                } else {
					for _ in 0...x.count-2 {
                		sleep(ms: 400)
                		lcd.scrollLeft()
                	}
            	}
                y = false
            }
        }
        
        // message th the user to acknowlege command
        uart.write("Printed to screen\n")
        
        // returning the unused commands
        return(parseCommand(remaining))
    }
    
    // function that returns error codes
    func Feedback(_ errorCode: Int) -> String {
        if(errorCode == 0)		{ return "No errors\n\n"}
        else if(errorCode == 1)	{ return "Unknown input error\n\n"}
        else if(errorCode == 2)	{ return "Unknown Query error\n\n"}
        else					{ return "Unknown error\n\n"}
    }
    
    // function that returns the current source pin number
    func getSource() -> Int {
        let sourceNum = source.getPinNum()
        return sourceNum
    }
    
    // setter function for the source when passed a pin
    func setSource(_ inPin: Pin){
		source = inPin
    }
    
    // setter function for the source when passed a pin number
    func setSource(_ pinNum: Int){
		if(pinNum == 0) 		{setSource(pinD0)}
        else if(pinNum == 1) 	{setSource(pinD1)}
        else if(pinNum == 2) 	{setSource(pinD2)}
        else if(pinNum == 3) 	{setSource(pinD3)}
        else if(pinNum == 4) 	{setSource(pinD4)}
        else if(pinNum == 5) 	{setSource(pinD5)}
        else if(pinNum == 6) 	{setSource(pinD6)}
        else if(pinNum == 7) 	{setSource(pinD7)}
        else if(pinNum == 8) 	{setSource(pinD8)}
        else if(pinNum == 9) 	{setSource(pinD9)}
        else if(pinNum == 10) 	{setSource(pinD10)}
        else if(pinNum == 11) 	{setSource(pinD11)}
        else if(pinNum == 12) 	{setSource(pinD12)}
        else if(pinNum == 13) 	{setSource(pinD13)}
        else					{setSource(pinDN)}
    }
}