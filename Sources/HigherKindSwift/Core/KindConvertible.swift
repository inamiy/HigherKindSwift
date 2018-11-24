public protocol KindConvertible
{
    associatedtype F1
    associatedtype A1

    init(kind: Kind<F1, A1>)

    var kind: Kind<F1, A1> { get }
}

public protocol Kind2Convertible: KindConvertible where F1 == Kind<F2, A2>
{
    associatedtype F2
    associatedtype A2

    init(kind2: Kind2<F2, A2, A1>)

    var kind2: Kind2<F2, A2, A1> { get }
}

// MARK: - Default implementation

extension Kind2Convertible
{
    // Default implementation.
    public init(kind: Kind<F1, A1>)
    {
        self.init(kind2: Kind2.init(kind._value))
    }

    // Default implementation.
    public var kind: Kind<F1, A1>
    {
        return Kind(self.kind2._value)
    }
}
