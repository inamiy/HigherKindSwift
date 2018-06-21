// MARK: - Bifunctor

public protocol Bifunctor
{
    associatedtype F: ForBifunctor
    associatedtype A1
    associatedtype A2

    func first<B1>(_ f: @escaping (A1) -> B1) -> Kind2<F, B1, A2>
    func second<B2>(_ f: @escaping (A2) -> B2) -> Kind2<F, A1, B2>
}

// MARK: - ForBifunctor

/// - Minimal: bimap | first, second
public protocol ForBifunctor: ForTypeConstructor2
{
    static func bimap<A1, A2, B1, B2>(_ f1: @escaping (A1) -> B1, _ f2: @escaping (A2) -> B2) -> (Kind2<Self, A1, A2>) -> Kind2<Self, B1, B2>
    static func first<A1, A2, B1>(_ f: @escaping (A1) -> B1) -> (Kind2<Self, A1, A2>) -> Kind2<Self, B1, A2>
    static func second<A1, A2, B2>(_ f: @escaping (A2) -> B2) -> (Kind2<Self, A1, A2>) -> Kind2<Self, A1, B2>
}

extension ForBifunctor
{
    /// Default implementation.
    public static func bimap<A1, A2, B1, B2>(_ f1: @escaping (A1) -> B1, _ f2: @escaping (A2) -> B2) -> (Kind2<Self, A1, A2>) -> Kind2<Self, B1, B2>
    {
        return { $0.first(f1).second(f2) }
    }

    /// Default implementation.
    public static func first<A1, A2, B1>(_ f: @escaping (A1) -> B1) -> (Kind2<Self, A1, A2>) -> Kind2<Self, B1, A2>
    {
        return self.bimap(f, { $0 })
    }

    /// Default implementation.
    public static func second<A1, A2, B2>(_ f: @escaping (A2) -> B2) -> (Kind2<Self, A1, A2>) -> Kind2<Self, A1, B2>
    {
        return self.bimap({ $0 }, f)
    }
}

extension Kind2: Bifunctor where F: ForBifunctor
{
    public func first<B1>(_ f: @escaping (A1) -> B1) -> Kind2<F, B1, A2>
    {
        return F.first(f)(self)
    }

    public func second<B2>(_ f: @escaping (A2) -> B2) -> Kind2<F, A1, B2>
    {
        return F.second(f)(self)
    }
}

// MARK: - PseudoBifunctor

/// - Note:
/// Use this fancy protocol for true type-constructors.
public protocol PseudoBifunctor {}
