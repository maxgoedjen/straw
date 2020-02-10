//
//  ContentView.swift
//  Straw
//
//  Created by Max Goedjen on 2/9/20.
//  Copyright © 2020 Max Goedjen. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var state: StateHolder
    var simulatorController: SimulatorController

    var body: some View {
        Form {
            Picker(selection: $state.targetSimulator, label: Text("Target Simulator")) {
                ForEach(simulatorController.availableSimulators) { simulator in
                    Text(simulator.name).tag(simulator)
                }
            }
            TextField("Push Token", text: $state.pushToken).disabled(true)
            TextField("Last Notification Payload", text: $state.lastNotification).disabled(true)
        }
        .padding()
        .frame(idealWidth: 480, idealHeight: 300)
    }

}

