// MARK: - NaturalTransformation

public protocol NaturalTransformation
{
    associatedtype F: ForFunctor
    associatedtype G: ForFunctor

    static func naturalTransform<A>(_ kind: Kind<F, A>) -> Kind<G, A>
}

extension Kind where F: ForFunctor
{
    public func naturalTransform<NT: NaturalTransformation>(_ transformation: NT.Type) -> Kind<NT.G, A1>
        where NT.F == F
    {
        return NT.naturalTransform(self)
    }

    public func naturalTransform<G: ForFunctor>(_ transform: (Kind<F, A1>) -> Kind<G, A1>) -> Kind<G, A1>
    {
        return transform(self)
    }
}
