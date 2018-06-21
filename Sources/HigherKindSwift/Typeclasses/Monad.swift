// MARK: - Monad

public protocol Monad: Applicative where F: ForMonad
{
    func bind<B>(_ f: @escaping (A1) -> Kind<F, B>) -> Kind<F, B>
}

// MARK: - ForMonad

public protocol ForMonad: ForApplicative
{
    static func bind<A, B>(_ f: @escaping (A) -> Kind<Self, B>) -> (Kind<Self, A>) -> Kind<Self, B>
}

extension Kind: Monad where F: ForMonad
{
    public static func pure<A>(_ value: A) -> Kind<F, A>
    {
        return F.pure(value)
    }

    public func bind<B>(_ f: @escaping (A1) -> Kind<F, B>) -> Kind<F, B>
    {
        return F.bind(f)(self)
    }
}

// MARK: - PseudoMonad

/// - Note:
/// Use this fancy protocol for true type-constructors.
public protocol PseudoMonad {}
