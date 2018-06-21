// MARK: - MonadPlus

public protocol MonadPlus: Monad where F: ForMonadPlus
{
    static func mzero<A>() -> Kind<F, A>
    func mplus(_ kind: Kind<F, A1>) -> Kind<F, A1>
}

// MARK: - ForMonadPlus

public protocol ForMonadPlus: ForMonad
{
    static func mzero<A>() -> Kind<Self, A>
    static func mplus<A>(_ kind1: Kind<Self, A>, _ kind2: Kind<Self, A>) -> Kind<Self, A>
}

extension Kind: MonadPlus where F: ForMonadPlus
{
    public static func mzero<A>() -> Kind<F, A>
    {
        return F.mzero()
    }

    public func mplus(_ kind: Kind<F, A1>) -> Kind<F, A1>
    {
        return F.mplus(self, kind)
    }
}

// MARK: - PseudoMonadPlus

/// - Note:
/// Use this fancy protocol for true type-constructors.
public protocol PseudoMonadPlus {}
