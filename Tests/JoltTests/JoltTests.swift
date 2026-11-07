import Testing
@testable import Jolt

@Test func initializesAndShutsDownRepeatedly() throws {
    try Jolt.initialize()
    try Jolt.initialize()
    Jolt.shutdown()
    Jolt.shutdown()
}
