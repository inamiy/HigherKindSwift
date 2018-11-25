import XCTest
import HigherKindSwift

final class MonadTests: XCTestCase
{
    func testArray()
    {
        describe("Without Kind") {

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

        describe("With Kind") {

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

        describe("Without Kind") {

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

        describe("With Kind") {

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

        describe("Without Kind") {

            it("Tree.fmap") {
                let result = tree
                    .fmap { $0 + 1 }
                XCTAssertEqual(result, tree2)
            }

        }

        describe("With Kind") {

            it("Tree.kind.fmap") {
                let result = tree.kind
                    .fmap { $0 + 1 }.value
                XCTAssertEqual(result, tree2)
            }

        }
    }

    static let allTests = [
        ("testArray", testArray),
        ("testList", testList),
        ("testTree", testTree),
    ]
}
