import Prelude
import SwiftCheck
import XCTest
import HigherKindSwift

final class NaturalTransformationTests: XCTestCase
{
    func testNaturalTransformation()
    {
        describe("Using protocol") {

            it(".some(1) -> [1]") {
                let result = Optional(1).kind
                    .naturalTransform(OptionalToArray.self).value
                XCTAssertEqual(result, [1])
            }

            it(".none -> []") {
                let result = Optional<Int>.none.kind
                    .naturalTransform(OptionalToArray.self).value
                XCTAssertEqual(result, [])
            }

            it("[1,2,3] -> .cons(1, cons(2, .cons(3, nil)))") {
                let result = [1, 2, 3].kind
                    .naturalTransform(ArrayToList.self).value
                XCTAssertEqual(result, List.cons(1, .cons(2, .cons(3, .nil))))
            }

            it(".cons(1, cons(2, .cons(3, nil))) -> [1,2,3]") {
                let result = List.cons(1, .cons(2, .cons(3, .nil))).kind
                    .naturalTransform(ListToArray.self).value
                XCTAssertEqual(result, [1, 2, 3])
            }

        }

        describe("Custom functions") {

            it("Inline closure") {
                let result = [1, 2, 3].kind
                    .naturalTransform { $0.value.first.kind }.value
                XCTAssertEqual(result, .some(1))
            }

            it("Generic function") {
                func first<T>(_ k: Kind<ForArray, T>) -> Kind<ForOptional, T>
                {
                    return k.value.first.kind
                }

                let result = [1, 2, 3].kind
                    .naturalTransform(first).value
                XCTAssertEqual(result, .some(1))
            }

        }

        describe("Naturality condition") {

            /// Plain morphism: String -> Int
            func f(_ str: String) -> Int
            {
                return str.count
            }

            /// F f (F.fmap(f))
            let Ff = flip(Array.fmap)(f)
            let _Ff: (Kind<ForArray, String>) -> Kind<ForArray, Int> = { Ff($0.value).kind }

            /// G f (G.fmap(f))
            let Gf = flip(Optional.fmap)(f)
            let _Gf: (Kind<ForOptional, String>) -> Kind<ForOptional, Int> = { Gf($0.value).kind }

            /// Natural transformation: Array<T> -> Optional<T>
            func nat<T>(_ k: Kind<ForArray, T>) -> Kind<ForOptional, T>
            {
                return k.value.first.kind
            }

            let nat_Ff = nat <<< _Ff
            let Gf_nat = _Gf <<< nat

            property("`alpha . F f = G f . alpha` holds") <- forAll { (strings : [String]) in
                return (strings.kind |> nat_Ff).value == (strings.kind |> Gf_nat).value
            }

        }

    }

    static let allTests = [
        ("testNaturalTransformation", testNaturalTransformation),
        ]
}

// MARK: - Private

fileprivate enum OptionalToArray: NaturalTransformation
{
    fileprivate static func naturalTransform<A>(_ kind: Kind<ForOptional, A>) -> Kind<ForArray, A>
    {
        if let value = kind.value {
            return [value].kind
        }
        else {
            return [].kind
        }
    }
}

fileprivate enum ArrayToList: NaturalTransformation
{
    fileprivate static func naturalTransform<A>(_ kind: Kind<ForArray, A>) -> Kind<ForList, A>
    {
        return List(kind.value).kind
    }
}

fileprivate enum ListToArray: NaturalTransformation
{
    fileprivate static func naturalTransform<A>(_ kind: Kind<ForList, A>) -> Kind<ForArray, A>
    {
        var list = kind.value
        var arr = [A]()

        while true {
            switch list {
            case .nil:
                return arr.kind
            case let .cons(head, tail):
                arr.append(head)
                list = tail
            }
        }
    }
}
