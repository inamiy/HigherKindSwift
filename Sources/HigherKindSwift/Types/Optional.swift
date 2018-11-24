// MARK: - Optional

extension Optional: KindConvertible
{
    public typealias F = ForOptional
    public typealias A1 = Wrapped

    /// - Note: autogeneratable
    public init(kind: Kind<F, A1>)
    {
//        self = kind._value as! Optional<A1>    // ERROR: Cannot downcast from 'Any' to a more optional type
        self = kind._value as? A1    // workaround
    }

    /// - Note: autogeneratable
    public var kind: Kind<F, A1>
    {
        return Kind(self as Any)
    }
}

/// - Note: autogeneratable
extension Optional: PseudoFunctor
{
    public func fmap<B>(_ f: @escaping (A1) -> B) -> Optional<B>
    {
        return ForOptional.fmap(f)(self.kind).value
    }
}

/// - Note: autogeneratable
extension Optional: PseudoApplicative
{
    public static func pure(_ value: A1) -> Optional<A1>
    {
        return ForOptional.pure(value).value
    }

    public static func apply<B>(_ f: Optional<(A1) -> B>, _ a: Optional<A1>) -> Optional<B>
    {
        return ForOptional.apply(f.kind, a.kind).value
    }
}

/// - Note: autogeneratable
extension Optional: PseudoMonad
{
    public func bind<B>(_ f: @escaping (A1) -> Optional<B>) -> Optional<B>
    {
        return ForOptional.bind({ f($0).kind })(self.kind).value
    }
}

// MARK: - ForOptional

/// - Note: autogeneratable
public enum ForOptional {}

/// - Note: autogeneratable
extension Kind where F1 == ForOptional
{
    public var value: Optional<A1>
    {
        return Optional(kind: self)
    }
}

extension ForOptional: ForFunctor
{
    public static func fmap<A, B>(_ f: @escaping (A) -> B) -> (Kind<ForOptional, A>) -> Kind<ForOptional, B>
    {
        return { $0.value.map(f).kind }
    }
}

extension ForOptional: ForApplicative
{
    public static func pure<A>(_ value: A) -> Kind<ForOptional, A>
    {
        return Optional<A>(value).kind
    }

    public static func apply<A, B>(
        _ f: Kind<ForOptional, (A) -> B>,
        _ a: Kind<ForOptional, A>
        ) -> Kind<ForOptional, B>
    {
        if let f = f.value, let a = a.value {
            return Optional(f(a)).kind
        }
        else {
            return Optional.none.kind
        }
    }
}

extension ForOptional: ForMonad
{
    public static func bind<A, B>(
        _ f: @escaping (A) -> Kind<ForOptional, B>
        ) -> (Kind<ForOptional, A>) -> Kind<ForOptional, B>
    {
        return { $0.value.flatMap { f($0).value }.kind }
    }
}
