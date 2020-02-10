import SwiftUI

class StateHolder: ObservableObject {

    @Published var targetSimulator: Simulator
    @Published var pushToken: String = "Not Registered"
    @Published var lastNotification: String = "None"

    init(targetSimulator: Simulator) {
        self.targetSimulator = targetSimulator
    }

}
