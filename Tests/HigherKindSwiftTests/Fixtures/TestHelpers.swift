import XCTest
import _SwiftXCTestOverlayShims

public func describe(_ name: String, _ task: () -> ())
{
    it(name, task)
}

public func context(_ name: String, _ task: () -> ())
{
    it(name, task)
}

public func it(_ name: String, _ task: () -> ())
{
    // https://github.com/apple/swift/blob/50fb3b8496f9501c95326a1f9e33638e56797fb0/stdlib/public/SDK/XCTest/XCTest.swift#L26
    if _XCTContextShouldStartActivity(_XCTContextCurrent(), XCTActivityTypeUserCreated) {
        XCTContext.runActivity(named: name) { _ in
            task()
        }
    }
    else {
        task()
    }
}

public func xit(_ name: String, _ task: () -> ())
{
    // Skip test.
}
