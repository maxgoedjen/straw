import Foundation

class PushController {

    func jsonFormatted(from userInfo: [String: Any]) throws -> String {
        let jsonData = try JSONSerialization.data(withJSONObject: userInfo, options: [])
        return String(data: jsonData, encoding: .utf8) ?? ""
    }

    func writeToDisk(userInfo: [String: Any]) throws -> URL {
        let jsonData = try JSONSerialization.data(withJSONObject: userInfo, options: [])
        guard let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { throw Error.unableToWrite }
        let tempURL = cacheURL.appendingPathComponent("\(UUID().uuidString).apns")
        try jsonData.write(to: tempURL)
        return tempURL
    }

}

extension PushController {

    enum Error: Swift.Error {
        case unableToWrite
    }

}
