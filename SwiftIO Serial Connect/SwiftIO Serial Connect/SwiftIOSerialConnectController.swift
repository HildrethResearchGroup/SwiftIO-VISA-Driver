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
    
    
    // Outlets:
    @IBOutlet weak var sendButton: NSButton!
    @IBOutlet weak var sendTextField: NSTextField!
    @IBOutlet weak var openCloseButton: NSButton!
    @IBOutlet var dataReceivedTextView: NSTextView!
    
    
    // Actions:
    
    // Function called when "Send" button is pressed
    @IBAction func sendButtonAction(_ sender: Any) {
        // Extract string out of text field and turn in utf8 encoding
        let string = self.sendTextField.stringValue
        let data = string.data(using: String.Encoding.utf8)
        
        // Send data over serial port
        self.serialPort?.send(data!)
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
    
    
    
    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        
    }
    
    
    
}


