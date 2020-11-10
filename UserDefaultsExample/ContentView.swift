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
    private var registeredPresenceCountKey = "timesUserWasPresentInApp"
    
    // Have you been here before?
    @State private var beenHereBefore = false
    private var beenHereBeforeKey = "hasUserBeenHereBefore"
    
    // What's your name?
    @State private var name = ""
    private var nameKey = "username"
    
    // Has presence been registered yet this session?
    @State private var registeredPresenceThisSession = false
    
    var body: some View {
        VStack {
            
            Form {
                Section(header: Text("Details")) {
                    if beenHereBefore {
                        Text("Welcome back, \(name).")
                    } else {
                        Text("Welcome, stranger.")
                        HStack {
                            Text("My name is: ")
                            TextField("Enter your name...", text: $name)
                        }
                    }
                    Text("You have been here \(registeredPresenceCount) times before")
                }
                
                Section(header: Text("Make your mark")) {
                    Button("I was here") {
                        beenHereBefore = true
                        registeredPresenceThisSession.toggle()
                        registeredPresenceCount += 1
                    }
                    .disabled(registeredPresenceThisSession)
                }
                
                
            }
            
        }
        // See: https://www.hackingwithswift.com/books/ios-swiftui/how-to-be-notified-when-your-swiftui-app-moves-to-the-background
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            
            // Make sure the button can be presssed when app is opened again
            print("Moving to the background!")
            registeredPresenceThisSession = false
            
            // Gain access to user defaults
            let defaults = UserDefaults.standard
            
            // Save the number of times the person has been here when app ends
            defaults.set(registeredPresenceCount, forKey: registeredPresenceCountKey)
            
            // Save whether the user has been here at all before (boolean)
            defaults.set(beenHereBefore, forKey: beenHereBeforeKey)
            
            // Save the user's name
            defaults.set(name, forKey: nameKey)
            
        }
        .onAppear() {
            
            // When app is opened, retrieve data from UserDefaults storage
            print("Moving back to the foreground!")
            
            // Gain access to user defaults
            let defaults = UserDefaults.standard
            
            // Get the boolean
            beenHereBefore = defaults.bool(forKey: beenHereBeforeKey)
            
            // Get the count of times the user has been here before
            registeredPresenceCount = defaults.integer(forKey: registeredPresenceCountKey)
            
            // Get the user's name back or set a default value of an empty string
            name = defaults.object(forKey: nameKey) as? String ?? ""
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
