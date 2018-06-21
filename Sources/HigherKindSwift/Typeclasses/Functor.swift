// MARK: - Functor

public protocol Functor
{
    associatedtype F: ForFunctor
    associatedtype A1

    func fmap<B>(_ f: @escaping (A1) -> B) -> Kind<F, B>
}

// MARK: - ForFunctor

public protocol ForFunctor: ForTypeConstructor
{
    static func fmap<A, B>(_ f: @escaping (A) -> B) -> (Kind<Self, A>) -> Kind<Self, B>
}

extension Kind: Functor where F: ForFunctor
{
    public func fmap<B>(_ f: @escaping (A1) -> B) -> Kind<F, B>
    {
        return F.fmap(f)(self)
    }
}

// MARK: - PseudoFunctor

/// - Note:
/// Use this fancy protocol for true type-constructors.
public protocol PseudoFunctor {}
