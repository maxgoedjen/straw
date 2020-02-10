import Foundation

class SimulatorController {

    var availableSimulators: [Simulator] {
        do {
            let output = try runSimCtlCommand(command: "list")
            let split = output.split(separator: "\n")
            let booted = split.filter { $0.contains("Booted") }
            let cleaned = booted.map {
                $0
                    .replacingOccurrences(of: "(Booted)", with: "")
                    .trimmingCharacters(in: .whitespaces)

            }
            return cleaned.compactMap { Simulator(simCtlString: $0) }
        } catch {
            return []
        }
    }

    func sendAPNS(at url: URL, to simulator: Simulator) throws {
        _ = try runSimCtlCommand(splitCommand: ["push", simulator.id, Bundle.main.bundleIdentifier!, url.path])
    }

}

extension SimulatorController {

    fileprivate func runSimCtlCommand(command: String) throws -> String {
        return try runSimCtlCommand(splitCommand: command.split(separator: " ").map { String($0) })
    }

    fileprivate func runSimCtlCommand(splitCommand: [String]) throws -> String {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/Applications/Xcode.app/Contents/Developer/usr/bin/simctl")
        task.arguments = splitCommand
        let output = Pipe()
        task.standardOutput = output
        try task.run()
        let outputData = output.fileHandleForReading.readDataToEndOfFile()
        return String(data: outputData, encoding: .utf8) ?? ""
    }

}

struct Simulator: Identifiable {

    var name: String
    var id: String

    fileprivate init?(simCtlString: String) {
        // Simulators (at least as of Xcode 11.4) in the simctl output will have this format:
        // DeviceType: Device Name (UUID)
        guard let idRange = simCtlString.range(of: "[0-9a-fA-F]{8}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{4}\\-[0-9a-fA-F]{12}", options: .regularExpression) else { return nil }
        guard let nameStart = simCtlString.range(of: ": ") else { return nil }
        id = String(simCtlString[idRange])
        name = String(simCtlString[nameStart.upperBound...(simCtlString.index(idRange.lowerBound, offsetBy: -3))])
    }

}

extension SimulatorController {

    enum Error: Swift.Error {
        case simCtlCommandFailed
    }

}
