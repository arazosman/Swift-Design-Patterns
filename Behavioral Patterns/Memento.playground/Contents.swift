// MARK: Memento Pattern

import Foundation

/// Originator Class
class Shape {
    let name: String
    var width: Int = 0
    var height: Int = 0
    var color: String = "none"

    lazy var memento = ShapeMemento(shape: self)

    init(name: String) {
        self.name = name
    }

    func update(width: Int, height: Int, color: String) {
        self.width = width
        self.height = height
        self.color = color
    }

    func printInfo() {
        print("\(name): \(width) - \(height) - \(color)")
    }
}

/// State class of the originator
struct ShapeState {
    let width: Int
    let height: Int
    let color: String
}

/// Memento class of the originator
class ShapeMemento {
    let shape: Shape
    var states = [ShapeState]()
    var currentIndex = 0

    init(shape: Shape) {
        self.shape = shape
        states.append(newState)
    }

    private var currentState: ShapeState? {
        guard currentIndex >= 0 else { return nil }
        return states[currentIndex]
    }

    private var newState: ShapeState {
        return ShapeState(width: shape.width, height: shape.height, color: shape.color)
    }

    func applyState() {
        guard let currentState else { return }
        shape.width = currentState.width
        shape.height = currentState.height
        shape.color = currentState.color
    }

    func save() {
        removeUnusedStates()
        states.append(newState)
        currentIndex += 1
        applyState()
    }

    func undo() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        applyState()
    }

    func redo() {
        guard currentIndex < states.count - 1 else { return }
        currentIndex += 1
        applyState()
    }

    private func removeUnusedStates() {
        states.removeLast(states.count - currentIndex - 1)
    }
}

/// Caretaker class of the originator. We would use it if we need to cache values regularly.
class ShapeCaretaker {
    private var timer: Timer?
    let memento: ShapeMemento

    init(memento: ShapeMemento) {
        self.memento = memento
    }

    func start() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak memento] _ in
            memento?.save()
        })
    }
}

let shape = Shape(name: "Rectangle")
let memento = shape.memento

shape.printInfo()
shape.update(width: 10, height: 10, color: "red")
memento.save()
shape.printInfo()
memento.undo()
shape.printInfo()
memento.undo()
shape.printInfo()
memento.redo()
shape.printInfo()
shape.update(width: 20, height: 20, color: "green")
memento.save()
shape.printInfo()
shape.update(width: 30, height: 30, color: "blue")
memento.save()
shape.printInfo()
memento.undo()
shape.printInfo()
memento.undo()
shape.printInfo()
shape.update(width: 50, height: 50, color: "purple")
memento.save()
shape.printInfo()
memento.redo()
shape.printInfo()
memento.redo()
shape.printInfo()
