// MARK: - Either

public enum Either<L, R>
{
    case left(L)
    case right(R)
}

extension Either: Equatable where L: Equatable, R: Equatable {}

extension Either: Kind2Convertible
{
    public typealias F2 = ForEither
    public typealias A2 = L
    public typealias A1 = R

    /// - Note: autogeneratable
    public init(kind2: Kind2<F2, A2, A1>)
    {
        self = kind2._value as! Either<A2, A1>
    }

    /// - Note: autogeneratable
    public var kind2: Kind2<F2, A2, A1>
    {
        return Kind2(self)
    }
}

/// - Note: autogeneratable
extension Either: PseudoBifunctor
{
    public func first<B2>(_ f: @escaping (A2) -> B2) -> Either<B2, A1>
    {
        return F2.first(f)(self.kind2).value
    }

    public func second<B1>(_ f: @escaping (A1) -> B1) -> Either<A2, B1>
    {
        return F2.second(f)(self.kind2).value
    }
}

/// - Note: autogeneratable
extension Either: PseudoFunctor
{
    public func fmap<B>(_ f: @escaping (A1) -> B) -> Either<A2, B>
    {
        return Kind<ForEither, A2>.fmap(f)(self.kind).value
    }
}

/// - Note: autogeneratable
extension Either: PseudoApplicative
{
    public static func pure(_ value: A1) -> Either<A2, A1>
    {
        return Kind<ForEither, A2>.pure(value).value
    }

    public static func apply<B>(_ f: Either<A2, (A1) -> B>, _ a: Either<A2, A1>) -> Either<A2, B>
    {
        return Kind<ForEither, A2>.apply(f.kind, a.kind).value
    }
}

/// - Note: autogeneratable
extension Either: PseudoMonad
{
    public func bind<B>(_ f: @escaping (A1) -> Either<A2, B>) -> Either<A2, B>
    {
        return Kind<ForEither, A2>.bind({ f($0).kind })(self.kind).value
    }
}

// MARK: - ForEither

/// - Note: autogeneratable
public enum ForEither {}

/// - Note: autogeneratable
extension Kind2 where F2 == ForEither
{
    public var value: Either<A2, A1>
    {
        return Either(kind2: self)
    }
}

/// - Note: autogeneratable
extension Kind where F1: KindConvertible, F1.F1 == ForEither
{
    public var value: Either<F1.A1, A1>
    {
        return self._value as! Either<F1.A1, A1>
    }
}

// MARK: ForBifunctor

extension ForEither: ForBifunctor
{
    public static func bimap<A2, A1, B2, B1>(
        _ f1: @escaping (A2) -> B2,
        _ f2: @escaping (A1) -> B1
        ) -> (Kind2<ForEither, A2, A1>) -> Kind2<ForEither, B2, B1>
    {
        return { kind2 in
            switch kind2.value {
            case let .left(l):
                return Either<B2, B1>.left(f1(l)).kind2
            case let .right(r):
                return Either<B2, B1>.right(f2(r)).kind2
            }

        }
    }
}

// MARK: ForApplicative2

extension ForEither: ForApplicative2
{
    public static func pure<A2, A>(_ value: A) -> Kind<Kind<ForEither, A2>, A>
    {
        return Either<A2, A>.right(value).kind
    }

    public static func apply<A2, A, B>(
        _ f: Kind<Kind<ForEither, A2>, (A) -> B>,
        _ a: Kind<Kind<ForEither, A2>, A>
        ) -> Kind<Kind<ForEither, A2>, B>
    {
        switch f.value {
        case let .left(l):
            return Either<A2, B>.left(l).kind
        case let .right(r):
            switch a.value {
            case let .left(l2):
                return Either<A2, B>.left(l2).kind
            case let .right(r2):
                return Either<A2, B>.right(r(r2)).kind
            }
        }
    }
}

// MARK: ForMonad2

extension ForEither: ForMonad2
{
    public static func bind<A2, A, B>(
        _ f: @escaping (A) -> Kind<Kind<ForEither, A2>, B>
        ) -> (Kind<Kind<ForEither, A2>, A>) -> Kind<Kind<ForEither, A2>, B>
    {
        return { kind in
            switch kind.value {
            case let .left(l):
                return Either<A2, B>.left(l).kind
            case let .right(r):
                return f(r)
            }
        }
    }
}
