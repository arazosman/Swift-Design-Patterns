// MARK: Classes

protocol Kernel {
    func start()
}

class KernelImpl: Kernel {
    func start() {
        print("Starting kernel...")
    }
}

protocol HardDrive {
    func start()
}

class HardDriveImpl: HardDrive {
    func start() {
        print("Starting hard drive...")
    }
}

protocol Display {
    func start()
}

class DisplayImpl: Display {
    func start() {
        print("Starting display...")
    }
}

class PoorUser {
    let kernel: Kernel
    let harddrive: HardDrive
    let display: Display

    init(kernel: Kernel, harddrive: HardDrive, display: Display) {
        self.kernel = kernel
        self.harddrive = harddrive
        self.display = display
    }

    func startComputer() {
        print("Poor user wants to start the computer...")
        kernel.start()
        harddrive.start()
        display.start()
    }
}

// MARK: Facade Class:
// It is useful to use complex systems under a simple interface.
// For example, API methods can be seen as facades.
// Facades are usually stateless.
// Alas, its cohesion is low and coupling is high, by its nature.
// But we should try to minimize this problem, for example, with
// inner facade classes.

class ComputerFacade {
    let kernel: Kernel
    let harddrive: HardDrive
    let display: Display

    init(kernel: Kernel, harddrive: HardDrive, display: Display) {
        self.kernel = kernel
        self.harddrive = harddrive
        self.display = display
    }

    func start() {
        kernel.start()
        harddrive.start()
        display.start()
    }
}

class HappyUser {
    let computer: ComputerFacade

    init(computer: ComputerFacade) {
        self.computer = computer
    }

    func startComputer() {
        print("Happy user wants to start the computer...")
        computer.start()
    }
}

let kernel = KernelImpl()
let harddrive = HardDriveImpl()
let display = DisplayImpl()

let poorUser = PoorUser(kernel: kernel, harddrive: harddrive, display: display)
poorUser.startComputer()

let computer = ComputerFacade(kernel: kernel, harddrive: harddrive, display: display)
let happyUser = HappyUser(computer: computer)
happyUser.startComputer()
