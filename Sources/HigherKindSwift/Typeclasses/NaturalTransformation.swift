// MARK: - NaturalTransformation

public protocol NaturalTransformation
{
    associatedtype F: ForFunctor
    associatedtype G: ForFunctor

    static func naturalTransform<A>(_ kind: Kind<F, A>) -> Kind<G, A>
}

// MARK: - Default implementation

extension Kind where F1: ForFunctor
{
    // Default implementation.
    public func naturalTransform<NT: NaturalTransformation>(_ transformation: NT.Type) -> Kind<NT.G, A1>
        where NT.F == F1
    {
        return NT.naturalTransform(self)
    }

    // Default implementation.
    public func naturalTransform<G: ForFunctor>(_ transform: (Kind<F1, A1>) -> Kind<G, A1>) -> Kind<G, A1>
    {
        return transform(self)
    }
}
