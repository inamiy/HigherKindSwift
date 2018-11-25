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
    public typealias F2 = ForTuple2
    public typealias A2 = X
    public typealias A1 = Y

    /// - Note: autogeneratable
    public init(kind2: Kind2<F2, A2, A1>)
    {
        self = kind2._value as! Tuple2<A2, A1>
    }

    /// - Note: autogeneratable
    public var kind2: Kind2<F2, A2, A1>
    {
        return Kind2(self)
    }
}

/// - Note: autogeneratable
extension Tuple2: PseudoBifunctor
{
    public func first<B2>(_ f: @escaping (A2) -> B2) -> Tuple2<B2, A1>
    {
        return F2.first(f)(self.kind2).value
    }

    public func second<B1>(_ f: @escaping (A1) -> B1) -> Tuple2<A2, B1>
    {
        return F2.second(f)(self.kind2).value
    }
}

/// - Note: autogeneratable
extension Tuple2: PseudoFunctor
{
    public func fmap<B>(_ f: @escaping (A1) -> B) -> Tuple2<X, B>
    {
        return Kind<ForTuple2, X>.fmap(f)(self.kind).value
    }
}

// MARK: - ForTuple2

/// - Note: autogeneratable
public enum ForTuple2 {}

/// - Note: autogeneratable
extension Kind2 where F2 == ForTuple2
{
    public var value: Tuple2<A2, A1>
    {
        return Tuple2(kind2: self)
    }
}

/// - Note: autogeneratable
extension Kind where F1: KindConvertible, F1.F1 == ForTuple2
{
    public var value: Tuple2<F1.A1, A1>
    {
        return self._value as! Tuple2<F1.A1, A1>
    }
}

// MARK: ForBifunctor

extension ForTuple2: ForBifunctor
{
    public static func bimap<A2, A1, B2, B1>(
        _ f1: @escaping (A2) -> B2,
        _ f2: @escaping (A1) -> B1
        ) -> (Kind2<ForTuple2, A2, A1>) -> Kind2<ForTuple2, B2, B1>
    {
        return { kind2 in
            let value = kind2.value
            return Tuple2(f1(value.x), f2(value.y)).kind2
        }
    }
}

// TODO: `instance Monoid a => Applicative ((,) a)`
// TODO: `instance Monoid a => Monad ((,) a)`
