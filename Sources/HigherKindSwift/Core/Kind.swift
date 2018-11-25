// MARK: - Kind

/// `F` as `* -> *`.
public struct Kind<F1, A1>
{
    internal let _value: Any

    public init(_ value: Any)
    {
        self._value = value
    }
}

extension Kind: KindConvertible
{
    public init(kind: Kind<F1, A1>)
    {
        self = kind
    }

    public var kind: Kind<F1, A1>
    {
        return self
    }
}

// MARK: - Kind2

/// `F` as `* -> * -> *`.
public struct Kind2<F2, A2, A1>
{
    internal let _value: Any

    public init(_ value: Any)
    {
        self._value = value
    }
}

extension Kind2: Kind2Convertible
{
    public init(kind2: Kind2<F2, A2, A1>)
    {
        self = kind2
    }

    public var kind2: Kind2<F2, A2, A1>
    {
        return self
    }
}
