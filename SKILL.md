---
name: developing-with-swift
description: Use this before writing any with Swift code, before planning code changes and enhancements - establishes style guidelines, teaches you vital Swift techniques
---

## Swift Styleguide

### Indentation

4 spaces, no tabs.

### Code comments & code documentation

Use triple slash (`///`) for **API documentation only** - documenting types, 
properties, functions, and parameters. These comments appear before the declaration
they document.

Use double slash (`//`) for:
- Inline comments within function bodies to explain implementation details
- Xcode directive comments ("MARK:", "TODO:", etc.)
- Temporarily disabling blocks of code

**Never use `///` inside function bodies.** Documentation comments are for the 
public interface, not implementation details.

#### Examples

```swift
// ✅ Good - API documentation
/// Fetches a random joke from the API.
///
/// - Parameter type: The type of joke to fetch.
/// - Returns: A joke object or nil if none found.
func fetchJoke(ofType type: String) async -> Joke? {
    // Good - inline comment explaining implementation
    // The API returns an array with one joke for this endpoint
    let jokes = try JSONDecoder().decode([Joke].self, from: data)
    
    return jokes.first
}

// ❌ Bad - documentation comment inside function body
func fetchJoke(ofType type: String) async -> Joke? {
    /// The API returns an array with one joke for this endpoint
    let jokes = try JSONDecoder().decode([Joke].self, from: data)
    
    return jokes.first
}

// ❌ Bad - double slash for API documentation
// Fetches a random joke from the API.
func fetchJoke(ofType type: String) async -> Joke? {
    // ...
}
```

Never use triple slash (`///`) in the body of a function or block.  Only use them outside when attached to types, properties, functions, etc.

### `guard` clauses

`guard` clauses must be written single-line. If a clause combines multiple
conditions, each condition must be on its own line.

#### Examples

```swift
// ❌ Bad
guard somethingCondition else { return }

// ✅ Good
guard somethingCondition else {
    return
}

// ❌ Bad
guard !somethingCondition1, let something else { return }

// ✅ Good
guard !somethingCondition1, 
    let something else {
  return
}
```

Any `guard` clause must be followed by a blank line and preceded by blank line.

### Vertical spacing

Keep logical blocks together.  vars and lets should not have blank lines between then unless they span multiple lines.  All logic should be seperated by at least one blank line. Try to group lets and vars together.

#### Examples

```swift
// ❌ Bad
let a = 1

var b = 2
let c = 3

let d = 4

// ✅ Good
let a = 1
let c = 3
let d = 4
var b = 2

// ❌ Bad
let a = 1
#expect(a == 2)

// ✅ Good
let a = 1

#expect(a == 2)

// ❌ Bad
let renderer = ImageRenderer(content: jokeImageView)
renderer.scale = UIScreen.main.scale

// ✅ Good
let renderer = ImageRenderer(content: jokeImageView)

renderer.scale = UIScreen.main.scale
```

### `if` blocks

`if` clauses must be written single-line. If a clause combines multiple
conditions, each condition should be on its own line. If there is more than one
condition, the opening bracket (`{`) should be on its own line.

#### Examples

```swift
// ❌ Bad
if !somethingCondition1, let something {
    return
}

// ✅ Good
if !somethingCondition1,
   let something {
    return
}
```

### `switch/case`

Every `case` block must be followed by a no blank lines.

### Closures and blocks

**All closures and code blocks must be multi-line.** Never write a closure or block with its opening brace, content, and closing brace on the same line.

This applies to:
- Closures passed as arguments (e.g., button actions, completion handlers)
- Task blocks
- Animation blocks
- Any code between `{` and `}`

#### Examples

```swift
// ❌ Bad - Single-line Task block
Button {
    Task { await service.fetchData() }
} label: {
    Text("Fetch")
}

// ✅ Good - Multi-line Task block
Button {
    Task {
        await service.fetchData()
    }
} label: {
    Text("Fetch")
}

// ❌ Bad - Single-line animation
Button("Animate") {
    withAnimation { isAnimating.toggle() }
}

// ✅ Good - Multi-line animation
Button("Animate") {
    withAnimation {
        isAnimating.toggle()
    }
}

// ❌ Bad - Single-line closure
items.forEach { print($0) }

// ✅ Good - Multi-line closure
items.forEach {
    print($0)
}

// ❌ Bad - Inline closure with multiple statements
Button("Save") { saveData(); dismiss() }

// ✅ Good - Multi-line closure
Button("Save") {
    saveData()
    dismiss()
}
```

**Exception:** Trailing closures in functional programming (map, filter, etc.) with very simple single expressions may remain on one line if the entire statement fits clearly:

```swift
// ✅ Acceptable - Simple, clear functional operation
let names = users.map { $0.name }
let active = items.filter { $0.isActive }

// ❌ Bad - Even if simple, Task blocks should always be multi-line
Task { await fetch() }

// ✅ Good
Task {
    await fetch()
}
```

### `Swift testing`

- Tests must be written with Swift Testing
- Do not use XCTest in any case
- All test functions must run on @MainActor
- Use descriptive strings in the @Test macros
- Do not add Given, When, or Then comments in tests.

#### Examples

```swift
// ❌ Bad
@Suite("Condition Tests")
struct ConditionTests {
    @Test("Fetch joke successfully")
    func fetchJokeSuccess() async throws {
    }
}

// ✅ Good
@Suite("Condition Tests")
struct ConditionTests {
    @Test("Fetch joke successfully")
    @MainActor
    func fetchJokeSuccess() async throws {
    }
}

// ❌ Bad
@Test("Joke types loading state updates correctly")
@MainActor
func jokeTypesLoadingState() async throws {
    // Given
    let typesJSON = """
    ["general", "programming"]
    """.data(using: .utf8)!
    let mockResponse = HTTPURLResponse(
        url: URL(string: "https://official-joke-api.appspot.com/types")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
    )!
    let mockSession = MockURLSession(data: typesJSON, response: mockResponse, error: nil)
    let service = JokeService(session: mockSession)
    
    // Initial state
    #expect(service.isLoadingTypes == false)
    
    // When
    await service.fetchJokeTypes()
    
    // Then
    #expect(service.isLoadingTypes == false)
}

// ✅ Good
@Test("Joke types loading state updates correctly")
@MainActor
func jokeTypesLoadingState() async throws {
    let typesJSON = """
        ["general", "programming"]
        """.data(using: .utf8)!
    let mockResponse = HTTPURLResponse(
        url: URL(string: "https://official-joke-api.appspot.com/types")!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: nil
    )!
    let mockSession = MockURLSession(data: typesJSON, response: mockResponse, error: nil)
    let service = JokeService(session: mockSession)
    
    #expect(service.isLoadingTypes == false)
    
    await service.fetchJokeTypes()
    
    #expect(service.isLoadingTypes == false)
}

```

## Code Formatting - Blank Lines

Always add a blank line after variable assignments to separate them from subsequent code.

### Variables

**After any variable declaration/assignment** (`let`, `var`), add a blank line before the next statement (unless the next line is also a variable declaration).

### Examples

```swift
// ✅ CORRECT - Blank line after assignment
let joke = try #require(service.joke)

#expect(joke.id == 42)
#expect(joke.type == "programming")

// ✅ CORRECT - Multiple assignments grouped together
let mockData = createValidJokeData()
let mockResponse = createValidHTTPResponse()
let mockSession = MockURLSession(data: mockData, response: mockResponse, error: nil)

let service = JokeService(session: mockSession)

await service.fetchJoke()

// ✅ CORRECT - Variable assignment followed by blank line
var joke = try #require(service.joke)

#expect(joke.type == "programming")

// ❌ WRONG - No blank line after assignment
let joke = try #require(service.joke)
#expect(joke.id == 42)

// ❌ WRONG - No blank line before non-assignment
let service = JokeService(session: mockSession)
await service.fetchJoke()
```

## Code Formatting - Last Statement in Blocks

### Last Statement Spacing
The last statement in any block should NOT be preceded by a blank line when it is the only statement in that block. When there are multiple statements in a block, the last statement should be preceded by a blank line.

This applies to:
- Return statements
- Throw statements
- Break/continue statements
- Any other statement that ends a block
- Regular statements in closures, if blocks, guard blocks, etc.

```swift
// ✅ CORRECT - return is only statement, no blank line
guard let url = URL(string: "https://example.com") else {
    return
}

// ✅ CORRECT - return is only statement in if block, no blank line
if let uiImage = renderer.uiImage {
    return Image(uiImage: uiImage)
}

// ✅ CORRECT - throw is only statement, no blank line
guard isValid else {
    throw ValidationError.invalid
}

// ✅ CORRECT - single statement in closure, no blank line
Button("Save") {
    save()
}

// ✅ CORRECT - multiple statements, blank line before last statement
guard let url = URL(string: "https://example.com") else {
    errorMessage = "Invalid URL"
    
    return
}

// ✅ CORRECT - multiple statements in if block, blank line before return
if condition {
    doSomething()
    
    return value
}

// ✅ CORRECT - multiple statements in closure, blank line before last
Button("Save") {
    validate()
    save()
}

// ✅ CORRECT - multiple statements, blank line before throw
guard isValid else {
    logError()
    
    throw ValidationError.invalid
}

// ❌ WRONG - only statement but has blank line
if let value = optional {
    
    return value
}

// ❌ WRONG - only statement in closure but has blank line
Button("Save") {
    
    save()
}

// ❌ WRONG - multiple statements but no blank line before last
if condition {
    doSomething()
    return value
}

// ❌ WRONG - multiple statements in closure with blank lines between them.
Button("Save") {
    validate()
    
    save()
}
```

## JSON Formatting Standards

When creating JSON data anywhere in the codebase (tests, mock data, configuration, etc.), always use **pretty-printed format** with proper indentation.

### JSON Formatting Rules

1. **Use 4-space indentation** for each nesting level
2. **Each property on its own line** (not compressed)
3. **Array brackets** - Opening `[` and closing `]` on their own lines
4. **Object braces within arrays** - Opening `{` and closing `}` on their own lines, aligned with array bracket
5. **Properties inside objects** - Indented 4 spaces from the object brace

### Indentation Guidelines

**For arrays containing objects:**
- Opening `[` on its own line
- Opening `{` on its own line, indented 4 spaces from `[`
- Properties indented 4 spaces from `{` (8 spaces total from `[`)
- Closing `}` on its own line, aligned with opening `{`
- Closing `]` on its own line, aligned with opening `[`

**For standalone objects (not in array):**
- Opening `{` on its own line (or same line as `"""`)
- Properties indented 4 spaces from `{`
- Closing `}` on its own line, aligned with opening `{`

**For arrays of simple values (strings, numbers):**
- Each value on its own line
- Values indented 4 spaces from `[`

### Examples

```swift
// ✅ CORRECT - Array containing object
let jokeJSON = """
    [
        {
            "id": 1,
            "type": "general",
            "setup": "Test setup",
            "punchline": "Test punchline"
        }
    ]
    """
    .data(using: .utf8)!

// ✅ CORRECT - Array of strings
let types = """
    [
        "general",
        "programming"
    ]
    """
    .data(using: .utf8)!

// ✅ CORRECT - Standalone object
let joke = """
    {
        "id": 1,
        "type": "general",
        "setup": "Why?",
        "punchline": "Because!"
    }
    """
    .data(using: .utf8)!

// ❌ WRONG - Object brace same line as properties
let jokeJSON = """
    [
        {
        "id": 1,
        "type": "general"
        }
    ]
    """

// ❌ WRONG - No indentation of properties
let jokeJSON = """
    [
        {
        "id": 1
        }
    ]
    """    
```

## Multiline String Formatting

When formatting multiline strings (those that use `"""` on **separate lines**):

**This rule applies to ALL multiline strings, including:**
- Multi-line JSON objects (spanning multiple lines)
- Single-line JSON arrays like `["item1", "item2"]`
- Any content between opening `"""` and closing `"""`

**Key point:** If the opening `"""` and closing `"""` are on different lines (even if the content is just one line), apply this formatting.

### Formatting Rules

1. **Indent the content** - Add 4 spaces of indentation to all content lines
2. **Indent the closing delimiter** - The closing `"""` should be indented at the same level as the content  
3. **Place modifiers on a new line** - Any method calls after `"""` go on their own line

### Examples

```swift
// Single-line content (still multiline string) - NEEDS formatting:
let json = """
["general", "programming"]
""".data(using: .utf8)!

// After:
let json = """
    ["general", "programming"]
    """
    .data(using: .utf8)!

// Multi-line content - NEEDS formatting:
let json = """
{
    "key": "value"
}
""".data(using: .utf8)!

// After:
let json = """
    {
        "key": "value"
    }
    """
    .data(using: .utf8)!```

## Modern Swift

Write idiomatic SwiftUI code following Apple's latest architectural recommendations and best practices.

### Core Philosophy

- SwiftUI is the default UI paradigm for Apple platforms - embrace its
  declarative nature
- Avoid legacy UIKit patterns and unnecessary abstractions
- Focus on simplicity, clarity, and native data flow
- Let SwiftUI handle the complexity - don't fight the framework

### Architecture Guidelines

#### 1. Embrace Native State Management

For simple use cases that don't contain a lot of logic and state, use SwiftUI's
built-in property wrappers appropriately:

- `@State` - Local, ephemeral view state
- `@Binding` - Two-way data flow between views
- `@Observable` - Shared state (iOS 17+)
- `@ObservableObject` - Legacy shared state (pre-iOS 17)
- `@Environment` - Dependency injection for app-wide concerns

**Important:** When using `@Observable` (modern observation framework), **never use `@Published`**. The `@Observable` macro automatically tracks property changes. Only use `@Published` with the legacy `@ObservableObject` protocol.

For more complex use cases with lots of logic and interdependent states, use
[Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture).
Before starting to write code, read the TCA documentation (see section 
_"Read SDK/ package/ library/ framework documentation"_).

#### 2. State Ownership Principles

- Views own their local state unless sharing is required
- State flows down, actions flow up
- Keep state as close to where it's used as possible
- Extract shared state only when multiple views need it

#### 3. Modern Async Patterns

- Use `async/await` as the default for asynchronous operations
- Leverage `.task` modifier for lifecycle-aware async work
- Avoid Combine unless absolutely necessary
- Handle errors gracefully with try/catch

#### 4. View Composition

- Build UI with small, focused views
- Extract reusable components naturally
- Use view modifiers to encapsulate common styling
- Prefer composition over inheritance

#### 5. Code Organization

- Organize by feature, not by type (avoid Views/, Models/, ViewModels/ folders)
- Keep related code together in the same file when appropriate
- Use extensions to organize large files
- Follow Swift naming conventions consistently

### Implementation Patterns

#### Simple State Example

```swift
struct CounterView: View {
    @State private var count = 0

    var body: some View {
        VStack {
            Text("Count: \(count)")
            
            Button("Increment") {
                count += 1
            }
        }
    }
}
```

#### Shared State with @Observable

```swift
@Observable
class UserSession {
    var isAuthenticated = false
    var currentUser: User?

    func signIn(user: User) {
        currentUser = user
        isAuthenticated = true
    }
}

struct MyApp: App {
    @State private var session = UserSession()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(session)
        }
    }
}
```

**Note:** `@Observable` classes do **not** use `@Published`. The macro automatically tracks all property changes. `@Published` is only for legacy `ObservableObject` classes.

#### Async Data Loading

```swift
struct ProfileView: View {
    @State private var profile: Profile?
    @State private var isLoading = false
    @State private var error: Error?

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else if let profile {
                ProfileContent(profile: profile)
            } else if let error {
                ErrorView(error: error)
            }
        }
        .task {
            await loadProfile()
        }
    }

    private func loadProfile() async {
        isLoading = true
        
        defer { 
            isLoading = false
        }

        do {
            profile = try await ProfileService.fetch()
        } catch {
            self.error = error
        }
    }
}
```

### Best Practices

#### Do

- Write self-contained views when possible
- Use property wrappers as intended by Apple
- Test logic in isolation, preview UI visually
- Handle loading and error states explicitly
- Keep views focused on presentation
- Use Swift's type system for safety

#### Do not

- Create ViewModels for every view
- Move state out of views unnecessarily
- Add abstraction layers without clear benefit
- Use Combine for simple async operations
- Fight SwiftUI's update mechanism
- Overcomplicate simple features
- Create a new error type around something that already throws an error.  Preserve the error when possible.

### Testing Strategy

- Unit test business logic and data transformations
- Use SwiftUI Previews for visual testing
- Test @Observable classes independently
- Keep tests simple and focused
- Don't sacrifice code clarity for testability

### Modern Swift Features

- Use Swift Concurrency (async/await, actors)
- Leverage Swift 6 data race safety when available, i.e. when the project is
  built with Swift 6 or later
- Utilize property wrappers effectively
- Embrace value types where appropriate
- Use protocols for abstraction, not just for testing
- Assume approachable concurrency is active and do not annotate Observable methods with @MainActor

### Summary

Write SwiftUI code that looks and feels like SwiftUI. The framework has matured
significantly - trust its patterns and tools. Focus on solving user problems
rather than implementing architectural patterns from other platforms.
