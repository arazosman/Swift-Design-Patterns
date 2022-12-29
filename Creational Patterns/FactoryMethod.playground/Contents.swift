// Person classes

class Person {
    let name: String
    let age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

class Manager: Person {
    let department: String

    init(name: String, age: Int, department: String) {
        self.department = department
        super.init(name: name, age: age)
    }
}

class Teacher: Person {
    let subject: String
    
    init(name: String, age: Int, subject: String) {
        self.subject = subject
        super.init(name: name, age: age)
    }
}

class Student: Person {
    let grade: Int
    
    init(name: String, age: Int, grade: Int) {
        self.grade = grade
        super.init(name: name, age: age)
    }
}

// MARK: Helpers

func printPersons(_ manager: Manager, _ teacher: Teacher, _ student: Student) {
    print("\(manager.department)\n\(teacher.subject)\n\(student.grade)")
}

func printOptPersons(_ manager: Manager?, _ teacher: Teacher?, _ student: Student?) {
    print("\(String(describing: optManager?.department))\n\(String(describing: optTeacher?.subject))\n\(String(describing: optStudent?.grade))")
}

// MARK: Static Factory Method (Shitty)
// Violates SRP & OCP.

class StaticPersonFactory {
    // A factory method should only create one instance of a class. But this one is a mess.
    static func create(name: String, age: Int, department: String, subject: String, grade: Int, type: String) -> Person {
        let person: Person

        switch type {
        case "Manager":
            person = Manager(name: name, age: age, department: department)
        case "Teacher":
            person = Teacher(name: name, age: age, subject: subject)
        case "Student":
            person = Student(name: name, age: age, grade: grade)
        default:
            fatalError("Unknown person type")
        }

        return person
    }
}

var optManager = StaticPersonFactory.create(
    name: "Ali",
    age: 40,
    department: "A department",
    subject: "",
    grade: 0,
    type: "Manager"
) as? Manager
var optTeacher = StaticPersonFactory.create(
    name: "Veli",
    age: 35,
    department: "",
    subject: "A subject",
    grade: 0,
    type: "Teacher"
) as? Teacher
var optStudent = StaticPersonFactory.create(
    name: "Ali",
    age: 40,
    department: "",
    subject: "",
    grade: 80,
    type: "Student"
) as? Student

printOptPersons(optManager, optTeacher, optStudent)

// MARK: Static Factory Method with Multiple Methods (Still Shitty)
// Better than above, but still violates SRP and OCP.
// It is a FactoryUtility class, which is an anti-pattern.

class StaticMultiplePersonFactory {
    static func createManager(name: String, age: Int, department: String) -> Manager {
        return Manager(name: name, age: age, department: department)
    }

    static func createTeacher(name: String, age: Int, subject: String) -> Teacher {
        return Teacher(name: name, age: age, subject: subject)
    }

    static func createStudent(name: String, age: Int, grade: Int) -> Student {
        return Student(name: name, age: age, grade: grade)
    }
}

optManager = StaticMultiplePersonFactory.createManager(
    name: "Ali",
    age: 40,
    department: "A department"
)
optTeacher = StaticMultiplePersonFactory.createTeacher(
    name: "Veli",
    age: 35,
    subject: "A subject"
)
optStudent = StaticMultiplePersonFactory.createStudent(
    name: "Ali",
    age: 40,
    grade: 80
)

printOptPersons(optManager, optTeacher, optStudent)

// MARK: Factory Methods (via Single Protocol)
// Does not make sense in this situation, because we can't create
// these objects properly with one method.

protocol SingleFactory {
    associatedtype P: Person
    func create(name: String, age: Int) -> P
}

class ManagerSingleFactory: SingleFactory {
    func create(name: String, age: Int) -> Manager {
        return Manager(name: name, age: age, department: "Random Department")
    }
}

class TeacherSingleFactory: SingleFactory {
    func create(name: String, age: Int) -> Teacher {
        return Teacher(name: name, age: age, subject: "Random Subject")
    }
}

class StudentSingleFactory: SingleFactory {
    func create(name: String, age: Int) -> Student {
        return Student(name: name, age: age, grade: Int.random(in: 10 ... 100))
    }
}

let msFactory = ManagerSingleFactory()
let tsFactory = TeacherSingleFactory()
let ssFactory = StudentSingleFactory()

var manager = msFactory.create(name: "Ali", age: 40)
var teacher = tsFactory.create(name: "Cumali", age: 35)
var student = ssFactory.create(name: "Ruhican", age: 15)

printPersons(manager, teacher, student)

// MARK: Factory Methods (via Multiple Protocols)

protocol ManagerFactory {
    func create(name: String, age: Int, department: String) -> Manager
}

protocol TeacherFactory {
    func create(name: String, age: Int, subject: String) -> Teacher
}

protocol StudentFactory {
    func create(name: String, age: Int, grade: Int) -> Student
}

class ManagerFactoryImpl: ManagerFactory {
    func create(name: String, age: Int, department: String) -> Manager {
        return Manager(name: name, age: age, department: department)
    }
}

class TeacherFactoryImpl: TeacherFactory {
    func create(name: String, age: Int, subject: String) -> Teacher {
        return Teacher(name: name, age: age, subject: subject)
    }
}

class StudentFactoryImpl: StudentFactory {
    func create(name: String, age: Int, grade: Int) -> Student {
        return Student(name: name, age: age, grade: grade)
    }
}

let mmFactory = ManagerFactoryImpl()
let tmFactory = TeacherFactoryImpl()
let smFactory = StudentFactoryImpl()

manager = mmFactory.create(name: "Ali", age: 40, department: "A department")
teacher = tmFactory.create(name: "Cumali", age: 35, subject: "A subject")
student = smFactory.create(name: "Ruhican", age: 15, grade: 95)

printPersons(manager, teacher, student)
