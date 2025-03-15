# AethernityMCP Swift SDK Commands & Guidelines

## Build & Test Commands
- Build project: `swift build`
- Run all tests: `swift test`
- Run single test: `swift test --filter AethernityMCPTests/[TestClass]/[testMethod]`
  - Example: `swift test --filter AethernityMCPTests/ClientTests/testClientConnectAndDisconnect`

## Code Style Guidelines
- **Imports**: System imports first, then specific Foundation components
- **Formatting**: 4-space indentation, reasonable line lengths
- **Requirements**: Swift 6.0+, macOS 14+, iOS 17+
- **Naming**: Follow Apple Swift API guidelines
  - Methods: verb-first (`connect()`, `send()`)
  - Boolean properties: `is` prefix (`isConnected`)
- **Error Handling**: Custom `Error` enum with descriptive cases that conform to `LocalizedError`
- **Architecture**: Actor-based concurrency model with protocol-oriented design
- **Async/Await**: Use modern Swift concurrency with proper task management
- **Documentation**: Clear documentation for public interfaces with MARK comments for organization