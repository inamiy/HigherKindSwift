// MARK: - Reader

public struct Reader<X, Y>
{
    public let run: (X) -> Y

    public init(_ run: @escaping (X) -> Y)
    {
        self.run = run
    }
}

/// - Note: autogeneratable
extension Reader: Kind2Convertible
{
    public typealias F2 = ForReader
    public typealias A2 = X
    public typealias A1 = Y

    public init(kind2: Kind2<F2, A2, A1>)
    {
        self = kind2._value as! Reader<A2, A1>
    }

    public var kind2: Kind2<F2, A2, A1>
    {
        return Kind2(self as Any)
    }
}

// MARK: Pseudo protocol conformances

/// - Note: autogeneratable
extension Reader: PseudoProfunctor
{
    public func dimap<B2, B1>(_ f1: @escaping (B2) -> A2, _ f2: @escaping (A1) -> B1) -> Reader<B2, B1>
    {
        return self.kind2.dimap(f1, f2).value
    }

    public func lmap<B2>(_ f: @escaping (B2) -> A2) -> Reader<B2, A1>
    {
        return self.kind2.lmap(f).value
    }

    public func rmap<B1>(_ f: @escaping (A1) -> B1) -> Reader<A2, B1>
    {
        return self.kind2.rmap(f).value
    }
}

/// - Note: autogeneratable
extension Reader: PseudoFunctor
{
    public func fmap<B>(_ f: @escaping (A1) -> B) -> Reader<A2, B>
    {
        return Kind<ForReader, A2>.fmap(f)(self.kind).value
    }
}

/// - Note: autogeneratable
extension Reader: PseudoApplicative
{
    public static func pure(_ value: A1) -> Reader<A2, A1>
    {
        return Kind<ForReader, A2>.pure(value).value
    }

    public static func apply<B>(_ f: Reader<A2, (A1) -> B>, _ a: Reader<A2, A1>) -> Reader<A2, B>
    {
        return Kind<ForReader, A2>.apply(f.kind, a.kind).value
    }
}

/// - Note: autogeneratable
extension Reader: PseudoMonad
{
    public func bind<B>(_ f: @escaping (A1) -> Reader<A2, B>) -> Reader<A2, B>
    {
        return Kind<ForReader, A2>.bind({ f($0).kind })(self.kind).value
    }
}

// MARK: - ForReader

/// - Note: autogeneratable
public enum ForReader {}

/// - Note: autogeneratable
extension Kind2 where F2 == ForReader
{
    public var value: Reader<A2, A1>
    {
        return Reader(kind2: self)
    }
}

/// - Note: autogeneratable
extension Kind where F1: KindConvertible, F1.F1 == ForReader
{
    public var value: Reader<F1.A1, A1>
    {
        return self._value as! Reader<F1.A1, A1>
    }
}

// MARK: ForProfunctor

extension ForReader: ForProfunctor
{
    public static func dimap<A2, A1, B2, B1>(
        _ f1: @escaping (B2) -> A2,
        _ f2: @escaping (A1) -> B1
        ) -> (Kind2<ForReader, A2, A1>) -> Kind2<ForReader, B2, B1>
    {
        return { kind2 in Reader { f2(kind2.value.run(f1($0))) }.kind2 }
    }

    public static func lmap<A1, A2, B1>(
        _ f: @escaping (B1) -> A1
        ) -> (Kind2<ForReader, A1, A2>) -> Kind2<ForReader, B1, A2>
    {
        return { kind2 in Reader { kind2.value.run(f($0)) }.kind2 }
    }

    public static func rmap<A1, A2, B2>(
        _ f: @escaping (A2) -> B2
        ) -> (Kind2<ForReader, A1, A2>) -> Kind2<ForReader, A1, B2>
    {
        return { kind2 in Reader { f(kind2.value.run($0)) }.kind2 }
    }
}

// MARK: ForFunctor2

extension ForReader: ForFunctor2
{
    public static func fmap<A2, A, B>(
        _ f: @escaping (A) -> B
        ) -> (Kind<Kind<ForReader, A2>, A>) -> Kind<Kind<ForReader, A2>, B>
    {
        return { $0.value.kind2.rmap(f).kind }
    }
}

// MARK: ForApplicative2

extension ForReader: ForApplicative2
{
    public static func pure<A2, A>(_ value: A) -> Kind<Kind<ForReader, A2>, A>
    {
        return Reader<A2, A> { _ in value }.kind
    }

    public static func apply<A2, A, B>(
        _ f: Kind<Kind<ForReader, A2>, (A) -> B>,
        _ a: Kind<Kind<ForReader, A2>, A>
        ) -> Kind<Kind<ForReader, A2>, B>
    {
        return Reader<A2, B> { f.value.run($0)(a.value.run($0)) }.kind
    }
}

// MARK: ForMonad2

extension ForReader: ForMonad2
{
    public static func bind<A2, A, B>(
        _ f: @escaping (A) -> Kind<Kind<ForReader, A2>, B>
        ) -> (Kind<Kind<ForReader, A2>, A>) -> Kind<Kind<ForReader, A2>, B>
    {
        return { kind in
            return Reader<A2, B> { return f(kind.value.run($0)).value.run($0) }.kind
        }
    }
}
