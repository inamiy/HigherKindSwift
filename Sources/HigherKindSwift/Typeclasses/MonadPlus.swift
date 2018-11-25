// MARK: - MonadPlus

public protocol MonadPlus: Monad where F1: ForMonadPlus
{
    static func mzero<A>() -> Kind<F1, A>
    func mplus(_ kind: Kind<F1, A1>) -> Kind<F1, A1>
}

// MARK: - ForMonadPlus

public protocol ForMonadPlus: ForMonad
{
    static func mzero<A>() -> Kind<Self, A>
    static func mplus<A>(_ kind1: Kind<Self, A>, _ kind2: Kind<Self, A>) -> Kind<Self, A>
}

// MARK: - Default implementation

extension Kind: MonadPlus where F1: ForMonadPlus
{
    public static func mzero<A>() -> Kind<F1, A>
    {
        return F1.mzero()
    }

    public func mplus(_ kind: Kind<F1, A1>) -> Kind<F1, A1>
    {
        return F1.mplus(self, kind)
    }
}

// MARK: - PseudoMonadPlus

/// - Note:
/// Use this fancy protocol for true type-constructors.
public protocol PseudoMonadPlus {}
