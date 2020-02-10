import Foundation

class SimulatorController: ObservableObject {

    var availableSimulators: [Simulator] {
        do {
            let devPath = try runCommand(binary: URL(fileURLWithPath: "/usr/bin/xcode-select"), arguments: ["-p"])
            let context = SimServiceContext.sharedServiceContext(forDeveloperDir: devPath, error: nil)
            let devices = context.defaultDeviceSetWithError(nil).devices
            return devices
                .filter { $0.state == .booted }
                .map { Simulator(simDevice: $0) }
        } catch {
            return [Self.invalidSimulator]
        }
    }

    static var invalidSimulator: Simulator {
        Simulator(id: UUID(), name: "No Simulators Running", os: "0.0.0")
    }

    func sendAPNS(payload: [AnyHashable : Any], to simulator: Simulator) throws {
        _ = try simulator.simDevice?.sendPushNotification(forBundleID: Bundle.main.bundleIdentifier!, jsonPayload: payload)
    }

}

extension SimulatorController {

    fileprivate func runCommand(binary: URL, arguments: [String]) throws -> String {
        let task = Process()
        task.executableURL = binary
        task.arguments = arguments
        let output = Pipe()
        task.standardOutput = output
        task.standardError = nil
        try task.run()
        let outputData = output.fileHandleForReading.readDataToEndOfFile()
        return String(data: outputData, encoding: .utf8) ?? ""
    }

}

struct Simulator: Identifiable, Hashable, CustomStringConvertible {

    let id: UUID
    let name: String
    let os: String
    fileprivate let simDevice: SimDevice?

    internal init(id: UUID, name: String, os: String) {
        self.id = id
        self.name = name
        self.os = os
        self.simDevice = nil
    }

    init(simDevice: SimDevice) {
        self.id = simDevice.udid
        self.name = simDevice.name
        self.os = simDevice.runtime.versionString
        self.simDevice = simDevice
    }

    var description: String {
        return "\(name) (\(os))"
    }
}

extension SimulatorController {

    enum Error: Swift.Error {
        case simCtlCommandFailed
    }

}
