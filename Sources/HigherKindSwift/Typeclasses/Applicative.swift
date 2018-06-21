// MARK: - Applicative

public protocol Applicative: Functor where F: ForApplicative
{
    static func pure<A>(_ value: A) -> Kind<F, A>
    static func apply<A, B>(_ f: Kind<F, (A) -> B>, _ a: Kind<F, A>) -> Kind<F, B>
}

// MARK: - ForApplicative

public protocol ForApplicative: ForFunctor
{
    static func pure<A>(_ value: A) -> Kind<Self, A>
    static func apply<A, B>(_ f: Kind<Self, (A) -> B>, _ a: Kind<Self, A>) -> Kind<Self, B>
}

extension Kind: Applicative where F: ForApplicative
{
    public static func pure<A>(_ value: A) -> Kind<F, A>
    {
        return F.pure(value)
    }

    public static func apply<A, B>(_ f: Kind<F, (A) -> B>, _ a: Kind<F, A>) -> Kind<F, B>
    {
        return F.apply(f, a)
    }
}

// MARK: - PseudoApplicative

/// - Note:
/// Use this fancy protocol for true type-constructors.
public protocol PseudoApplicative {}
