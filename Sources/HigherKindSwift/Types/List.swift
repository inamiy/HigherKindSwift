// MARK: - List

public indirect enum List<Element>
{
    case `nil`
    case cons(Element, List<Element>)

    static func + (l: List, r: List) -> List
    {
        switch (l, r) {
        case (.nil, _):
            return r
        case let (.cons(head1, tail1), _):
            return .cons(head1, tail1 + r)
        }
    }

    public init<S: Sequence>(_ sequence: S) where Element == S.Element
    {
        let arr = Array(sequence)

        var list = List<Element>.nil
        for a in arr.reversed() {
            list = .cons(a, list)
        }
        self = list
    }
}

extension List: Equatable where Element: Equatable {}

extension List: KindConvertible
{
    public typealias F = ForList
    public typealias A1 = Element

    /// - Note: autogeneratable
    public init(kind: Kind<F, A1>)
    {
        self = kind._value as! List<A1>
    }

    /// - Note: autogeneratable
    public var kind: Kind<F, A1>
    {
        return Kind(self as Any)
    }
}

/// - Note: autogeneratable
extension List: PseudoFunctor
{
    public func fmap<B>(_ f: @escaping (A1) -> B) -> List<B>
    {
        return ForList.fmap(f)(self.kind).value
    }
}

/// - Note: autogeneratable
extension List: PseudoApplicative
{
    public static func pure<A>(_ value: A) -> List<A>
    {
        return ForList.pure(value).value
    }

    public static func apply<A, B>(_ f: List<(A) -> B>, _ a: List<A>) -> List<B>
    {
        return ForList.apply(f.kind, a.kind).value
    }
}

/// - Note: autogeneratable
extension List: PseudoMonad
{
    public func bind<B>(_ f: @escaping (A1) -> List<B>) -> List<B>
    {
        return ForList.bind({ f($0).kind })(self.kind).value
    }
}

// MARK: - ForList

/// - Note: autogeneratable
public enum ForList {}

/// - Note: autogeneratable
extension Kind where F == ForList
{
    public var value: List<A1>
    {
        return List(kind: self)
    }
}

extension ForList: ForFunctor
{
    public static func fmap<A, B>(_ f: @escaping (A) -> B) -> (Kind<ForList, A>) -> Kind<ForList, B>
    {
        return { kind in
            switch kind.value {
            case .nil:
                return List<B>.nil.kind
            case let .cons(head, tail):
                return List<B>.cons(f(head), tail.kind.fmap(f).value).kind
            }
        }
    }
}

extension ForList: ForApplicative
{
    public static func pure<A>(_ value: A) -> Kind<ForList, A>
    {
        return List<A>.cons(value, .nil).kind
    }

    public static func apply<A, B>(_ f: Kind<ForList, (A) -> B>, _ a: Kind<ForList, A>) -> Kind<ForList, B>
    {
        switch (f.value, a.value) {
        case let (.cons(f, tail1), .cons(a, tail2)):
            return List<B>.cons(f(a), apply(tail1.kind, tail2.kind).value).kind
        default:
            return List<B>.nil.kind
        }
    }
}

extension ForList: ForMonad
{
    public static func bind<A, B>(_ f: @escaping (A) -> Kind<ForList, B>) -> (Kind<ForList, A>) -> Kind<ForList, B>
    {
        return { kind in
            switch kind.value {
            case .nil:
                return List<B>.nil.kind
            case let .cons(head, tail):
                return (f(head).value + tail.kind.bind(f).value).kind
            }
        }
    }
}
