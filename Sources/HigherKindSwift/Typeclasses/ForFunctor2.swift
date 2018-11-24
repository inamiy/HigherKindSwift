// IMPORTANT:
// This file defines `ForFunctor2`, `ForApplicative2`, `ForMonad2` to allow
// nested kinds e.g. `Kind<Kind<ForReader, A2>, A1>` work as Functor and so on.
// But due to Swift 4.2 limitation, **they must be bundled in one file,
// or compiler (with debug configuration) fails type checking for some reason**.
//
// NOTE:
// This problem can be avoided by `swift build -c release`.

// MARK: - ForFunctor2

/// `Functor` support for nested `Kind`s.
/// - Todo: Can we unify this with `ForFunctor`?
public protocol ForFunctor2
{
    static func fmap<A2, A, B>(_ f: @escaping (A) -> B) -> (Kind<Kind<Self, A2>, A>) -> Kind<Kind<Self, A2>, B>
}

extension Kind: ForFunctor where F1: ForFunctor2
{
    public static func fmap<A, B>(
        _ f: @escaping (A) -> B
        ) -> (Kind<Kind<F1, A1>, A>) -> Kind<Kind<F1, A1>, B>
    {
        return F1.fmap(f)
    }
}

// MARK: - ForApplicative2

/// `Applicative` support for nested `Kind`s.
/// - Todo: Can we unify this with `ForApplicative`?
public protocol ForApplicative2: ForFunctor2
{
    static func pure<A2, A>(_ value: A) -> Kind<Kind<Self, A2>, A>

    static func apply<A2, A, B>(
        _ f: Kind<Kind<Self, A2>, (A) -> B>,
        _ a: Kind<Kind<Self, A2>, A>
        ) -> Kind<Kind<Self, A2>, B>
}

extension Kind: ForApplicative where F1: ForApplicative2
{
    public static func pure<A>(_ value: A) -> Kind<Kind<F1, A1>, A>
    {
        return F1.pure(value)
    }

    public static func apply<A, B>(
        _ f: Kind<Kind<F1, A1>, (A) -> B>,
        _ a: Kind<Kind<F1, A1>, A>
        ) -> Kind<Kind<F1, A1>, B>
    {
        return F1.apply(f, a)
    }
}

// MARK: - ForMonad2

/// `Monad` support for nested `Kind`s.
/// - Todo: Can we unify this with `ForMonad`?
public protocol ForMonad2: ForApplicative2
{
    static func bind<A2, A, B>(
        _ f: @escaping (A) -> Kind<Kind<Self, A2>, B>
        ) -> (Kind<Kind<Self, A2>, A>) -> Kind<Kind<Self, A2>, B>
}

extension Kind: ForMonad where F1: ForMonad2
{
    public static func bind<A, B>(
        _ f: @escaping (A) -> Kind<Kind<F1, A1>, B>
        ) -> (Kind<Kind<F1, A1>, A>) -> Kind<Kind<F1, A1>, B>
    {
        return F1.bind(f)
    }
}
