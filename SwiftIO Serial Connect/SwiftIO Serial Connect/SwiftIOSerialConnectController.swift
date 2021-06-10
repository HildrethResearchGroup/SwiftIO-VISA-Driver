//
//  SwiftIOSerialConnectController.swift
//  SwiftIO Serial Connect
//
//  Created by Mines CS Field Session Student on 6/7/21.
//

import Foundation

import Cocoa
import ORSSerial

class SwiftIOSerialConnectController: NSObject, ORSSerialPortDelegate, NSUserNotificationCenterDelegate {
    
    
    @objc let serialPortManager = ORSSerialPortManager.shared()
    @objc let availableBaudRates = [115200]
    
    @objc dynamic var serialPort: ORSSerialPort? {
        didSet {
            oldValue?.close()
            oldValue?.delegate = nil
            serialPort?.delegate = self
        }
    }
    
    let maxSendLength = 64
    
    
    // Outlets:
    @IBOutlet weak var sendButton: NSButton!
    @IBOutlet weak var sendTextField: NSTextField!
    @IBOutlet weak var openCloseButton: NSButton!
    @IBOutlet var dataReceivedTextView: NSTextView!
    @IBOutlet weak var colorWell: NSColorWell!
    @IBOutlet weak var helpTextField: NSTextField!
    @IBOutlet weak var helpButton: NSButton!
    // Actions:
    
    
    @IBAction func helpButtonAction(_ sender: Any) {
        if helpButton.state == NSControl.StateValue.on {
            helpTextField.stringValue = "SwiftIO BaudRate: 115200"
        }
        else {
            helpTextField.stringValue = ""
        }
        
        
    }
    
    // Function called when "Send" button is pressed
    @IBAction func sendButtonAction(_ sender: Any) {
        // Extract string out of text field and turn in utf8 encoding
        let string = self.sendTextField.stringValue
        
        // Check if the string is of correct character length
        if string.count > maxSendLength {
            self.dataReceivedTextView.textStorage?.mutableString.append("\n Error: send data length too long, Expected: 64 or less characters")
            self.dataReceivedTextView.needsDisplay = true
            return
        }
        
        
        let paddedString = prepareData(input: string)
        
        let data = paddedString.data(using: String.Encoding.utf8)
        
        // Send data over serial port
        self.serialPort?.send(data!)
    }
    
    // Pad the data to expected 64 character
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
    
    // Function called when "Open"/"Close" button is pressed
    @IBAction func openCloseButtonAction(_ sender: Any) {
        if let port = self.serialPort {
            if (port.isOpen) {
                port.close()
                
                
            } else {
                port.open()
                
                self.dataReceivedTextView.textStorage?.mutableString.setString("");
            }
        }
    }
    
    // Function called when "Clear" button is pressed
    @IBAction func clearButtonAction(_ sender: Any) {
        self.dataReceivedTextView.string = ""
    }
    
    @IBAction func dataSendClearButton(_ sender: Any) {
        sendTextField.stringValue = ""
    }
    
    
    
    // Serial Port Delegate functions for gaining recieved data
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        colorWell.color = NSColor(red: 0.0, green: 99.0, blue: 0.0, alpha: 1.0)
        self.openCloseButton.title = "Close"
    }
    
    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        colorWell.color = NSColor(red: 99.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.openCloseButton.title = "Open"
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
        if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            self.dataReceivedTextView.textStorage?.mutableString.append(string as String)
            self.dataReceivedTextView.needsDisplay = true
        }
    }
    
    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        self.serialPort = nil
        self.openCloseButton.title = "Open"
        colorWell.color = NSColor(red: 99.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        print("SerialPort \(serialPort) encountered an error: \(error)")
    }
    
    
}


