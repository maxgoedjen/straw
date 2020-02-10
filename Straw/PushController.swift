import Foundation

class PushController {

    func received(userInfo: [String: Any]) throws {
        let url = try writeToDisk(userInfo: userInfo)
        try sendToSimulator(url: url)
    }
    
}

extension PushController {

    func writeToDisk(userInfo: [String: Any]) throws -> URL {
        let jsonData = try JSONSerialization.data(withJSONObject: userInfo, options: [])
        guard let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { throw Error.unableToWrite }
        let tempURL = cacheURL.appendingPathComponent("\(UUID().uuidString).apns")
        try jsonData.write(to: tempURL)
        return tempURL
    }

    func sendToSimulator(url: URL) throws {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/Applications/Xcode.app/Contents/Developer/usr/bin/simctl")
        task.arguments = ["push", "194D3E97-411D-4D90-9500-DA30B8396DFA", "com.maxgoedjen.straw", url.path]
        try task.run()
    }

}

extension PushController {

    enum Error: Swift.Error {
        case unableToWrite
    }

}
