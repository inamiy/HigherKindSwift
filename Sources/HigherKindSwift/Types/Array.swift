// MARK: - Array

extension Array: KindConvertible
{
    public typealias F = ForArray
    public typealias A1 = Element

    /// - Note: autogeneratable
    public init(kind: Kind<F, A1>)
    {
        self = kind._value as! Array<A1>
    }

    /// - Note: autogeneratable
    public var kind: Kind<F, A1>
    {
        return Kind(self as Any)
    }
}

/// - Note: autogeneratable
extension Array: PseudoFunctor
{
    public func fmap<B>(_ f: @escaping (A1) -> B) -> Array<B>
    {
        return ForArray.fmap(f)(self.kind).value
    }
}

/// - Note: autogeneratable
extension Array: PseudoApplicative
{
    public static func pure<A>(_ value: A) -> Array<A>
    {
        return ForArray.pure(value).value
    }

    public static func apply<A, B>(_ f: Array<(A) -> B>, _ a: Array<A>) -> Array<B>
    {
        return ForArray.apply(f.kind, a.kind).value
    }
}

/// - Note: autogeneratable
extension Array: PseudoMonad
{
    public func bind<B>(_ f: @escaping (A1) -> Array<B>) -> Array<B>
    {
        return ForArray.bind({ f($0).kind })(self.kind).value
    }
}

// MARK: - ForArray

/// - Note: autogeneratable
public enum ForArray {}

/// - Note: autogeneratable
extension Kind where F == ForArray
{
    public var value: Array<A1>
    {
        return Array(kind: self)
    }
}

extension ForArray: ForFunctor
{
    public static func fmap<A, B>(_ f: @escaping (A) -> B) -> (Kind<ForArray, A>) -> Kind<ForArray, B>
    {
        return { $0.value.map(f).kind }
    }
}

extension ForArray: ForApplicative
{
    public static func pure<A>(_ value: A) -> Kind<ForArray, A>
    {
        return [value].kind
    }

    public static func apply<A, B>(_ f: Kind<ForArray, (A) -> B>, _ a: Kind<ForArray, A>) -> Kind<ForArray, B>
    {
        var arr = [B]()
        for f_ in f.value {
            for a_ in a.value {
                arr.append(f_(a_))
            }
        }
        return arr.kind
    }
}

extension ForArray: ForMonad
{
    public static func bind<A, B>(_ f: @escaping (A) -> Kind<ForArray, B>) -> (Kind<ForArray, A>) -> Kind<ForArray, B>
    {
        return { $0.value.flatMap { f($0).value }.kind }
    }
}
