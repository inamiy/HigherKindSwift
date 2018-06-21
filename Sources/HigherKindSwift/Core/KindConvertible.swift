public protocol KindConvertible
{
    associatedtype F: ForTypeConstructor
    associatedtype A1

    init(kind: Kind<F, A1>)

    var kind: Kind<F, A1> { get }
}

public protocol Kind2Convertible
{
    associatedtype F: ForTypeConstructor2
    associatedtype A1
    associatedtype A2

    init(kind2: Kind2<F, A1, A2>)

    var kind2: Kind2<F, A1, A2> { get }
}
