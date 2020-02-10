//
//  ContentView.swift
//  Straw
//
//  Created by Max Goedjen on 2/9/20.
//  Copyright © 2020 Max Goedjen. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State var text: String? = nil

    var body: some View {
        Group {
            if text == nil {
                Text("Waiting for notifications...")
            } else {
                Text("Piped \"\(text!)\"")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
