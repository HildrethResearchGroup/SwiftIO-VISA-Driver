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
    @State private var isEditing = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Testing Text").font(.title)
            Text("Below the text").font(.title2)
            HStack {
                Text("Test hstack").font(.subheadline)
                Text("We out here").font(.subheadline)
            }
        }.padding()
        
        VStack(alignment: .leading) {
            TextField("Pin number", text: $pinNum) {
                isEditing in
                self.isEditing = isEditing
            } onCommit: {
                self.pinNum = pinNum
            }
            TextField("Voltage", text: $voltage) {
                isEditing in
                self.isEditing = isEditing
            } onCommit: {
                self.voltage = voltage
            }
            Button(action: {
                print(pinNum + " " + voltage)
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
