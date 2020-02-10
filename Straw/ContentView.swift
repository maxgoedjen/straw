//
//  ContentView.swift
//  Straw
//
//  Created by Max Goedjen on 2/9/20.
//  Copyright © 2020 Max Goedjen. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var simulatorController: SimulatorController
    @State var selectedSimulator: Simulator?

    var body: some View {
        Form {
            Picker(selection: $selectedSimulator, label: Text("Target Simulator")) {
                ForEach(simulatorController.availableSimulators) { simulator in
                    Text("\(simulator.name)")
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(simulatorController: SimulatorController())
    }
}
