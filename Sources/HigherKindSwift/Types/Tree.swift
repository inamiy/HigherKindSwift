// MARK: - Tree

public indirect enum Tree<Element>
{
    case leaf
    case node(_ left: Tree<Element>, _ element: Element, _ right: Tree<Element>)
}

extension Tree: CustomStringConvertible
{
    public var description: String
    {
        switch self {
        case .leaf:
            return "L"
        case let .node(l, a, r):
            return "N(\(l.description), \(a), \(r.description))"
        }
    }
}

extension Tree: Equatable where Element: Equatable
{
    public static func == (l: Tree, r: Tree) -> Bool
    {
        switch (l, r) {
        case (.leaf, .leaf):
            return true
        case let (.node(l1, a1, r1), .node(l2, a2, r2)):
            return a1 == a2 && l1 == l2 && r1 == r2
        default:
            return false
        }
    }
}

// MARK: - Tree

extension Tree: KindConvertible
{
    public typealias F = ForTree
    public typealias A1 = Element

    /// - Note: autogeneratable
    public init(kind: Kind<F, A1>)
    {
        self = kind._value as! Tree<A1>
    }

    /// - Note: autogeneratable
    public var kind: Kind<F, A1>
    {
        return Kind(self as Any)
    }
}

/// - Note: autogeneratable
extension Tree: PseudoFunctor
{
    public func fmap<B>(_ f: @escaping (A1) -> B) -> Tree<B>
    {
        return ForTree.fmap(f)(self.kind).value
    }
}

// MARK: - ForTree

/// - Note: autogeneratable
public enum ForTree {}

/// - Note: autogeneratable
extension Kind where F1 == ForTree
{
    public var value: Tree<A1>
    {
        return Tree(kind: self)
    }
}

extension ForTree: ForFunctor
{
    public static func fmap<A, B>(_ f: @escaping (A) -> B) -> (Kind<ForTree, A>) -> Kind<ForTree, B>
    {
        func _loop<A, B>(_ x: Tree<A>, _ f: (A) -> B) -> Tree<B>
        {
            switch x {
            case .leaf:
                return .leaf
            case let .node(l, a, r):
                return Tree<B>.node(_loop(l, f), f(a), _loop(r, f))
            }
        }

        return { _loop($0.value, f).kind }
    }
}
