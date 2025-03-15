//
//  AethernityContextProtocol.swift
//  aethernity-mcp-swift-sdk
//
//  Created by Denny Aprilio on 2025/02/17.
//

import Distributed
import Foundation
import JSONSchema
import WebSocketActors

public struct RequestOptions: Codable, Sendable {
    public var timeout: TimeInterval?
    public init(timeout: TimeInterval? = nil) {
        self.timeout = timeout
    }
}

@Resolvable
public protocol AethernityContextProtocol: DistributedActor
where Self.ActorSystem == WebSocketActorSystem {
    distributed func initialize(
        clientInfo: ClientInfo,
        capabilities: [String: CapabilityConfig],
        options: RequestOptions?
    ) async throws -> InitializeResponse
    distributed func ping(option: RequestOptions?) -> String
    distributed func complete(parameters: Data, options: RequestOptions?) async throws -> String
    distributed func setLoggingLevel(level: LoggingLevel, options: RequestOptions?) async throws
    distributed func getPrompt(parameters: Data, options: RequestOptions?) async throws -> String
    distributed func listPrompts(option: RequestOptions?) -> ListResponse<PromptResponse>
    distributed func listResources(option: RequestOptions?) -> ListResponse<ResourceResponse>
    distributed func readResource(uri: String, options: RequestOptions?) async throws
        -> ResourceContentData
    distributed func subscribeResource(uri: String, options: RequestOptions?) async throws
    distributed func unsubscribeResource(uri: String, options: RequestOptions?) async throws
    distributed func callTool(name: String, parameters: Data, options: RequestOptions?) async throws
        -> String
    distributed func listTools(option: RequestOptions?) -> ListResponse<ToolResponse>
    distributed func sendRootsListChanged(options: RequestOptions?) async throws
}

extension AethernityContextProtocol {

    public distributed func initialize(
        clientInfo: ClientInfo,
        capabilities: [String: CapabilityConfig],
        options: RequestOptions? = nil
    ) async throws -> InitializeResponse {
        try await self.initialize(
            clientInfo: clientInfo, capabilities: capabilities, options: options)
    }

    public distributed func ping(option: RequestOptions? = nil) -> String {
        self.ping(option: option)
    }

    public distributed func complete(parameters: Data, options: RequestOptions? = nil) async throws
        -> String
    {
        try await self.complete(parameters: parameters, options: options)
    }

    public distributed func setLoggingLevel(level: LoggingLevel, options: RequestOptions? = nil)
        async throws
    {
        try await self.setLoggingLevel(level: level, options: options)
    }

    public distributed func getPrompt(parameters: Data, options: RequestOptions? = nil) async throws
        -> String
    {
        try await self.getPrompt(parameters: parameters, options: options)
    }

    public distributed func listPrompts(option: RequestOptions? = nil) -> ListResponse<
        PromptResponse
    > {
        self.listPrompts(option: option)
    }

    public distributed func listResources(option: RequestOptions? = nil) -> ListResponse<
        ResourceResponse
    > {
        self.listResources(option: option)
    }

    public distributed func readResource(uri: String, options: RequestOptions? = nil) async throws
        -> ResourceContentData
    {
        try await self.readResource(uri: uri, options: options)
    }

    public distributed func subscribeResource(uri: String, options: RequestOptions? = nil)
        async throws
    {
        try await self.subscribeResource(uri: uri, options: options)
    }

    public distributed func unsubscribeResource(uri: String, options: RequestOptions? = nil)
        async throws
    {
        try await self.unsubscribeResource(uri: uri, options: options)
    }

    public distributed func callTool(name: String, parameters: Data, options: RequestOptions? = nil)
        async throws -> String
    {
        try await self.callTool(name: name, parameters: parameters, options: options)
    }

    public distributed func listTools(option: RequestOptions? = nil) -> ListResponse<ToolResponse> {
        self.listTools(option: option)
    }

    public distributed func sendRootsListChanged(options: RequestOptions? = nil) async throws {
        try await self.sendRootsListChanged(options: options)
    }
}

extension NodeIdentity {
    public static let server = NodeIdentity(id: "server")
}

extension ActorIdentity {
    public static let client = ActorIdentity(id: "client", node: .server)
}
