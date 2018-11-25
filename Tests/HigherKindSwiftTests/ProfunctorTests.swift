import XCTest
import HigherKindSwift

final class ProfunctorTests: XCTestCase
{
    func testReader()
    {
        describe("Without Kind") {

            context("Profunctor") {

                it("Reader.dimap") {
                    let reader = Reader<Int, String> { "\($0)abc" }
                    let reader2: Reader<Bool, String> = reader.dimap({ $0 ? 1 : 0 }, { $0.uppercased() })
                    let result = reader2.run(true)
                    XCTAssertEqual(result, "1ABC")
                }

                it("Reader.lmap") {
                    let reader = Reader<Int, String> { "\($0)abc" }
                    let reader2: Reader<Bool, String> = reader.lmap { $0 ? 1 : 0 }
                    let result = reader2.run(true)
                    XCTAssertEqual(result, "1abc")
                }

                it("Reader.rmap") {
                    let reader = Reader<Int, String> { "\($0)abc" }
                    let reader2 = reader.rmap { $0.uppercased() }
                    let result = reader2.run(100)
                    XCTAssertEqual(result, "100ABC")
                }

            }

            context("Functor") {

                it("Reader.fmap") {
                    let reader = Reader<Int, String> { "\($0)abc" }
                    let reader2 = reader.fmap { $0.uppercased() }
                    let result = reader2.run(100)
                    XCTAssertEqual(result, "100ABC")
                }

                it("Reader.pure") {
                    let reader = Reader<Int, String>.pure("OK")
                    let result = reader.run(100)
                    XCTAssertEqual(result, "OK")
                }

                it("Reader.apply") {
                    let reader = Reader<Bool, (String) -> Int>.pure { $0.count }
                    let reader2 = Reader<Bool, String>.pure("Hello")
                    let result = Reader.apply(reader, reader2).run(true)
                    XCTAssertEqual(result, 5)
                }

                it("Reader.bind") {
                    let reader = Reader<Bool, String>.pure("Hello")
                    let reader2 = reader.bind { Reader<Bool, Int>.pure($0.count) }
                    let result = reader2.run(true)
                    XCTAssertEqual(result, 5)
                }

            }
        }

        describe("With Kind") {

            context("Profunctor (kind2)") {

                it("Reader.kind2.dimap") {
                    let reader = Reader<Int, String> { "\($0)abc" }.kind2
                    let reader2 = ForReader
                        .dimap({ $0 ? 1 : 0 }, { $0.uppercased() })(reader)
                        .value
                    let result = reader2.run(true)
                    XCTAssertEqual(result, "1ABC")
                }

                it("Reader.kind2.lmap") {
                    let reader = Reader<Int, String> { "\($0)abc" }
                    let reader2: Reader<Bool, String> = reader.kind2.lmap { $0 ? 1 : 0 }.value
                    let result = reader2.run(true)
                    XCTAssertEqual(result, "1abc")
                }

                it("Reader.kind2.rmap") {
                    let reader = Reader<Int, String> { "\($0)abc" }
                    let reader2 = reader.kind2.rmap { $0.uppercased() }.value
                    let result = reader2.run(100)
                    XCTAssertEqual(result, "100ABC")
                }

            }

            context("Functor (kind)") {

                it("Reader.kind.fmap") {
                    let reader = Reader<Int, String> { "\($0)abc" }
                    let reader2 = reader.kind.fmap { $0.uppercased() }.value
                    let result = reader2.run(100)
                    XCTAssertEqual(result, "100ABC")
                }

                it("Reader.kind.pure") {
                    let reader = Kind<Kind<ForReader, Int>, String>.pure("OK")
                    let result = reader.value.run(100)
                    XCTAssertEqual(result, "OK")
                }

                it("Reader.kind.apply") {
                    let reader = Kind<Kind<ForReader, Bool>, (String) -> Int>.pure { $0.count }
                    let reader2 = Kind<Kind<ForReader, Bool>, String>.pure("Hello").kind
                    let result = Kind<ForReader, Bool>.apply(reader, reader2).value.run(true)
                    XCTAssertEqual(result, 5)
                }

                it("Reader.kind.bind") {
                    let reader = Kind<Kind<ForReader, Bool>, String>.pure("Hello").kind
                    let reader2 = reader.kind.bind { Kind<Kind<ForReader, Bool>, Int>.pure($0.count) }.value
                    let result = reader2.run(true)
                    XCTAssertEqual(result, 5)
                }

            }

        }
    }

    static let allTests = [
        ("testReader", testReader),
    ]
}
