// MARK: - Monad

public protocol Monad: Applicative where F1: ForMonad
{
    func bind<B>(_ f: @escaping (A1) -> Kind<F1, B>) -> Kind<F1, B>
}

// MARK: - ForMonad

public protocol ForMonad: ForApplicative
{
    static func bind<A, B>(_ f: @escaping (A) -> Kind<Self, B>) -> (Kind<Self, A>) -> Kind<Self, B>
}

// MARK: - Default implementation

extension Kind: Monad where F1: ForMonad
{
    // Default implementation.
    public func bind<B>(_ f: @escaping (A1) -> Kind<F1, B>) -> Kind<F1, B>
    {
        return F1.bind(f)(self)
    }
}

// MARK: - PseudoMonad

/// - Note:
/// Use this fancy protocol for true type-constructors.
public protocol PseudoMonad {}
