// Classes

protocol Component {
    func paint()
}

class Button: Component {
    let text: String

    init(text: String) {
        self.text = text
    }

    func paint() {
        print("Painted a button with text '\(text)'.")
    }
}

class Image: Component {
    let width: Int

    init(width: Int) {
        self.width = width
    }

    func paint() {
        print("Painted an image with width \(width).")
    }
}

// MARK: Abstract Factory Class:
// We can use abstract factory pattern for related/dependent classes.
// It violates the OCP. But since it creates related classes, we consider
// that it does not violate SRP and cohesion.

protocol ComponentFactory { // Abstract factory class
    func createButton(text: String) -> Component // Factory method
    func createImage(width: Int) -> Component // Factory method
}

class ComponentFactoryImpl: ComponentFactory {
    func createButton(text: String) -> Component {
        return Button(text: text)
    }

    func createImage(width: Int) -> Component {
        return Image(width: width)
    }
}

let factory = ComponentFactoryImpl()
let button = factory.createButton(text: "Example text")
let image = factory.createImage(width: 512)

button.paint()
image.paint()

// MARK: Abstract Factory Class for multiple platforms:

class iOSButton: Button { }

class AndroidButton: Button { }

class iOSImage: Image { }

class AndroidImage: Image { }

class iOSComponentFactory: ComponentFactory {
    func createButton(text: String) -> Component {
        return iOSButton(text: text)
    }

    func createImage(width: Int) -> Component {
        return iOSImage(width: width)
    }
}

class AndroidComponentFactory: ComponentFactory {
    func createButton(text: String) -> Component {
        return AndroidButton(text: text)
    }

    func createImage(width: Int) -> Component {
        return AndroidImage(width: width)
    }
}

// MARK: Abstract Factory Class with different types:

class Course { }

class Teacher { }

protocol UniversityFactory {
    func createCourse() -> Course
    func createTeacher() -> Teacher
}
