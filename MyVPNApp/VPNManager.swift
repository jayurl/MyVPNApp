//
//  VPNManager.swift
//  MyVPNApp
//
//  Created by Jay on 8/21/24.
//

import Foundation
import NetworkExtension

class VPNManager {
    static let shared = VPNManager()
    private var vpnManager: NEVPNManager

    private init() {
        vpnManager = NEVPNManager.shared()
    }

    func configureVPN(username: String, password: String, serverAddress: String) {
        let vpnProtocol = NEVPNProtocolIKEv2()

        vpnProtocol.username = username
        vpnProtocol.serverAddress = serverAddress
        vpnProtocol.remoteIdentifier = serverAddress
        vpnProtocol.localIdentifier = "MyVPNClient"
        vpnProtocol.useExtendedAuthentication = true
        vpnProtocol.passwordReference = self.getPasswordReference(password: password)
        vpnProtocol.authenticationMethod = .none

        vpnManager.protocolConfiguration = vpnProtocol
        vpnManager.isEnabled = true

        vpnManager.saveToPreferences { error in
            if let error = error {
                print("Error saving VPN preferences: \(error.localizedDescription)")
            } else {
                print("VPN preferences saved successfully")
            }
        }
    }

    func connectVPN() {
        do {
            try vpnManager.connection.startVPNTunnel()
        } catch {
            print("Error starting VPN tunnel: \(error.localizedDescription)")
        }
    }

    func disconnectVPN() {
        vpnManager.connection.stopVPNTunnel()
    }

    private func getPasswordReference(password: String) -> Data {
        let passwordData = password.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "VPN",
            kSecValueData as String: passwordData
        ]

        SecItemAdd(query as CFDictionary, nil)
        return passwordData
    }
}

