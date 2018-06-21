# HigherKindSwift

An experimental [Higher Kinded Types](https://en.wikipedia.org/wiki/Kind_(type_theory)) in Swift, originally from the paper: [Lightweight Higher-Kinded Polymorphism][flops-2014-paper].

## Examples

### Monad

```swift
let arr = [1, 2, 3].kind
                 .bind { [$0 * 3, $0 * 5 ].kind }.value

arr == [3, 5, 6, 10, 9, 15]


let list = List<Int>.cons(1, .cons(2, .cons(3, .nil))).kind
               .bind { List.cons($0 * 3, .cons($0 * 5, .nil)).kind }
               .value

list == List.cons(3, .cons(5, .cons(6,
                  .cons(10, .cons(9, .cons(15, .nil))))))
```

### Natural Transformation

```swift
let list = [1, 2, 3].kind
               .naturalTransform {
                    List($0.value).kind
                }
               .value

list == List.cons(1, .cons(2, .cons(3, .nil)))
```

## References

- [Lightweight Higher-Kinded Polymorphism][flops-2014-paper]
- [Emulating HKT in Swift](https://gist.github.com/anandabits/f12a77c49fc002cf68a5f1f62a0ac9c4)
- [arrow-kt/arrow](https://github.com/arrow-kt/arrow)
- [ocamllabs/higher](https://github.com/ocamllabs/higher/)
- In Japanese
    - [SwiftでHigher Kinded Polymorphismを実現する \- Qiita](https://qiita.com/yyu/items/4f9925f3c211b7de6b32)
    - [RustのHigher\-Kinded type Trait \| κeenのHappy Hacκing Blog](http://keens.github.io/blog/2016/02/28/rustnohigherkinded_type_trait/)

[flops-2014-paper]: https://ocamllabs.github.io/higher/lightweight-higher-kinded-polymorphism.pdf

## License

[MIT](LICENSE)
