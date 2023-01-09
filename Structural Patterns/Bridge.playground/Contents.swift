// MARK: Using inheritance (is-a relation):

protocol BadShape {
    var name: String { get }
    init(name: String)
    func draw()
    func erase()
}

protocol CircleBad: BadShape { }

protocol RectangleBad: BadShape { }

final class CircleOSX: CircleBad {
    let name: String

    init(name: String) {
        self.name = name
    }
    
    func draw() { /* ... */ }
    
    func erase() { /* ... */ }
}

final class CircleWindowsBad: CircleBad {
    let name: String

    init(name: String) {
        self.name = name
    }
    
    func draw() { /* ... */ }
    
    func erase() { /* ... */ }
}

final class RectangleOSXBad: CircleBad {
    let name: String

    init(name: String) {
        self.name = name
    }
    
    func draw() { /* ... */ }
    
    func erase() { /* ... */ }
}

final class RectangleWindowsBad: CircleBad {
    let name: String

    init(name: String) {
        self.name = name
    }
    
    func draw() { /* ... */ }
    
    func erase() { /* ... */ }
}

// MARK: Bridge Pattern
// This pattern separates abstraction and implementation. Thus, they can
// be developed independently of each other.
// 2nd rule of GOF indicates that we should prefer object composition
// (has-a relationship) over inheritance (is-a relationship) whenever
// possible. It is because when there is a change in the upper class,
// it will propogate through its subclasses. On contrast, has-a relation-
// ship does not have such a problem. The Bridge pattern, transforms
// the inheritance to the object composition.
// For example, we use this pattern when sub-classes have different
// platform dependencies.
// It increases the complexity in change of more flexibility.

protocol Shape {
    var name: String { get }
    var implementor: ShapeImplementor { get }
    init(name: String, implementor: ShapeImplementor)
    func draw()
    func erase()
}

final class CircleBridge: Shape {
    let name: String
    let implementor: ShapeImplementor

    init(name: String, implementor: ShapeImplementor) {
        self.name = name
        self.implementor = implementor
    }

    func draw() {
        implementor.draw()
    }
    
    func erase() {
        implementor.erase()
    }
}

final class RectangleBridge: Shape {
    let name: String
    let implementor: ShapeImplementor

    init(name: String, implementor: ShapeImplementor) {
        self.name = name
        self.implementor = implementor
    }

    func draw() {
        implementor.draw()
    }
    
    func erase() {
        implementor.erase()
    }
}

protocol ShapeImplementor {
    func draw()
    func erase()
}

protocol CircleImplementor: ShapeImplementor { }

protocol RectangleImplementor: ShapeImplementor { }

final class CircleImplementorOSX: CircleImplementor {
    func draw() { /* ... */ }

    func erase() { /* ... */ }
}

final class CircleImplementorWindows: CircleImplementor {
    func draw() { /* ... */ }

    func erase() { /* ... */ }
}

final class RectangleImplementorOSX: RectangleImplementor {
    func draw() { /* ... */ }

    func erase() { /* ... */ }
}

final class RectangleImplementorWindows: RectangleImplementor {
    func draw() { /* ... */ }

    func erase() { /* ... */ }
}
