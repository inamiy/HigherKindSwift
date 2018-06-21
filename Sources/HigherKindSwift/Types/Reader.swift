// MARK: - Reader

public struct Reader<X, Y>
{
    public let run: (X) -> Y

    public init(_ run: @escaping (X) -> Y)
    {
        self.run = run
    }
}

extension Reader: Kind2Convertible
{
    public typealias F = ForReader
    public typealias A1 = X
    public typealias A2 = Y

    /// - Note: autogeneratable
    public init(kind2: Kind2<F, A1, A2>)
    {
        self = kind2._value as! Reader<A1, A2>
    }

    /// - Note: autogeneratable
    public var kind2: Kind2<F, A1, A2>
    {
        return Kind2(self as Any)
    }
}

/// - Note: autogeneratable
extension Reader: PseudoProfunctor
{
    public func dimap<B1, B2>(_ f1: @escaping (B1) -> A1, _ f2: @escaping (A2) -> B2) -> Reader<B1, B2>
    {
        return self.kind2.dimap(f1, f2).value
    }

    public func lmap<B1>(_ f: @escaping (B1) -> A1) -> Reader<B1, A2>
    {
        return self.kind2.lmap(f).value
    }

    public func rmap<B2>(_ f: @escaping (A2) -> B2) -> Reader<A1, B2>
    {
        return self.kind2.rmap(f).value
    }
}

// MARK: - ForReader

/// - Note: autogeneratable
public enum ForReader {}

/// - Note: autogeneratable
extension Kind2 where F == ForReader
{
    public var value: Reader<A1, A2>
    {
        return Reader(kind2: self)
    }
}

extension ForReader: ForProfunctor
{
    public static func lmap<A1, A2, B1>(_ f: @escaping (B1) -> A1) -> (Kind2<ForReader, A1, A2>) -> Kind2<ForReader, B1, A2>
    {
        return { kind2 in Reader { kind2.value.run(f($0)) }.kind2 }
    }

    public static func rmap<A1, A2, B2>(_ f: @escaping (A2) -> B2) -> (Kind2<ForReader, A1, A2>) -> Kind2<ForReader, A1, B2>
    {
        return { kind2 in Reader { f(kind2.value.run($0)) }.kind2 }
    }
}
