// MARK: - Kind

/// `F` as `* -> *`.
public struct Kind<F: ForTypeConstructor, A1>
{
    internal let _value: Any

    public init(_ value: Any)
    {
        self._value = value
    }
}

extension Kind: KindConvertible
{
    public init(kind: Kind<F, A1>)
    {
        self = kind
    }

    public var kind: Kind<F, A1>
    {
        return self
    }
}

// MARK: - Kind2

/// `F` as `* -> * -> *`.
public struct Kind2<F: ForTypeConstructor2, A1, A2>
{
    internal let _value: Any

    public init(_ value: Any)
    {
        self._value = value
    }
}

extension Kind2: Kind2Convertible
{
    public init(kind2: Kind2<F, A1, A2>)
    {
        self = kind2
    }

    public var kind2: Kind2<F, A1, A2>
    {
        return self
    }
}
