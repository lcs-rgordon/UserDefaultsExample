//
//  ContentView.swift
//  UserDefaultsExample
//
//  Created by Russell Gordon on 2020-11-10.
//

import SwiftUI

struct ContentView: View {
    
    // How many times have you been here?
    @State private var registeredPresenceCount = 0
    
    // Have you been here before?
    @State private var beenHereBefore = false
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Details")) {
                    if beenHereBefore {
                        Text("You've been here before")
                    } else {
                        Text("Welcome, stranger.")
                    }
                    Text("You have been here \(registeredPresenceCount) times before")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
