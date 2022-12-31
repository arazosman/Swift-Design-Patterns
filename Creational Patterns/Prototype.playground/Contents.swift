import Foundation

// MARK: Classes

enum Sex {
    case male
    case female
}

enum Age {
    case baby
    case child
    case adult
}

class Person {
    var name: String
    var sex: Sex
    var age: Age
    var married: Bool

    init(name: String, sex: Sex, age: Age, married: Bool) {
        self.name = name
        self.sex = sex
        self.age = age
        self.married = married
    }
}

// MARK: Traditional Object Creating:

let ali = Person(name: "Ali", sex: .male, age: .adult, married: false)
let ayse = Person(name: "Ayşe", sex: .female, age: .child, married: false)

// MARK: Object Creating with Basic Prototypes:

extension Person {
    func copy() -> Person {
        return Person(name: name, sex: sex, age: age, married: married)
    }
}

let maleAdultPerson = Person(name: "", sex: .male, age: .adult, married: false)
let cemal = maleAdultPerson.copy()
cemal.name = "Cemal"
cemal.married = true

// MARK: Object Creating with Prototypes and Abstract Factory:
// This approach makes factory methods more useful.
// Prototype objects would be static.

protocol PersonFactory {
    func create() -> Person
    func createMaleAdult(name: String, married: Bool) -> Person
    func createFemaleAdult(name: String, married: Bool) -> Person
}

enum PersonPrototypes {
    static let prototype = Person(name: "", sex: .male, age: .baby, married: false)
    static let maleAdultPrototype = Person(name: "", sex: .male, age: .adult, married: false)
    static let femaleAdultPrototype = Person(name: "", sex: .female, age: .adult, married: false)
}

class PersonFactoryImpl: PersonFactory {
    func create() -> Person {
        return PersonPrototypes.prototype.copy()
    }

    func createMaleAdult(name: String, married: Bool) -> Person {
        var person = PersonPrototypes.maleAdultPrototype.copy()
        person.name = name
        person.married = married
        return person
    }

    func createFemaleAdult(name: String, married: Bool) -> Person {
        var person = PersonPrototypes.femaleAdultPrototype.copy()
        person.name = name
        person.married = married
        return person
    }
}

let factory = PersonFactoryImpl()
let kemal = factory.createMaleAdult(name: "Kemal", married: true)
let sibel = factory.createFemaleAdult(name: "Sibel", married: false)

