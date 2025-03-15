//
//  Client.swift
//  aethernity-mcp-swift-sdk
//
//  Created by Denny Aprilio on 2025/02/17.
//

import AethernityContextProtocol
import Distributed
import Foundation
import WebSocketActors

@main
struct Boot {

    static func main() async throws {

        do {
            let server = try await AethernityContextClient.connectServer()
            let data = Envelop(data: "Hello, World!")
            let parameters = try JSONEncoder().encode(data)
            let toolResponse = try await server.session.callTool(
                name: "echo",
                parameters: parameters
            )
            print(toolResponse)  // "Hello, World!"
        } catch {
            print("Error: \(error)")
        }
    }
}

public final class AethernityContextClient: @unchecked Sendable {

    let address: ServerAddress

    var session: (any AethernityContextProtocol)!

    public init(host: String = "127.0.0.1", port: Int = 8888) throws {
        self.address = ServerAddress(
            scheme: .insecure,
            host: host,
            port: port
        )
    }

    public func connect() async throws {
        let system = WebSocketActorSystem()
        try await system.connectClient(to: address)
        self.session = try $AethernityContextProtocol.resolve(id: .client, using: system)

        let clientInfo = ClientInfo(name: "Aethernity Context Client", version: "1.0")
        let capabilities: [String: CapabilityConfig] = [:]
        let initResponse = try await session.initialize(
            clientInfo: clientInfo,
            capabilities: capabilities)
        print(
            """
            ══════════════════════════════════════════════════

             ✨ Server Connected ✨ 
             Server: \(initResponse.serverInfo.name) [\(initResponse.serverInfo.version)]     
             Instructions: \(initResponse.instructions ?? "None")  

            ══════════════════════════════════════════════════
            """)
    }

    public static func connectServer(host: String = "127.0.0.1", port: Int = 8888) async throws
        -> AethernityContextClient
    {
        let client = try AethernityContextClient(host: host, port: port)
        try await client.connect()
        return client
    }
}
