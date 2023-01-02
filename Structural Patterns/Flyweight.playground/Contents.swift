// MARK: Classes

struct Point {
    let x: Int
    let y: Int
    
    static let zero = Point(x: 0, y: 0)

    static var random: Point {
        Point(
            x: Int.random(in: 0 ..< 10),
            y: Int.random(in: 0 ..< 10)
        )
    }

    var text: String {
        return "(\(x), \(y))"
    }
}

enum Color: String {
    case red
    case green
    case blue

    static var random: Color {
        switch Int.random(in: 0 ..< 3) {
        case 0:
            return .red
        case 1:
            return .green
        case 2:
            return .blue
        default:
            return .blue
        }
    }
}

class Circle {
    // Intrinsic states (immutable)
    let color: Color

    // Extrinsic states (mutable)
    var center: Point
    var radius: Int

    init(color: Color, center: Point, radius: Int) {
        self.color = color
        self.center = center
        self.radius = radius
    }

    func printInfo() {
        print("\(color.rawValue) (\(ObjectIdentifier(self))) - \(center.text) - \(radius)")
    }
}

// Flyweight pattern is used for optimization when there are lots of objects for
// one class. We would create an object pool of some prototypes, and then use
// these protoypes for all the instances needed.
// We usually use Factory Method and Prototype patterns with Flyweight pattern.

enum CirclePrototypes {
    static var redPrototype = Circle(color: .red, center: .zero, radius: 0)
    static var greenPrototype = Circle(color: .green, center: .zero, radius: 0)
    static var bluePrototype = Circle(color: .blue, center: .zero, radius: 0)

    static func getPrototype(for color: Color) -> Circle {
        switch color {
        case .red:
            return redPrototype
        case .green:
            return greenPrototype
        case .blue:
            return bluePrototype
        }
    }
}

protocol CircleFactory {
    func create() -> Circle
}

class CircleFactoryImpl: CircleFactory {
    func create() -> Circle {
        return getRandomCircle()
    }

    private func getRandomCircle() -> Circle {
        var circle = CirclePrototypes.getPrototype(for: Color.random)
        circle.center = Point.random
        circle.radius = Int.random(in: 0 ..< 100)
        return circle
    }
}

let factory = CircleFactoryImpl()

// We only have 3 real objects.
for _ in 0 ..< 100 {
    let circle = factory.create()
    circle.printInfo()
}
