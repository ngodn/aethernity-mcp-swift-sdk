//
//  CapabilityConfig.swift
//  aethernity-mcp-swift-sdk
//
//  Created by Denny Aprilio on 2025/02/17.
//

public struct CapabilityConfig: Codable, Sendable {
    public let settings: [String: String]
    public init(settings: [String: String]) {
        self.settings = settings
    }
}
