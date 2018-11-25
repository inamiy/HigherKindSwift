import XCTest
import HigherKindSwift

final class BifunctorTests: XCTestCase
{
    func testTuple2()
    {
        describe("Without Kind") {

            it("Tuple2.first") {
                let tuple = Tuple2(1, "ok")
                let result = tuple.first { $0 + 1 }
                XCTAssertEqual(result, Tuple2(2, "ok"))
            }

            it("Tuple2.second") {
                let tuple = Tuple2(1, "ok")
                let result = tuple.second { $0.uppercased() + "!" }
                XCTAssertEqual(result, Tuple2(1, "OK!"))
            }

        }

        describe("With Kind") {

            it("Tuple2.kind2.first") {
                let tuple = Tuple2(1, "ok")
                let result = tuple.kind2.first { $0 + 1 }.value
                XCTAssertEqual(result, Tuple2(2, "ok"))
            }

            it("Tuple2.kind2.second") {
                let tuple = Tuple2(1, "ok")
                let result = tuple.kind2.second { $0.uppercased() + "!" }.value
                XCTAssertEqual(result, Tuple2(1, "OK!"))
            }

        }
    }

    func testEither()
    {
        describe("Without Kind") {

            it("Either.first") {
                do {
                    let either = Either<String, Int>.left("Bad")
                    let result = either.first { $0 + "!" }
                    XCTAssertEqual(result, Either<String, Int>.left("Bad!"))
                }

                do {
                    let either = Either<String, Int>.right(1)
                    let result = either.first { $0 + "!" }
                    XCTAssertEqual(result, Either<String, Int>.right(1))
                }
            }

            it("Either.second") {
                do {
                    let either = Either<String, Int>.left("Bad")
                    let result = either.second { $0 + 100 }
                    XCTAssertEqual(result, Either<String, Int>.left("Bad"))
                }

                do {
                    let either = Either<String, Int>.right(1)
                    let result = either.second { $0 + 100 }
                    XCTAssertEqual(result, Either<String, Int>.right(101))
                }
            }

            it("Either.fmap") {
                do {
                    let either = Either<String, Int>.left("Bad")
                    let result = either.fmap { $0 + 100 }
                    XCTAssertEqual(result, Either<String, Int>.left("Bad"))
                }

                do {
                    let either = Either<String, Int>.right(1)
                    let result = either.fmap { $0 + 100 }
                    XCTAssertEqual(result, Either<String, Int>.right(101))
                }
            }

            it("Either.bind") {
                do {
                    let either = Either<String, Int>.left("Bad")
                    let result = either.bind { Either<String, Bool>.right($0 > 100 ? true : false) }
                    XCTAssertEqual(result, Either<String, Bool>.left("Bad"))
                }

                do {
                    let either = Either<String, Int>.right(1)
                    let result = either.bind { Either<String, Bool>.right($0 > 100 ? true : false) }
                    XCTAssertEqual(result, Either<String, Bool>.right(false))
                }
            }

        }

        describe("With Kind") {

            it("Either.kind2.first") {
                let tuple = Tuple2(1, "ok")
                let result = tuple.kind2.first { $0 + 1 }.value
                XCTAssertEqual(result, Tuple2(2, "ok"))
            }

            it("Either.kind2.second") {
                let tuple = Tuple2(1, "ok")
                let result = tuple.kind2.second { $0.uppercased() + "!" }.value
                XCTAssertEqual(result, Tuple2(1, "OK!"))
            }

            it("Either.kind.fmap") {
                do {
                    let either = Either<String, Int>.left("Bad").kind
                    let result = either.fmap { $0 + 100 }.value
                    XCTAssertEqual(result, Either<String, Int>.left("Bad"))
                }

                do {
                    let either = Either<String, Int>.right(1).kind
                    let result = either.fmap { $0 + 100 }.value
                    XCTAssertEqual(result, Either<String, Int>.right(101))
                }
            }

            it("Either.kind.bind") {
                do {
                    let either = Either<String, Int>.left("Bad").kind
                    let result = either.bind { Either<String, Bool>.right($0 > 100 ? true : false).kind }.value
                    XCTAssertEqual(result, Either<String, Bool>.left("Bad"))
                }

                do {
                    let either = Either<String, Int>.right(1).kind
                    let result = either.bind { Either<String, Bool>.right($0 > 100 ? true : false).kind }.value
                    XCTAssertEqual(result, Either<String, Bool>.right(false))
                }
            }
        }
    }

    static let allTests = [
        ("testTuple2", testTuple2),
        ("testEither", testEither),
    ]
}
