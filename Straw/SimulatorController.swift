import Foundation

class SimulatorController: ObservableObject {

    var availableSimulators: [Simulator] {
        do {
            let output = try runSimCtlCommand(arguments: ["list"])
            let split = output.split(separator: "\n")
            let booted = split.filter { $0.contains("Booted") }
            let cleaned = booted.map {
                $0
                    .replacingOccurrences(of: "(Booted)", with: "")
                    .trimmingCharacters(in: .whitespaces)

            }
            let mapped = cleaned.compactMap { Simulator(simCtlString: $0) }
            if mapped.isEmpty {
                return [Self.invalidSimulator]
            } else {
                return mapped
            }
        } catch {
            return [Self.invalidSimulator]
        }
    }

    static var invalidSimulator: Simulator {
        Simulator(name: "No Simulators Running", id: UUID())
    }

    func sendAPNS(at url: URL, to simulator: Simulator) throws {
        _ = try runSimCtlCommand(arguments: ["push", simulator.id.uuidString, Bundle.main.bundleIdentifier!, url.path])
    }

}

extension SimulatorController {

    fileprivate func runSimCtlCommand(arguments: [String]) throws -> String {
        let devURL = URL(string: try runCommand(binary: URL(fileURLWithPath: "/usr/bin/xcode-select"), arguments: ["-p"]))
        guard let simCTLURL = devURL?.appendingPathComponent("/usr/bin/simctl") else { throw Error.simCtlCommandFailed }
        return try runCommand(binary: simCTLURL, arguments: arguments)
    }

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

struct Simulator: Identifiable, Hashable {

    var name: String
    var id: UUID

    fileprivate init(name: String, id: UUID) {
        self.name = name
        self.id = id
    }

    fileprivate init?(simCtlString: String) {
        // Simulators (at least as of Xcode 11.4) in the simctl output will have this format:
        // DeviceType: Device Name (UUID)
        guard let idRange = simCtlString.range(of: "[0-9a-fA-F]{8}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{12}", options: .regularExpression) else { return nil }
        guard let nameStart = simCtlString.range(of: ": ") else { return nil }
        guard let id = UUID(uuidString: String(simCtlString[idRange])) else { return nil }
        self.id = id
        name = String(simCtlString[nameStart.upperBound...(simCtlString.index(idRange.lowerBound, offsetBy: -3))])
    }

}

extension SimulatorController {

    enum Error: Swift.Error {
        case simCtlCommandFailed
    }

}
