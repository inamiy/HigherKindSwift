import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MonadTests.allTests),
        testCase(NaturalTransformationTests.allTests),
    ]
}
#endif
