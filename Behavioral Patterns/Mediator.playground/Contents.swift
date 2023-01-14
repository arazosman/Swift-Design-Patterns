// MARK: Mediator Pattern
// We use the mediator pattern when there are lots of objects of a class
// communicate with each other to minimize the complexity. Mediator
// class would be the mediator between these objects. It translates
// Many-to-many relations to one-to-many.

// MARK: Traffic Example

protocol Vehicle {
    var name: String { get }
    var mediator: TrafficMediator { get }
    func go()
    func stop()
    func wait()
}

class Car: Vehicle {
    let name: String
    let mediator: TrafficMediator

    init(name: String, mediator: TrafficMediator) {
        self.name = name
        self.mediator = mediator
        mediator.receive(vehicle: self)
    }

    func enterToJunction() {
        mediator.askPermit(vehicle: self)
    }

    func go() {
        print("\(name) is going.")

        Task {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            mediator.done(vehicle: self)
        }
    }

    func stop() {
        print("\(name) has stopped.")
    }

    func wait() {
        print("\(name) is waiting.")

        Task {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            mediator.askPermit(vehicle: self)
        }
    }
}

class Junction {
    var isAvaliable = true
}

protocol TrafficMediator {
    var vehicles: [Vehicle] { get }
    var junction: Junction { get }
    init(junction: Junction)
    func receive(vehicle: Vehicle)
    func askPermit(vehicle: Vehicle)
    func done(vehicle: Vehicle)
}

final class TrafficPolice: TrafficMediator {
    var vehicles = [Vehicle]()

    let junction: Junction

    init(junction: Junction) {
        self.junction = junction
    }

    func receive(vehicle: Vehicle) {
        print("\(vehicle.name) added.")
        vehicles.append(vehicle)
        vehicle.stop()
    }

    func askPermit(vehicle: Vehicle) {
        print("\(vehicle.name) asked permission to pass.")

        if junction.isAvaliable {
            junction.isAvaliable = false
            vehicle.go()
        } else {
            vehicle.wait()
        }
    }

    func done(vehicle: Vehicle) {
        vehicles.removeAll(where: { $0.name == vehicle.name })
        junction.isAvaliable = true
    }
}

let junction = Junction()
let mediator = TrafficPolice(junction: junction)
let porche = Car(name: "Porche", mediator: mediator)
let ferrari = Car(name: "Ferrari", mediator: mediator)
let mercedes = Car(name: "Mercedes", mediator: mediator)
let mclaren = Car(name: "McLaren", mediator: mediator)
let renault = Car(name: "Renault", mediator: mediator)

[porche, ferrari, mercedes, mclaren, renault].forEach { $0.enterToJunction() }

// MARK: GUI Form Example

protocol Widget {
    var mediator: GUIMediator { get }
    func changed()
    func redraw()
}

class TextField: Widget {
    let mediator: GUIMediator

    init(mediator: GUIMediator) {
        self.mediator = mediator
    }

    func changed() {
        mediator.widgetUpdated(widget: self)
    }
    
    func redraw() {
        // ..
    }
}

class Slider: Widget {
    let mediator: GUIMediator

    init(mediator: GUIMediator) {
        self.mediator = mediator
    }

    func changed() {
        mediator.widgetUpdated(widget: self)
    }

    func redraw() {
        // ..
    }
}

protocol GUIMediator {
    var widgets: [Widget] { get }
    func widgetUpdated(widget: Widget)
}

class GUIMediatorImpl: GUIMediator {
    var widgets = [Widget]()

    func widgetUpdated(widget: Widget) {
        for widget in widgets {
            widget.redraw()
        }
    }
}
