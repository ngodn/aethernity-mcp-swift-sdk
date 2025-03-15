//
//  AethernityContextServer.swift
//  aethernity-mcp-swift-sdk
//
//  Created by Denny Aprilio on 2025/02/17.
//

import AethernityContextProtocol
import Foundation
import WebSocketActors

public final class AethernityContextServer {

    public struct Options: Codable {
        public var instructions: String
        public init(instructions: String) {
            self.instructions = instructions
        }
    }

    let system: WebSocketActorSystem

    let address: ServerAddress

    let options: Options

    private var tools: [any Tool] = []

    private var resources: [any Resource] = []

    private var prompts: [any Prompt] = []

    public init(
        host: String = "127.0.0.1",
        port: Int = 8888,
        options: Options = Options(instructions: "Welcome to Aethernity Context Server"),
        tools: [any Tool] = [],
        resources: [any Resource] = [],
        prompts: [any Prompt] = []
    ) {
        self.system = WebSocketActorSystem(id: .server)
        self.options = options
        self.address = ServerAddress(
            scheme: .insecure,
            host: host,
            port: port
        )
    }

    public func setTools(_ tools: [any Tool]) {
        self.tools = tools
    }

    public func setResources(_ resources: [any Resource]) {
        self.resources = resources
    }

    public func setPrompts(_ prompts: [any Prompt]) {
        self.prompts = prompts
    }

    public func start() async throws {
        try await system.runServer(at: address)
        _ = system.makeLocalActor(id: .client) {
            AethernityContextActor(
                actorSystem: system,
                tools: tools,
                resources: resources,
                prompts: prompts
            )
        }
        while true {
            try await Task.sleep(for: .seconds(1_000_000))
        }
    }
}

@main
struct Boot {

    static func main() async throws {
        let server = AethernityContextServer()
        server.setTools([
            EchoTool()
        ])
        try await server.start()
    }
}
