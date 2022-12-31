// MARK: Classes

enum RAM {
    case four
    case eight
}

enum CPU {
    case intel
    case amd
}

enum HardDrive {
    case halfTB
    case oneTB
}

enum GraphicCard {
    case nvidia
    case amd
}

enum Display {
    case lcd
    case ips
}

class Computer {
    var ram: RAM?
    var cpu: CPU?
    var hardDrive: HardDrive?
    var graphicCard: GraphicCard?
    var display: Display?

    init() { }

    init(ram: RAM, cpu: CPU, hardDrive: HardDrive, graphicCard: GraphicCard, display: Display) {
        self.ram = ram
        self.cpu = cpu
        self.hardDrive = hardDrive
        self.graphicCard = graphicCard
        self.display = display
    }
}

// MARK: Basic Builder Pattern

protocol ComputerBuilder {
    func build() -> Computer
    // Can have multiple build methods.
}

class ComputerBuilderImpl: ComputerBuilder {
    func build() -> Computer {
        let computer = Computer()
        computer.ram = buildRAM()
        computer.cpu = buildCPU()
        computer.graphicCard = buildGraphicCard()
        computer.display = buildDisplay()
        return computer
    }

    private func buildRAM() -> RAM {
        return .eight
    }

    private func buildCPU() -> CPU {
        return .amd
    }

    private func buildGraphicCard() -> GraphicCard {
        return .nvidia
    }

    private func buildDisplay() -> Display {
        return .ips
    }
}

let builder = ComputerBuilderImpl()
let computer = builder.build()

// MARK: Chained Builder Pattern

protocol ComputerBuilderChained {
    func build() -> Computer
    func buildRAM() -> ComputerBuilderChained
    func buildCPU() -> ComputerBuilderChained
    func buildGraphicCard() -> ComputerBuilderChained
    func buildDisplay() -> ComputerBuilderChained
}

class ComputerBuilderChainedImpl: ComputerBuilderChained {
    private var computer: Computer

    init() {
        self.computer = Computer()
    }

    func build() -> Computer {
        return computer
    }

    func buildRAM() -> ComputerBuilderChained {
        computer.ram = .eight
        return self
    }

    func buildCPU() -> ComputerBuilderChained {
        computer.cpu = .amd
        return self
    }

    func buildGraphicCard() -> ComputerBuilderChained {
        computer.graphicCard = .nvidia
        return self
    }

    func buildDisplay() -> ComputerBuilderChained {
        computer.display = .ips
        return self
    }
}

let chainedBuilder = ComputerBuilderChainedImpl()

let newComputer = chainedBuilder
    .buildRAM()
    .buildDisplay()
    .buildGraphicCard()
    .build()
