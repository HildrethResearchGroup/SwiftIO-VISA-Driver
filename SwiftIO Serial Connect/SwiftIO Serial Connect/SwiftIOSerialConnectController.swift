///
///  SwiftIOSerialConnectController.swift
///
///  SwiftIO Serial Connect Application
///  Documentation: Jazzy
///
///  Created by Mines CS Field Session Student on 6/7/21.
///  Authors: Ethan Vijayabaskaran, Ryan Rumana, Grant Rulon, Mitch Watkins
///

import Foundation
import Cocoa
import ORSSerial

/// Controller class to hold functionality for interaction with the user interface built with a .xib interface builder.
class SwiftIOSerialConnectController: NSObject, ORSSerialPortDelegate {
    
    /// Manages possible serial ports to connect.
    @objc let serialPortManager = ORSSerialPortManager.shared()
    /// Possible baud rates for the user to select.
    @objc let availableBaudRates = [115200]
    /// Serial port instance, which is an ORSSerialPort object, that controlls sending, recieving data with correct paramters.
    @objc dynamic var serialPort: ORSSerialPort? {
        didSet {
            oldValue?.close()
            oldValue?.delegate = nil
            serialPort?.delegate = self
        }
    }
    
    /// Number of bytes that the SwiftIO board is expecting.
    let maxSendLength = 64
    
    // Outlets:
    
    /// Button labeled "Send"
    @IBOutlet weak var sendButton: NSButton!
    /// Text field labeled "Input Value"
    @IBOutlet weak var sendTextField: NSTextField!
    /// Button labeled "Open" or "Close" based on the serial port's status
    @IBOutlet weak var openCloseButton: NSButton!
    /// Bottom text field for receiving data, default empty.
    @IBOutlet var dataReceivedTextView: NSTextView!
    /// Color square adjacent to port path selection, denoting whether serial port is connected
    @IBOutlet weak var colorWell: NSColorWell!
    /// Default empty text field, toggles help text.
    @IBOutlet weak var helpTextField: NSTextField!
    /// Button labeled "?"
    @IBOutlet weak var helpButton: NSButton!
    
    // Actions:
    
    /// Action method called when "?" button is pressed. Toggles on and off the baud rate comment
    /// - Parameter sender: Button being pressed ("?" button)
    @IBAction func helpButtonAction(_ sender: Any) {
        // Detect and change help text visibility
        if helpButton.state == NSControl.StateValue.on {
            helpTextField.stringValue = "SwiftIO BaudRate: 115200"
        }
        else {
            helpTextField.stringValue = ""
        }
    }
    
    /// Action method called when "Send" button is pressed. Prepares and sends data to SwiftIO board
    /// - Parameter sender: Button being pressed ("Send" button)
    @IBAction func sendButtonAction(_ sender: Any) {
        // Extract string out of text field and turn in utf8 encoding
        let string = self.sendTextField.stringValue
        
        // Check if the string is of correct character length
        if string.count > maxSendLength {
            self.dataReceivedTextView.textStorage?.mutableString.append("\n Error: send data length too long, Expected: 64 or less characters")
            self.dataReceivedTextView.needsDisplay = true
            return
        }
        
        // Prepare string using padding with strings
        let paddedString = prepareData(input: string)
        let data = paddedString.data(using: String.Encoding.utf8)
        
        // Send data over serial port
        self.serialPort?.send(data!)
    }
    
    /// Method for padded data to send over serial connection.
    /// - Parameter input: String input from user interface.
    /// - Returns: Padded string used for sending over serial connection.
    func prepareData(input: String) -> String {
        // Set up looping variables
        var data = input
        let length = input.count
        let range = (length+1)...maxSendLength
        
        // loop until 64 characters in length
        for _ in range {
            data += " "
        }
        
        return data
    }
    
    /// Action method called when "Open"/"Close" button. Opens or closes serial port connection depending on port status
    /// - Parameter sender: Button being pressed ("Open/Close" button)
    @IBAction func openCloseButtonAction(_ sender: Any) {
        if let port = self.serialPort {
            // check the status of the port and perform the correct action
            if (port.isOpen) {
                port.close()
            }
            else {
                port.open()
                self.dataReceivedTextView.textStorage?.mutableString.setString("");
            }
        }
    }
    
    /// Action method called when data received "Clear" button is pressed. Clears text field.
    /// - Parameter sender: Button being pressed (lower "Clear" button)
    @IBAction func clearButtonAction(_ sender: Any) {
        self.dataReceivedTextView.string = ""
    }
    
    /// Action method called when data send "Clear" button is pressed. Clears text field.
    /// - Parameter sender: Button being pressed (upper "Clear" button)
    @IBAction func dataSendClearButton(_ sender: Any) {
        self.sendTextField.stringValue = ""
    }
    
    // Serial port delegate functions.
    
    /// Update button text and color well when serial port is opened.
    /// - Parameter serialPort: Serial Port being connected to.
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        colorWell.color = NSColor(red: 0.0, green: 99.0, blue: 0.0, alpha: 1.0)
        self.openCloseButton.title = "Close"
    }
    
    /// Update button text and and color well when serial port is closed.
    /// - Parameter serialPort: Serial port being connected to.
    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        colorWell.color = NSColor(red: 99.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.openCloseButton.title = "Open"
    }
    
    /// Method for receiving data from serial connection and displaying it on the interface.
    /// - Parameters:
    ///   - serialPort: Serial port that is connected to the app.
    ///   - data: Data that is received from serial connection.
    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
        if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            self.dataReceivedTextView.textStorage?.mutableString.append(string as String)
            self.dataReceivedTextView.needsDisplay = true
        }
    }
    
    /// Method for disconnecting the serial port in code and on the interface when the connection is removed from the port manager.
    /// - Parameter serialPort: Serial port being disconnected.
    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        self.serialPort = nil
        self.openCloseButton.title = "Open"
        colorWell.color = NSColor(red: 99.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    
    /// Method for letting the user know when there is an error with the serial port connection
    /// - Parameters:
    ///   - serialPort: Serial port that has the error.
    ///   - error: Error message from error encountered.
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        print("SerialPort \(serialPort) encountered an error: \(error)")
        self.dataReceivedTextView.textStorage?.mutableString.append("SerialPort \(serialPort) encountered an error: \(error)")
        self.dataReceivedTextView.needsDisplay = true
    }
    
}


