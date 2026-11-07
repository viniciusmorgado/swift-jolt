public struct JoltError : Error, Hashable, Sendable, CustomStringConvertible {
    public let description: String
    private init (_ description: String) {
        self.description = description
    }
    
    public static let initializationFailed = JoltError("Jolt Physics failed to initialize.")
}

public func initialize() throws(JoltError) {
    guard initializeJolt() else {
        throw .initializationFailed
    }
}

public func shutdown() {
    shutdownJolt()
}
