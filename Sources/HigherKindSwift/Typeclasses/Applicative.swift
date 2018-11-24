// MARK: - Applicative

public protocol Applicative: Functor where F1: ForApplicative
{
    static func pure(_ value: A1) -> Kind<F1, A1>
    static func apply<B>(_ f: Kind<F1, (A1) -> B>, _ a: Kind<F1, A1>) -> Kind<F1, B>
}

// MARK: - ForApplicative

public protocol ForApplicative: ForFunctor
{
    static func pure<A>(_ value: A) -> Kind<Self, A>
    static func apply<A, B>(_ f: Kind<Self, (A) -> B>, _ a: Kind<Self, A>) -> Kind<Self, B>
}

// MARK: - Default implementation

extension Kind: Applicative where F1: ForApplicative
{
    // Default implementation.
    public static func pure(_ value: A1) -> Kind<F1, A1>
    {
        return F1.pure(value)
    }

    // Default implementation.
    public static func apply<B>(_ f: Kind<F1, (A1) -> B>, _ a: Kind<F1, A1>) -> Kind<F1, B>
    {
        return F1.apply(f, a)
    }
}

/// - Note:
/// Use this fancy protocol for true type-constructors.
public protocol PseudoApplicative {}
