//
//  Greeter.swift
//  aethernity-mcp-swift-sdk
//
//  Created by Denny Aprilio on 2025/02/17.
//

import AethernityContextProtocol
import Distributed
import Foundation
import JSONSchema
import WebSocketActors

/// A simple tool that echoes the provided input.
public struct EchoTool: Tool {

    public typealias Input = Envelop<String>

    public typealias Output = String

    public var name: String = "echo"

    public var description: String = "A tool that echoes the provided input."

    // Here we define the JSON schema for the input.
    // In this example, we expect a string.
    public var inputSchema: JSONSchema? = .string()

    // Optional guide with detailed instructions on how to use this tool.
    public var guide: String? = """
        # Tool Name
        EchoTool

        ## Description
        This tool echoes back the input string provided to it.

        ## Parameters
        - `input`: The string to be echoed.
          - **Type**: `String`
          - **Description**: The input text that will be returned as output.
          - **Requirements**: Must be a valid, non-null string.

        ## Usage
        - Provide a valid string as input.
        - The tool will return the same string as output.

        ## Examples
        ### Basic Usage
        ```swift
        let input = "Hello, world!"
        // EchoTool will output: "Hello, world!"
        ```
        """

    /// Executes the echo operation by returning the input as the output.
    /// - Parameter input: The string to echo.
    /// - Returns: The same input string.
    public func run(_ input: Envelop<String>) async throws -> String {
        return input.data
    }
}

public distributed actor AethernityContextActor {

    public typealias ActorSystem = WebSocketActorSystem

    private var tools: [String: any Tool] = [:]

    private var resources: [String: any Resource] = [:]

    private var prompts: [String: any Prompt] = [:]

    public init(
        actorSystem: ActorSystem, tools: [any Tool] = [], resources: [any Resource] = [],
        prompts: [any Prompt] = []
    ) {
        self.actorSystem = actorSystem
        self.tools = tools.reduce(into: [:]) { $0[$1.name] = $1 }
        self.resources = resources.reduce(into: [:]) { $0[$1.name] = $1 }
        self.prompts = prompts.reduce(into: [:]) { $0[$1.name] = $1 }
    }

    // MARK: - Registration

    /// Registers a Tool. Throws an error if a Tool with the same name is already registered.
    public func register(tool: any Tool) {
        guard tools[tool.name] == nil else {
            fatalError("Tool '\(tool.name)' is already registered")
        }
        tools[tool.name] = tool
    }

    /// Registers a Resource. Throws an error if a Resource with the same name is already registered.
    public func register(resource: any Resource) {
        guard resources[resource.name] == nil else {
            fatalError("Resource '\(resource.name)' is already registered")
        }
        resources[resource.name] = resource
    }

    /// Registers a Prompt. Throws an error if a Prompt with the same name is already registered.
    public func register(prompt: any Prompt) {
        guard prompts[prompt.name] == nil else {
            fatalError("Prompt '\(prompt.name)' is already registered")
        }
        prompts[prompt.name] = prompt
    }

    // MARK: - Retrieval

    /// Retrieves a registered Tool by name.
    public func tool(named name: String) -> (any Tool)? {
        return tools[name]
    }

    /// Retrieves a registered Resource by name.
    public func resource(named name: String) -> (any Resource)? {
        return resources[name]
    }

    /// Retrieves a registered Prompt by name.
    public func prompt(named name: String) -> (any Prompt)? {
        return prompts[name]
    }

    // MARK: - Listing

    /// Returns an array of all registered Tools.
    public var allTools: [any Tool] {
        return Array(tools.values)
    }

    /// Returns an array of all registered Resources.
    public var allResources: [any Resource] {
        return Array(resources.values)
    }

    /// Returns an array of all registered Prompts.
    public var allPrompts: [any Prompt] {
        return Array(prompts.values)
    }
}

extension AethernityContextActor: AethernityContextProtocol {

    public distributed func initialize(
        clientInfo: ClientInfo,
        capabilities: [String: CapabilityConfig],
        options: RequestOptions?
    ) async throws -> InitializeResponse {
        // Example: Return server information and capabilities as fixed values
        let serverInfo = ServerInfo(name: "AethernityContextActor", version: "1.0")
        let serverCapabilities: [String: CapabilityConfig] = [
            "tools": CapabilityConfig(settings: ["call": "true", "list": "true"]),
            "resources": CapabilityConfig(settings: ["read": "true", "subscribe": "true"]),
            "prompts": CapabilityConfig(settings: ["execute": "true", "list": "true"]),
        ]
        let instructions = "This is a distributed context actor providing MCP services."
        return InitializeResponse(
            protocolVersion: "1.0",
            serverInfo: serverInfo,
            capabilities: serverCapabilities,
            instructions: instructions)
    }

    public distributed func ping(option: RequestOptions?) -> String {
        return "pong"
    }

    public distributed func complete(parameters: Data, options: RequestOptions?) async throws
        -> String
    {
        if let input = String(data: parameters, encoding: .utf8) {
            return "completed: \(input)"
        }
        return "completed"
    }

    public distributed func setLoggingLevel(level: LoggingLevel, options: RequestOptions?)
        async throws
    {
        print("Logging level set to \(level.rawValue)")
    }

    public distributed func getPrompt(parameters: Data, options: RequestOptions?) async throws
        -> String
    {
        if let input = String(data: parameters, encoding: .utf8) {
            return "Prompt for \(input)"
        }
        return "Default prompt"
    }

    public distributed func listPrompts(option: RequestOptions?) -> ListResponse<PromptResponse> {
        let promptsArray = self.prompts.map { (_, prompt) in
            PromptResponse(
                name: prompt.name,
                description: prompt.description,
                parameters: nil,
                guide: nil)
        }
        return ListResponse(results: Array(promptsArray))
    }

    public distributed func listResources(option: RequestOptions?) -> ListResponse<ResourceResponse>
    {
        let resourcesArray = self.resources.map { (_, resource) in
            ResourceResponse(
                uri: resource.uri.absoluteString,
                name: resource.name,
                description: resource.description,
                mimeType: resource.mimeType)
        }
        return ListResponse(results: Array(resourcesArray))
    }

    public distributed func readResource(uri: String, options: RequestOptions?) async throws
        -> ResourceContentData
    {
        guard
            let resource = self.resources.first(where: { $0.value.uri.absoluteString == uri })?
                .value
        else {
            throw NSError(
                domain: "AethernityContextActor", code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Resource not found"])
        }
        return try await resource.read()
    }

    public distributed func subscribeResource(uri: String, options: RequestOptions?) async throws {
        print("Subscribed to resource: \(uri)")
    }

    public distributed func unsubscribeResource(uri: String, options: RequestOptions?) async throws
    {
        print("Unsubscribed from resource: \(uri)")
    }

    public distributed func callTool(name: String, parameters: Data, options: RequestOptions?)
        async throws -> String
    {
        guard let tool = self.tools[name] else {
            return "Tool \(name) not found"
        }
        do {
            let result = try await tool.call(data: parameters)
            return result
        } catch {
            print(error)
            return "error"
        }
    }

    public distributed func listTools(option: RequestOptions?) -> ListResponse<ToolResponse> {
        let toolsArray = self.tools.map { (_, tool) in
            ToolResponse(
                name: tool.name,
                description: tool.description,
                inputSchema: tool.inputSchema,
                guide: tool.guide)
        }
        return ListResponse(results: Array(toolsArray))
    }

    public distributed func sendRootsListChanged(options: RequestOptions?) async throws {
        print("Roots list changed notification sent")
    }
}
