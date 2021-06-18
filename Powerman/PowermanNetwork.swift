//
//  PowermanNetwork.swift
//  Powerman
//
//  Created by Dmitriy Borovikov on 15.06.2021.
//

import Foundation
import Alamofire

class PowermanNetwork {
    let ipAddress: String
    let password: String

    init?() {
        guard let ipAddress = Preference.ipAddress, !ipAddress.isEmpty else { return nil }
        guard let password = Preference.password, !password.isEmpty else { return nil }
        self.ipAddress = ipAddress
        self.password = password
    }

    func parseStatus(_ reply: String) -> [(String, Bool)] {
        var result: [(String, Bool)] = []
        let states = reply[reply.range(of: "var ctl = [")!.upperBound...].prefix { $0 != "]" }.split(separator: ",").map { $0 == "1" }
        let namesRaw = reply[reply.range(of: "var sock_names = [")!.upperBound...].prefix { $0 != "]" }.split(separator: ",")
        let names = namesRaw.map { s in
            s.dropFirst().prefix { $0 != "\"" }
        }
        for i in names.indices {
            result.append((String(names[i]), states[i]))
        }
        return result
    }

    public func readState(_ completion: @escaping ([(String, Bool)]) -> Void) {
        let authURL = URL(string: "http://\(ipAddress)/login.html")!
        let statusURL = URL(string: "http://\(ipAddress)/status.html")!
        let paramers: [String: String] = ["pw": password]

        AF.request(authURL, method: .post, parameters: paramers).responseString { _ in
            AF.request(statusURL).responseString { reply in
                if let value = reply.value {
                    completion(self.parseStatus(value))
                }
            }
        }
    }

    public func setState(for socket: Int, state: Bool) {
        let authURL = URL(string: "http://\(ipAddress)/login.html")!
        let postURL = URL(string: "http://\(ipAddress)")!
        let paramers: [String: String] = ["pw": password]
        let swParameters: [String: String] = ["cte\(socket)": state ? "1":"0"]

        AF.request(authURL, method: .post, parameters: paramers).response { _ in
            AF.request(postURL, method: .post, parameters: swParameters).responseString { reply in
            }
        }
    }
}
