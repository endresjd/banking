---
name: developing-with-swift
description: Use this before writing any with Swift code, before planning code changes and enhancements - establishes style guidelines, teaches you vital Swift techniques
---

## Swift Styleguide

### File organization

Maintain a one-to-one relationship between types and files. Each struct, class, enum, actor, or protocol should be defined in its own dedicated file.

**Guidelines:**
- Create a separate file for each new type
- Name the file exactly as the type (e.g., `PaymentView.swift` for `struct PaymentView`)
- Avoid defining multiple types in a single file
- Keep related helper types in their own files rather than nesting them in the same file

**Exceptions:**
- Very small, private helper types that are only used within a single type and won't be used elsewhere
- Extensions of existing types can be in separate files (e.g., `String+Extensions.swift`)
- Protocol conformance extensions can be in separate files (e.g., `MyType+Codable.swift`)

#### Examples

```swift
// ❌ Bad - Multiple types in one file (PaymentViews.swift)
struct PaymentConfirmationView: View {
    // ...
}

struct PaymentSuccessView: View {
    // ...
}

struct PaymentDetailRow: View {
    // ...
}

// ✅ Good - Each type in its own file
// File: PaymentConfirmationView.swift
struct PaymentConfirmationView: View {
    // ...
}

// File: PaymentSuccessView.swift
struct PaymentSuccessView: View {
    // ...
}

// File: PaymentDetailRow.swift
struct PaymentDetailRow: View {
    // ...
}

// ✅ Good - Exception for private helper
// File: PaymentView.swift
struct PaymentView: View {
    // ...
    
    private struct PriceLabel: View {
        // Small private helper only used here
    }
}
```

### Indentation

4 spaces, no tabs.

### Code comments & code documentation

Use triple slash (`///`) for **API documentation only** - documenting types, 
properties, functions, and parameters. These comments appear before the declaration
they document.

**All public and internal properties, functions, types, and parameters must have documentation comments.** This includes:
- Struct and class properties (unless they are private implementation details)
- Function parameters and return values
- Types (structs, classes, enums, protocols)
- Computed properties that form part of the public API

Use double slash (`//`) for:
- Inline comments within function bodies to explain implementation details
- Xcode directive comments ("MARK:", "TODO:", etc.)
- Temporarily disabling blocks of code
- Private implementation details that don't need formal documentation

**Never use `///` inside function bodies.** Documentation comments are for the 
public interface, not implementation details.

#### Examples

```swift
// ✅ Good - Type and properties documented
/// Represents a bill that can be paid through the banking app.
struct Bill: Identifiable {
    /// Unique identifier for the bill.
    let id: UUID
    
    /// The name of the payee.
    let payee: String
    
    /// The amount due for this bill.
    let amount: Decimal
    
    /// The date when the bill is due.
    let dueDate: Date
}

// ❌ Bad - No documentation for properties
struct Bill: Identifiable {
    let id: UUID
    let payee: String
    let amount: Decimal
    let dueDate: Date
}

// ✅ Good - Function with parameter documentation
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

// ✅ Good - Private properties can use inline comments or no comments
struct PaymentView: View {
    /// The bill to be paid.
    let bill: Bill
    
    // Internal state for managing the payment flow
    @State private var isProcessing = false
}
```

Never use triple slash (`///`) in the body of a function or block.  Only use them outside when attached to types, properties, functions, etc.

### Type inference

Omit explicit type annotations when the type can be clearly inferred from the assigned value. This makes code more concise and easier to read.

**Always omit the type when:**
- The right-hand side clearly indicates the type
- Using property wrappers like `@State`, `@Binding`, etc.
- Assigning literal values or calling initializers

**Include the type when:**
- The inferred type would be incorrect or ambiguous
- It significantly improves code clarity
- Working with protocols or generic constraints

#### Examples

```swift
// ❌ Bad - Redundant type annotation
@State private var selectedAccount: Account = Account.samples[0]
let isValid: Bool = true
var count: Int = 0
let items: [String] = ["one", "two", "three"]

// ✅ Good - Type inferred
@State private var selectedAccount = Account.samples[0]
let isValid = true
var count = 0
let items = ["one", "two", "three"]

// ❌ Bad - Type needed but omitted (ambiguous)
let value = 42.0  // Is this Double or CGFloat?

// ✅ Good - Explicit when needed
let value: CGFloat = 42.0

// ✅ Good - Type inferred from initializer
let date = Date()
let decoder = JSONDecoder()
@State private var showingAlert = false
@Binding var text: String  // Type needed for parameter

// ❌ Bad - Redundant for properties with obvious types
class ViewModel {
    @Published var items: [Item] = []
    var count: Int = 0
}

// ✅ Good
class ViewModel {
    @Published var items = [Item]()
    var count = 0
}
```

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

### Property ordering

Properties should be ordered from most visible to least visible outside the type. Within each visibility level, properties with property wrappers should be grouped together at the top.

**Ordering priority:**
1. **Public** properties (most visible)
   - Properties with wrappers first (e.g., `@Published`, `@AppStorage`)
   - Regular properties after
2. **Internal** properties (default visibility)
   - Properties with wrappers first
   - Regular properties after
3. **Private** properties (least visible)
   - Properties with wrappers first (e.g., `@State`, `@StateObject`, `@Environment`)
   - Regular properties after

#### Examples

```swift
// ❌ Bad - Random ordering
struct ContentView: View {
    private var title = "Hello"
    @State private var isShowing = false
    let id: UUID
    @Binding var text: String
    private let formatter = DateFormatter()
    @Environment(\.dismiss) private var dismiss
}

// ✅ Good - Ordered by visibility, wrappers first
struct ContentView: View {
    @Binding var text: String
    let id: UUID
    @Environment(\.dismiss) private var dismiss
    @State private var isShowing = false
    private let formatter = DateFormatter()
    private var title = "Hello"
}

// ❌ Bad - Mixed ordering
class ViewModel: ObservableObject {
    private var cache = [String: Data]()
    @Published var items = [Item]()
    let configuration: Config
    @Published var isLoading = false
    private let apiKey: String
}

// ✅ Good - Public wrappers, public regular, private wrappers, private regular
class ViewModel: ObservableObject {
    @Published var items = [Item]()
    @Published var isLoading = false
    let configuration: Config
    private let apiKey: String
    private var cache = [String: Data]()
}

// ✅ Good - Clear grouping in a complex view
struct PaymentView: View {
    // Public/Internal properties with wrappers
    @Binding var accountBalance: Double
    
    // Public/Internal properties
    let bill: Bill
    let onConfirm: () -> Void
    let onDismiss: () -> Void
    
    // Private properties with wrappers
    @Environment(\.dismiss) private var dismiss
    @State private var isProcessing = false
    @State private var showSuccess = false
    @State private var paymentDate = Date()
    
    // Private computed properties
    private var hasInsufficientFunds: Bool {
        accountBalance < bill.amount
    }
}
```

### Trailing closures

When a function or initializer's last parameter is a closure, always use trailing closure syntax at call sites. This makes the code more readable and follows Swift conventions.

**Guidelines:**
- If the last parameter is a closure (including `@escaping` closures), use trailing closure syntax
- Omit the parameter label when using trailing closure syntax
- This applies to function calls, initializers, and method calls

#### Examples

```swift
// ❌ Bad - Closure as labeled parameter
Button(action: {
    dismiss()
}, label: {
    Text("Close")
})

// ✅ Good - Trailing closure syntax
Button {
    dismiss()
} label: {
    Text("Close")
}

// ❌ Bad - Last parameter is closure but not using trailing syntax
PaymentView(
    bill: bill,
    amount: amount,
    onConfirm: {
        processPayment()
    }
)

// ✅ Good - Trailing closure for last parameter
PaymentView(
    bill: bill,
    amount: amount
) {
    processPayment()
}

// ❌ Bad - Multiple trailing closures not properly formatted
List {
    ForEach(items, content: { item in
        Text(item.name)
    })
}

// ✅ Good - Multiple trailing closures
List {
    ForEach(items) { item in
        Text(item.name)
    }
}

// ✅ Good - Single trailing closure
Task {
    await loadData()
}

// ❌ Bad - Two closures at end, both as labeled parameters
MyView(
    title: "Hello",
    onSave: {
        save()
    },
    onCancel: {
        cancel()
    }
)

// ✅ Good - Two closures at end, use trailing closure for last, label for second-to-last
MyView(
    title: "Hello",
    onSave: {
        save()
    }
) {
    cancel()
}
```

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
