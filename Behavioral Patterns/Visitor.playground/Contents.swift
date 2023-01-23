// MARK: Visitor Pattern
// Visitor pattern can be used when implementations of an interface
// have some specialized methods for themselves. We would need to
// use RTTI (Run-Time-Type-Inference) to call these specialized
// methods if we don't use the Visiter Pattern.

// MARK: Problematic approach:

protocol File {
    func open()
    func close()
    func read()
}

class TextFile: File {
    func open() { /* ... */ }
    func close() { /* ... */ }
    func read() { /* ... */ }

    // Specialized method
    func checkFormat()  { /* ... */ }
}

class XMLFile: File {
    func open() { /* ... */ }
    func close() { /* ... */ }
    func read() { /* ... */ }

    // Specialized method
    func validate()  { /* ... */ }
}

func openFile(file: some File) {
    file.open()

    // RTTI
    if file is TextFile {
        (file as! TextFile).checkFormat()
    } else if file is XMLFile {
        (file as! XMLFile).validate()
    }

    file.read()
    file.close()
}

// MARK: Better approach with Visitor

protocol Visitor {
    func visit(file: BetterTextFile)
    func visit(file: BetterXMLFile)
}

class VisiterImpl: Visitor {
    func visit(file: BetterTextFile) {
        file.checkFormat()
    }

    func visit(file: BetterXMLFile) {
        file.validate()
    }
}

protocol BetterFile {
    func open()
    func close()
    func read()
    func accept(visitor: some Visitor)
}

class BetterTextFile: BetterFile {
    func open() { /* ... */ }
    func close() { /* ... */ }
    func read() { /* ... */ }
    func checkFormat()  { /* ... */ }

    func accept(visitor: some Visitor) {
        visitor.visit(file: self)
    }
}

class BetterXMLFile: BetterFile {
    func open() { /* ... */ }
    func close() { /* ... */ }
    func read() { /* ... */ }
    func validate()  { /* ... */ }

    func accept(visitor: some Visitor) {
        visitor.visit(file: self)
    }
}

func openFile(file: some BetterFile, visitor: some Visitor) {
    file.open()
    file.accept(visitor: visitor)
    file.read()
    file.close()
}
