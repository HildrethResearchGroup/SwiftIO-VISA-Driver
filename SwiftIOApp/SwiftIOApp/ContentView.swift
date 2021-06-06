//
//  ContentView.swift
//  SwiftIOApp
//
//  Created by Mines CS Field Session Student on 5/21/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var pinNum: String = ""
    @State private var voltage: String = ""
    @State private var display: String = ""
    @State private var isEditing = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Enter pin number and voltage.")
                .font(.title)
            TextField("Pin number", text: $pinNum) {
                isEditing in
                self.isEditing = isEditing
            } onCommit: {
                self.pinNum = pinNum;
            }
            TextField("Voltage", text: $voltage) {
                isEditing in
                self.isEditing = isEditing
            } onCommit: {
                self.voltage = voltage;
            }
            Button(action: {
                
                // This is where the serial is called.
                
                print(pinNum + " " + voltage);
            }, label: {
                HStack {
                    Image(systemName: "pencil")
                    Text("Submit")
                }
            })
            Spacer().frame(height: 10)
            Divider()
            Spacer().frame(height: 10)
            Text("Enter text for the display.")
                .font(.title)
            TextField("Enter text here...", text: $display) {
                isEditing in
                self.isEditing = isEditing
            } onCommit: {
                self.display = display;
            }
            Button(action: {
                
                // This is where the serial is called.
                
                print("Yo");
                print(pinNum + " " + voltage);
            }, label: {
                HStack {
                    Image(systemName: "pencil")
                    Text("Submit")
                }
            })
        }.padding()
        
        
        
    }
    
    func command(pinNum: Int, voltage: Float) {
        // insert command to send voltage to pin
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.sizeThatFits)
            
    }
}
