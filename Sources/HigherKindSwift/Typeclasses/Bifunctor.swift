// MARK: - Bifunctor

public protocol Bifunctor
{
    associatedtype F2: ForBifunctor
    associatedtype A2
    associatedtype A1

    func bimap<B2, B1>(
        _ f1: @escaping (A2) -> B2,
        _ f2: @escaping (A1) -> B1
        ) -> Kind2<F2, B2, B1>

    func first<B2>(_ f: @escaping (A2) -> B2) -> Kind2<F2, B2, A1>
    func second<B1>(_ f: @escaping (A1) -> B1) -> Kind2<F2, A2, B1>
}

// MARK: - ForBifunctor

/// - Minimal: bimap | first, second
public protocol ForBifunctor: ForFunctor2
{
    static func bimap<A2, A1, B2, B1>(
        _ f1: @escaping (A2) -> B2,
        _ f2: @escaping (A1) -> B1
        ) -> (Kind2<Self, A2, A1>) -> Kind2<Self, B2, B1>

    static func first<A2, A1, B2>(
        _ f: @escaping (A2) -> B2
        ) -> (Kind2<Self, A2, A1>) -> Kind2<Self, B2, A1>

    static func second<A2, A1, B1>(
        _ f: @escaping (A1) -> B1
        ) -> (Kind2<Self, A2, A1>) -> Kind2<Self, A2, B1>
}

extension ForBifunctor
{
    /// Default implementation.
    public static func bimap<A2, A1, B2, B1>(
        _ f1: @escaping (A2) -> B2,
        _ f2: @escaping (A1) -> B1
        ) -> (Kind2<Self, A2, A1>) -> Kind2<Self, B2, B1>
    {
        return { self.second(f2)(self.first(f1)($0)) }
    }

    /// Default implementation.
    public static func first<A2, A1, B2>(
        _ f: @escaping (A2) -> B2
        ) -> (Kind2<Self, A2, A1>) -> Kind2<Self, B2, A1>
    {
        return self.bimap(f, { $0 })
    }

    /// Default implementation.
    public static func second<A2, A1, B1>(
        _ f: @escaping (A1) -> B1
        ) -> (Kind2<Self, A2, A1>) -> Kind2<Self, A2, B1>
    {
        return self.bimap({ $0 }, f)
    }

    /// Default implementation.
    public static func fmap<A2, A, B>(
        _ f: @escaping (A) -> B
        ) -> (Kind<Kind<Self, A2>, A>) -> Kind<Kind<Self, A2>, B>
    {
        return { Kind2<Self, A2, A>($0._value).second(f).kind }
    }
}

// MARK: - Default implementation

extension Kind2: Bifunctor where F2: ForBifunctor
{
    public func bimap<B2, B1>(
        _ f1: @escaping (A2) -> B2,
        _ f2: @escaping (A1) -> B1
        ) -> Kind2<F2, B2, B1>
    {
        return F2.bimap(f1, f2)(self)
    }

    public func first<B2>(_ f: @escaping (A2) -> B2) -> Kind2<F2, B2, A1>
    {
        return F2.first(f)(self)
    }

    public func second<B1>(_ f: @escaping (A1) -> B1) -> Kind2<F2, A2, B1>
    {
        return F2.second(f)(self)
    }
}

// MARK: - PseudoBifunctor

/// - Note:
/// Use this fancy protocol for true type-constructors.
public protocol PseudoBifunctor {}
