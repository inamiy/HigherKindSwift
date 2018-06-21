import XCTest
@testable import HigherKindSwift

final class MonadTests: XCTestCase
{
    func testArray()
    {
        it("Without Kind") {
            it("Array.fmap") {
                let result = [1, 2, 3]
                    .fmap { "\($0)!" }
                XCTAssertEqual(result, ["1!", "2!", "3!"])
            }

            it("Array.bind") {
                let result = [1, 2, 3]
                    .bind { [$0 * 3, $0 * 5 ] }
                XCTAssertEqual(result, [3, 5, 6, 10, 9, 15])
            }
        }

        it("With Kind") {
            it("Array.kind.fmap") {
                let result = [1, 2, 3].kind
                    .fmap { "\($0)!" }.value
                XCTAssertEqual(result, ["1!", "2!", "3!"])
            }

            it("Array.kind.bind") {
                let result = [1, 2, 3].kind
                    .bind { [$0 * 3, $0 * 5 ].kind }.value
                XCTAssertEqual(result, [3, 5, 6, 10, 9, 15])
            }
        }
    }

    func testList()
    {
        let list = List<Int>.cons(1, .cons(2, .cons(3, .nil)))

        it("Without Kind") {
            it("List.fmap") {
                let result = list
                    .fmap { "\($0)!" }
                XCTAssertEqual(result, List.cons("1!", .cons("2!", .cons("3!", .nil))))
            }

            it("List.bind") {
                let result = list
                    .bind { List.cons($0 * 3, .cons($0 * 5, .nil)) }
                XCTAssertEqual(
                    result,
                    List.cons(3, .cons(5, .cons(6, .cons(10, .cons(9, .cons(15, .nil))))))
                )
            }
        }

        it("With Kind") {
            it("List.kind.fmap") {
                let result = list.kind
                    .fmap { "\($0)!" }.value
                XCTAssertEqual(result, List.cons("1!", .cons("2!", .cons("3!", .nil))))
            }

            it("List.kind.bind") {
                let result = list.kind
                    .bind { List.cons($0 * 3, .cons($0 * 5, .nil)).kind }.value
                XCTAssertEqual(
                    result,
                    List.cons(3, .cons(5, .cons(6, .cons(10, .cons(9, .cons(15, .nil))))))
                )
            }
        }
    }

    func testTree()
    {
        let tree: Tree<Int> =
            .node(
                .node(.leaf, 1, .leaf),
                2,
                .node(.leaf, 3, .leaf)
            )

        let tree2: Tree<Int> =
            .node(
                .node(.leaf, 2, .leaf),
                3,
                .node(.leaf, 4, .leaf)
            )

        it("Without Kind") {
            it("Tree.fmap") {
                let result = tree
                    .fmap { $0 + 1 }
                XCTAssertEqual(result, tree2)
            }
        }

        it("With Kind") {
            it("Tree.kind.fmap") {
                let result = tree.kind
                    .fmap { $0 + 1 }.value
                XCTAssertEqual(result, tree2)
            }
        }
    }

    func testReader()
    {
        it("Without Kind") {
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

        it("With Kind") {
            it("Reader.kind.lmap") {
                let reader = Reader<Int, String> { "\($0)abc" }
                let reader2: Reader<Bool, String> = reader.kind2.lmap { $0 ? 1 : 0 }.value
                let result = reader2.run(true)
                XCTAssertEqual(result, "1abc")
            }

            it("Reader.kind.rmap") {
                let reader = Reader<Int, String> { "\($0)abc" }
                let reader2 = reader.kind2.rmap { $0.uppercased() }.value
                let result = reader2.run(100)
                XCTAssertEqual(result, "100ABC")
            }
        }
    }

    func testTuple2()
    {
        it("Without Kind") {
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

        it("With Kind") {
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

    static let allTests = [
        ("testArray", testArray),
        ("testList", testList),
        ("testTree", testTree),
        ("testReader", testReader),
        ("testTuple2", testTuple2),
    ]
}
