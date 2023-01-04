// MARK: Graphic Example Classes

protocol Graphic {
    func draw()
    func erase()
}

protocol GraphicObject: Graphic {
    var name: String { get }
    var color: String { get }
}

class Circle: GraphicObject {
    let name: String
    let color: String

    init(name: String, color: String) {
        self.name = name
        self.color = color
    }

    func draw() {
        print("Drawing circle...")
    }

    func erase() {
        print("Erasing circle...")
    }
}

class Rectangle: GraphicObject {
    let name: String
    let color: String

    init(name: String, color: String) {
        self.name = name
        self.color = color
    }

    func draw() {
        print("Drawing rectangle...")
    }

    func erase() {
        print("Erasing rectangle...")
    }
}

// MARK: Composite Canvas Class:

protocol ICanvas {
    var graphics: [Graphic] { get }
    func addGraphic(graphic: some Graphic)
    func removeGraphic(graphic: some Graphic)
}

class Canvas: Graphic, ICanvas {
    var graphics = [Graphic]()

    func addGraphic(graphic: some Graphic) {
        graphics.append(graphic)
    }

    func removeGraphic(graphic: some Graphic) {
        // ...
    }

    func draw() {
        for graphic in graphics {
            graphic.draw()
        }
    }

    func erase() {
        for graphic in graphics {
            graphic.erase()
        }
    }
}

// MARK: Storage Structure Example Classes

protocol Storage {
    var name: String { get set }
    func save()
    func delete()
    func move()
}

protocol StorageElement: Storage {
    var _extension: String { get }
}

class File: StorageElement {
    var name: String
    let _extension: String

    init(name: String, _extension: String) {
        self.name = name
        self._extension = _extension
    }

    func save() {
        print("Saving file: \(name).\(_extension)")
    }

    func delete() {
        print("Deleting file: \(name).\(_extension)")
    }

    func move() {
        print("Moving file: \(name).\(_extension)")
    }
}

class Alias: StorageElement {
    var name: String
    let _extension: String

    init(name: String, _extension: String) {
        self.name = name
        self._extension = _extension
    }

    func save() {
        print("Saving alias: \(name).\(_extension)")
    }

    func delete() {
        print("Deleting alias: \(name).\(_extension)")
    }

    func move() {
        print("Moving alias: \(name).\(_extension)")
    }
}

// MARK: Composite Directory Class:

protocol StorageContainer: Storage {
    var storages: [Storage] { get }
    func addStorage(storage: Storage)
    func deleteStorage(storage: Storage)
}

class Directory: StorageContainer {
    var name: String
    var storages = [Storage]()

    init(name: String) {
        self.name = name
    }

    func addStorage(storage: Storage) {
        storages.append(storage)
    }
    
    func deleteStorage(storage: Storage) {
        // ...
    }

    func save() {
        print("Saving directory: \(name)")

        for storage in storages {
            storage.save()
        }
    }
    
    func delete() {
        print("Deleting directory: \(name)")

        for storage in storages {
            storage.delete()
        }
    }

    func move() {
        print("Saving directory: \(name)")

        for storage in storages {
            storage.move()
        }
    }
}

// MARK: Examples:

var rootDirectory = Directory(name: "Desktop")

let readMeFile = File(name: "readme", _extension: "md")
rootDirectory.addStorage(storage: readMeFile)

let subDirectory = Directory(name: "Downloads")
rootDirectory.addStorage(storage: subDirectory)

let imageFile = File(name: "image", _extension: "png")
subDirectory.addStorage(storage: imageFile)

let musicFile = File(name: "music", _extension: "mp3")
subDirectory.addStorage(storage: musicFile)

let alias = File(name: "alias", _extension: "txt")
subDirectory.addStorage(storage: alias)

rootDirectory.save()
print("----")
subDirectory.delete()

// MARK: Manager - Employee Classes

protocol Employee {
    var name: String { get }
    var salary: Int { get set }
    var bonus: Int { get set }
    func work()
    func resign()
    func pay()
}

class Slave: Employee {
    let name: String
    var salary: Int
    var bonus: Int
    var manager: Manager?

    init(name: String, salary: Int, bonus: Int = 0) {
        self.name = name
        self.salary = salary
        self.bonus = bonus
    }

    func work() {
        print("Slave (\(name)) is working.")
    }

    func resign() {
        print("Slave (\(name)) has resigned.")
    }

    func pay() {
        let payment = salary + bonus
        print("Slave (\(name)) payment is: \(payment)")
    }
}

class Manager: Employee {
    var slaves = [Slave]()
    let name: String
    var salary: Int
    var bonus: Int

    init(name: String, salary: Int, bonus: Int) {
        self.name = name
        self.salary = salary
        self.bonus = bonus
    }

    func addSlave(slave: Slave) {
        slaves.append(slave)
    }

    func work() {
        print("Manager (\(name)) whips his slaves to make them work.")

        for slave in slaves {
            slave.work()
        }
    }

    func resign() {
        print("Manager (\(name)) has resigned.")
    }

    func pay() {
        var totalBonus = 0

        for slave in slaves {
            totalBonus += 10 * slave.bonus
        }

        let payment = salary + totalBonus

        print("Manager (\(name)) payment is: \(payment)")
    }
}

let manager = Manager(name: "Haldun", salary: 1000, bonus: 1000)
let slave1 = Slave(name: "Ali", salary: 10, bonus: 1)
let slave2 = Slave(name: "Veli", salary: 15, bonus: 1)
let slave3 = Slave(name: "Ayşe", salary: 12, bonus: 1)
[slave1, slave2, slave3].forEach { manager.addSlave(slave: $0) }

manager.work()
manager.pay()
slave1.pay()
slave2.pay()
slave3.pay()
slave1.resign()
manager.resign()
