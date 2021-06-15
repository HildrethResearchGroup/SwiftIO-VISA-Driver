import SwiftIO

// this is a .contains method
extension String{
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
    
    func components(withMaxLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }
}

class SCPI {
    
    // variables representing the Analog pins
    let pinA0 = Pin("AnalogIn", 0)
    let pinA1 = Pin("AnalogIn", 1)
    let pinA2 = Pin("AnalogIn", 2)
    let pinA3 = Pin("AnalogIn", 3)
    let pinA4 = Pin("AnalogIn", 4)
    let pinA5 = Pin("AnalogIn", 5)
    
    // variables representing the Digital pins
    let pinDN  = Pin(-1)	// NULL pin
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
    
    // init function
    init(){
        source = pinDN
    }
    
    func trimCommand(_ inStr: String) -> String {
        // Trimming the string to size
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
    
    func parseCommand(_ input: String) -> String {
        // example string we need to parse : [SOURce(#)]APPLy:SIN 1e4,1,0.1
        
        // initializing the error code
        var errorCode: Int = 0

        // Parsing the string by commands
        if(input.isEmpty || input == "" || input == " "){
			errorCode = 0
        } else if(input.hasPrefix(":")){
            var output = input
            output.removeFirst(1)
            return(parseCommand(output))
        } else if(input.contains("?")){
            return(Query(input))
        } else if(input.hasPrefix("SOURce(")){
            return(parseSource(input, 7, false))
        } else if(input.hasPrefix("SOUR(")){ 
            return(parseSource(input, 5, false))
        } else if(input.hasPrefix("[SOURce(")){
            return(parseSource(input, 8, true))
        } else if(input.hasPrefix("[SOUR(")){ 
            return(parseSource(input, 6, true))
        } else if(input.hasPrefix("DISPlay")){
            return(doDSP(input, 8))
        } else if(input.hasPrefix("DISP")){
            return(doDSP(input, 5))
        } else if(input.hasPrefix("VOLTage")){
            return(voltage(input, 7))
        } else if(input.hasPrefix("VOLT")){
            return(voltage(input, 4))
        } else if(input.hasPrefix("PWM")){
            return(PWM(input, 3))
        } else {
			errorCode = 1
        }
        
        // returning the feedback in the form or error codes
        return Feedback(errorCode)
    }
    
    func parseSource(_ input: String, _ length: Int, _ Bracket: Bool) -> String{
		var next = input
        next.removeFirst(length)
        let closeParenthesis = next.firstIndex(of: ")") ?? next.endIndex
		let pinNumStr = next[..<closeParenthesis]
        let pinNum = Int(pinNumStr) ?? -1
        setSource(pinNum)
        var last = input
        var closeBracket: String.Index
        if(Bracket){ closeBracket = input.firstIndex(of: "]") ?? next.endIndex }
        else{ closeBracket = input.firstIndex(of: ")") ?? next.endIndex }
        last.remove(at: closeBracket)
        let out = last[closeBracket...]
        uart.write("Assigned SOURce to Pin \(pinNum)\n")
        return(parseCommand(String(out)))
    }
    
    func voltage(_ input: String, _ length: Int) -> String{
		var middle = input
        middle.removeFirst(length)
        let endNum = middle.firstIndex(of: ":") ?? middle.endIndex
        let pinVoltStr = middle[..<endNum]
        let Voltage = Float(pinVoltStr) ?? -1
        uart.write("Setting source pin to \(Voltage) volts\n")
        uart.write("SwiftIO board is not currently capable of Analog output\n")
        if(middle.contains(":")){
			var remaining = String(middle[endNum...])
            remaining.removeFirst() 
            return(parseCommand(String(remaining)))
        } else {
			return(parseCommand(""))
        }
    }
    
    func PWM(_ input: String, _ length: Int) -> String {
		var middle = input
        middle.removeFirst(length)
        let endNum = middle.firstIndex(of: ":") ?? middle.endIndex
        let pinPercentStr = middle[..<endNum]
        let Percent = Float(pinPercentStr) ?? -1
        source.setDutyCycle(Percent)
        if(middle.contains(":")){
			var remaining = String(middle[endNum...])
            remaining.removeFirst() 
            return(parseCommand(String(remaining)))
        } else {
			return(parseCommand(""))
        }
    }
    
    func Query(_ input: String) -> String {
		if(input.contains("SOURce?") || input.contains("SOUR?")){ 
            return("Current source is \(getSource())\n\n")
        } else if(input.contains("SOURce.VOLT?") || input.contains("SOURce.VOLTage?") || 
                  input.contains("SOUR.VOLT?") || input.contains("SOUR.VOLTage?")){
            source.getPinVolt()
            return(parseCommand(""))
        } else if(input.contains("SOURce.PWM?") || input.contains("SOUR.PWM?")){
            source.getPinDutyCycle()
            return(parseCommand(""))
        } else {
            return Feedback(2)
        }
    }
    
    func doDSP(_ input: String, _ length: Int) -> String {
        // clear the screen and prepare vars
        lcd.clear()
        var middle = input
        middle.removeFirst(length)
        let closeParenthesis = middle.firstIndex(of: ")") ?? middle.endIndex
    	var remaining = String(middle[closeParenthesis...])
        remaining.removeFirst()
        let output = middle[..<closeParenthesis]
        
        if(output.count <= 16) {
            lcd.write(x: 0, y: 0, String(output))
        }
        else if(output.count > 16 && output.count <= 40){
            lcd.write(x: 0, y: 0, String(output))
            for _ in 16...output.count-1 {
                sleep(ms: 1000)
                lcd.scrollLeft()
            }
        } else {
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
        uart.write("Printed to screen\n")
        return(parseCommand(remaining))
    }
    
    func Feedback(_ errorCode: Int) -> String {
        if(errorCode == 0)		{ return "No errors\n\n"}
        else if(errorCode == 1)	{ return "Unknown input error\n\n"}
        else if(errorCode == 2)	{ return "Unknown Query error\n\n"}
        else					{ return "Unknown error\n\n"}
    }
    
    func getSource() -> Int {
        let sourceNum = source.getPinNum()
        return sourceNum
    }
    
    func setSource(_ inPin: Pin){
		source = inPin
    }
    
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