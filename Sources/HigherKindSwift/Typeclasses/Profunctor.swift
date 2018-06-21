// MARK: - Profunctor

public protocol Profunctor
{
    associatedtype F: ForProfunctor
    associatedtype A1
    associatedtype A2

    func dimap<B1, B2>(_ f1: @escaping (B1) -> A1, _ f2: @escaping (A2) -> B2) -> Kind2<F, B1, B2>
    func lmap<B1>(_ f: @escaping (B1) -> A1) -> Kind2<F, B1, A2>
    func rmap<B2>(_ f: @escaping (A2) -> B2) -> Kind2<F, A1, B2>
}

// MARK: - ForProfunctor

/// - Minimal: dimap | lmap, rmap
public protocol ForProfunctor: ForTypeConstructor2
{
    static func dimap<A1, A2, B1, B2>(_ f1: @escaping (B1) -> A1, _ f2: @escaping (A2) -> B2) -> (Kind2<Self, A1, A2>) -> Kind2<Self, B1, B2>
    static func lmap<A1, A2, B1>(_ f: @escaping (B1) -> A1) -> (Kind2<Self, A1, A2>) -> Kind2<Self, B1, A2>
    static func rmap<A1, A2, B2>(_ f: @escaping (A2) -> B2) -> (Kind2<Self, A1, A2>) -> Kind2<Self, A1, B2>
}

extension ForProfunctor
{
    /// Default implementation.
    public static func dimap<A1, A2, B1, B2>(_ f1: @escaping (B1) -> A1, _ f2: @escaping (A2) -> B2) -> (Kind2<Self, A1, A2>) -> Kind2<Self, B1, B2>
    {
        return { $0.rmap(f2).lmap(f1) }
    }

    /// Default implementation.
    public static func lmap<A1, A2, B1>(_ f: @escaping (B1) -> A1) -> (Kind2<Self, A1, A2>) -> Kind2<Self, B1, A2>
    {
        return self.dimap(f, { $0 })
    }

    /// Default implementation.
    public static func rmap<A1, A2, B2>(_ f: @escaping (A2) -> B2) -> (Kind2<Self, A1, A2>) -> Kind2<Self, A1, B2>
    {
        return self.dimap({ $0 }, f)
    }
}

extension Kind2: Profunctor where F: ForProfunctor
{
    public func dimap<B1, B2>(_ f1: @escaping (B1) -> A1, _ f2: @escaping (A2) -> B2) -> Kind2<F, B1, B2>
    {
        return F.dimap(f1, f2)(self)
    }

    public func lmap<B1>(_ f: @escaping (B1) -> A1) -> Kind2<F, B1, A2>
    {
        return F.lmap(f)(self)
    }

    public func rmap<B2>(_ f: @escaping (A2) -> B2) -> Kind2<F, A1, B2>
    {
        return F.rmap(f)(self)
    }
}

// MARK: - PseudoProfunctor

/// - Note:
/// Use this fancy protocol for true type-constructors.
public protocol PseudoProfunctor {}
