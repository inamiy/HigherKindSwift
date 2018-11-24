// MARK: - Profunctor

public protocol Profunctor
{
    associatedtype F2: ForProfunctor
    associatedtype A2
    associatedtype A1

    func dimap<B2, B1>(_ f1: @escaping (B2) -> A2, _ f2: @escaping (A1) -> B1) -> Kind2<F2, B2, B1>
    func lmap<B2>(_ f: @escaping (B2) -> A2) -> Kind2<F2, B2, A1>
    func rmap<B1>(_ f: @escaping (A1) -> B1) -> Kind2<F2, A2, B1>
}

// MARK: - ForProfunctor

/// - Minimal: dimap | lmap, rmap
public protocol ForProfunctor
{
    static func dimap<A2, A1, B2, B1>(
        _ f1: @escaping (B2) -> A2,
        _ f2: @escaping (A1) -> B1)
        -> (Kind2<Self, A2, A1>) -> Kind2<Self, B2, B1>

    static func lmap<A2, A1, B2>(_ f: @escaping (B2) -> A2)
        -> (Kind2<Self, A2, A1>) -> Kind2<Self, B2, A1>

    static func rmap<A2, A1, B1>(_ f: @escaping (A1) -> B1)
        -> (Kind2<Self, A2, A1>) -> Kind2<Self, A2, B1>
}

extension ForProfunctor
{
    /// Default implementation.
    public static func dimap<A2, A1, B2, B1>(
        _ f1: @escaping (B2) -> A2,
        _ f2: @escaping (A1) -> B1
        ) -> (Kind2<Self, A2, A1>) -> Kind2<Self, B2, B1>
    {
        return { self.lmap(f1)(self.rmap(f2)($0)) }
    }

    /// Default implementation.
    public static func lmap<A2, A1, B2>(
        _ f: @escaping (B2) -> A2
        ) -> (Kind2<Self, A2, A1>) -> Kind2<Self, B2, A1>
    {
        return self.dimap(f, { $0 })
    }

    /// Default implementation.
    public static func rmap<A2, A1, B1>(
        _ f: @escaping (A1) -> B1
        ) -> (Kind2<Self, A2, A1>) -> Kind2<Self, A2, B1>
    {
        return self.dimap({ $0 }, f)
    }
}

// MARK: - Default implementation

extension Kind2: Profunctor where F2: ForProfunctor
{
    public func dimap<B2, B1>(
        _ f1: @escaping (B2) -> A2,
        _ f2: @escaping (A1) -> B1
        ) -> Kind2<F2, B2, B1>
    {
        return F2.dimap(f1, f2)(self)
    }

    public func lmap<B2>(_ f: @escaping (B2) -> A2) -> Kind2<F2, B2, A1>
    {
        return F2.lmap(f)(self)
    }

    public func rmap<B1>(_ f: @escaping (A1) -> B1) -> Kind2<F2, A2, B1>
    {
        return F2.rmap(f)(self)
    }
}

// MARK: - PseudoProfunctor

/// - Note:
/// Use this fancy protocol for true type-constructors.
public protocol PseudoProfunctor {}
