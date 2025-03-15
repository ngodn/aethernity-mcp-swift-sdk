# Aethernity MCP Swift SDK

## Build & Test Commands
- Build: `swift build`
- Run tests: None currently defined
- Format code: `swift-format format -i Sources/**/*.swift`

## Code Style Guidelines
- Swift version: Swift 6.0+
- Platform support: 
  - macOS v15+, iOS v18+ (requires `_DistributedActorStub` support)
  - Linux (no version restrictions)

### Cross-Platform Considerations
- Document platform-specific requirements using comments
- Avoid Apple-specific frameworks (UIKit, AppKit, etc.)
- Use conditional compilation (`#if os(Linux)`, etc.) when necessary

### Naming Conventions
- Protocol names: PascalCase, descriptive of purpose (e.g., `Tool`, `Resource`, `Prompt`)
- Properties: camelCase
- Documentation: Every public type/function has doc comments

### Documentation 
- Use triple-slash `///` comments for public API documentation
- Include parameter descriptions and examples for complex functions
- Document thrown errors
- File header comments should match actual file names:
  - Fix these mismatches:
    - `AethernityContextProtocol.swift` (currently "Greeter.swift")
    - `AethernityContextClient.swift` (currently "Client.swift")
    - `AethernityContextServer.swift` (currently "ContextServer.swift")

### Error Handling
- Use typed errors (e.g., `ToolError`)
- Provide descriptive error messages

### Protocol Design
- Follow Swift's distributed actor model
- Use proper type constraints (e.g., `Sendable`, `Codable`)
- Make all public interfaces protocol-based for flexibility

### Imports
- Import only what's needed
- Use `@_exported import` for dependencies that should be re-exported