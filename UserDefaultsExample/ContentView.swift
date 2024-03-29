//
//  ContentView.swift
//  UserDefaultsExample
//
//  Created by Russell Gordon on 2020-11-10.
//

import SwiftUI

struct ContentView: View {
    
    // App icon
    // File by ibrandify from the Noun Project
    
    // MARK: Stored properties
    
    // Be able to detect when app is backgrounded
    @Environment(\.scenePhase) var scenePhase
    
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
    @State private var userHasRegisteredPresenceThisSession = false
    
    // MARK: Computed properties
    var pluralization: String {
        // Return an "s" whenever the count is something other than 1
        return registeredPresenceCount == 1 ? "" : "s"
    }

    var body: some View {
        
        HStack {

            VStack(alignment: .leading, spacing: 10) {
                
                if beenHereBefore {
                    Text("Welcome, \(name).")
                        .font(.title)
                } else {
                    Text("Welcome, stranger.")
                        .font(.title)
                    Text("What is your name? ")
                    TextField("Enter your name...", text: $name)
                }
                
                Text("You have been here \(registeredPresenceCount) time\(pluralization) before.")
                    .padding(.vertical)
                
                Button("Record your presence") {
                    recordThatUserWasHere()
                }
                .buttonStyle(.bordered)
                // Only let button be pressed once per run of the app
                .disabled(userHasRegisteredPresenceThisSession)
                // Only let button be pressed when user has entered a name
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                
                Spacer()
                
            }

            Spacer()
            
        }
        .padding()
        // See: https://www.hackingwithswift.com/books/ios-swiftui/how-to-be-notified-when-your-swiftui-app-moves-to-the-background
        .onChange(of: scenePhase) { newPhase in
            
            if newPhase == .active {
                
                print("Active")

                restoreState()
                
            } else if newPhase == .inactive {
                
                print("Inactive")
                
            } else if newPhase == .background {
                
                print("Background")
                
                // Make sure the button can be presssed when app is opened again
                userHasRegisteredPresenceThisSession = false
                
                saveState()
                
            }
        }
    }
    
    // MARK: Functions
    func restoreState() {
        
        // Gain access to user defaults
        let defaults = UserDefaults.standard
        
        // Get the boolean
        beenHereBefore = defaults.bool(forKey: beenHereBeforeKey)
        
        // Get the count of times the user has been here before
        registeredPresenceCount = defaults.integer(forKey: registeredPresenceCountKey)
        
        // Get the user's name back or set a default value of an empty string
        name = defaults.object(forKey: nameKey) as? String ?? ""

    }
    
    func saveState() {
        
        // Gain access to user defaults
        let defaults = UserDefaults.standard
        
        // Save the number of times the person has been here when app ends
        defaults.set(registeredPresenceCount, forKey: registeredPresenceCountKey)
        
        // Save whether the user has been here at all before (boolean)
        defaults.set(beenHereBefore, forKey: beenHereBeforeKey)
        
        // Save the user's name
        defaults.set(name, forKey: nameKey)

    }
    
    func recordThatUserWasHere() {
        beenHereBefore = true
        userHasRegisteredPresenceThisSession.toggle()
        registeredPresenceCount += 1
        saveState()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
