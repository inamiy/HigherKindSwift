// MARK: - Tuple2

public struct Tuple2<X, Y>
{
    public let x: X
    public let y: Y

    public init(_ x: X, _ y: Y)
    {
        self.x = x
        self.y = y
    }
}

extension Tuple2: Equatable where X: Equatable, Y: Equatable {}

extension Tuple2: Kind2Convertible
{
    public typealias F = ForTuple2
    public typealias A1 = X
    public typealias A2 = Y

    /// - Note: autogeneratable
    public init(kind2: Kind2<F, A1, A2>)
    {
        self = kind2._value as! Tuple2<A1, A2>
    }

    /// - Note: autogeneratable
    public var kind2: Kind2<F, A1, A2>
    {
        return Kind2(self)
    }
}

/// - Note: autogeneratable
extension Tuple2: PseudoBifunctor
{
    public func first<B1>(_ f: @escaping (A1) -> B1) -> Tuple2<B1, A2>
    {
        return F.first(f)(self.kind2).value
    }

    public func second<B2>(_ f: @escaping (A2) -> B2) -> Tuple2<A1, B2>
    {
        return F.second(f)(self.kind2).value
    }
}

// MARK: - ForTuple2

/// - Note: autogeneratable
public enum ForTuple2 {}

/// - Note: autogeneratable
extension Kind2 where F == ForTuple2
{
    public var value: Tuple2<A1, A2>
    {
        return Tuple2(kind2: self)
    }
}

extension ForTuple2: ForBifunctor
{
    public static func first<A1, A2, B1>(_ f: @escaping (A1) -> B1) -> (Kind2<ForTuple2, A1, A2>) -> Kind2<ForTuple2, B1, A2>
    {
        return { kind2 in
            let value = kind2.value
            return Tuple2(f(value.x), value.y).kind2
        }
    }

    public static func second<A1, A2, B2>(_ f: @escaping (A2) -> B2) -> (Kind2<ForTuple2, A1, A2>) -> Kind2<ForTuple2, A1, B2>
    {
        return { kind2 in
            let value = kind2.value
            return Tuple2(value.x, f(value.y)).kind2
        }
    }
}
