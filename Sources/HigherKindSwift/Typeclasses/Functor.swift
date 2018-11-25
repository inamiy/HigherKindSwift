// MARK: - Functor

public protocol Functor
{
    associatedtype F1: ForFunctor
    associatedtype A1

    func fmap<B>(_ f: @escaping (A1) -> B) -> Kind<F1, B>
}

// MARK: - ForFunctor

public protocol ForFunctor
{
    static func fmap<A, B>(_ f: @escaping (A) -> B) -> (Kind<Self, A>) -> Kind<Self, B>
}

// MARK: - Default implementation

extension Kind: Functor where F1: ForFunctor
{
    // Default implementation.
    public func fmap<B>(_ f: @escaping (A1) -> B) -> Kind<F1, B>
    {
        return F1.fmap(f)(self)
    }
}

// MARK: - PseudoFunctor

/// - Note:
/// Use this fancy protocol for true type-constructors.
public protocol PseudoFunctor {}
