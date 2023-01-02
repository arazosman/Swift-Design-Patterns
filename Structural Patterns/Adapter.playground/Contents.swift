// MARK: Classes

protocol TurkishPowerSource {
    func turnOn()
    func turnOff()
}

class TurkishPowerSourceImpl: TurkishPowerSource {
    func turnOn() {
        print("Turkish power source turned on.")
    }

    func turnOff() {
        print("Turkish power source turned off.")
    }
}

protocol AmericanPowerSource {
    func switchSource(value: Bool)
}

class AmericanPowerSourceImpl: AmericanPowerSource {
    func switchSource(value: Bool) {
        print("American power source switched \(value ? "on" : "off").")
    }
}

// MARK: Bad design for adaptation.
// Violates SRP: Adaptation should not be BadPowerManager's responsibility.
// Violates OCP: It's not closed to modification and not open to extension.
// NOTE: This approach can be used as a two-way adapter pattern. But more
// source types means more complexity in the class. Thus, universal adapters
// are not good designs since they are overly complex.

class BadPowerManager {
    private var turkishPowerSource: TurkishPowerSource? = nil
    private var americanPowerSource: AmericanPowerSource? = nil

    init(turkishPowerSource: TurkishPowerSource) {
        self.turkishPowerSource = turkishPowerSource
    }

    init(americanPowerSource: AmericanPowerSource) {
        self.americanPowerSource = americanPowerSource
    }

    func start() {
        if (turkishPowerSource != nil) {
            turkishPowerSource?.turnOn()
        } else if (americanPowerSource != nil) {
            americanPowerSource?.switchSource(value: true)
        }
    }

    func stop() {
        if (turkishPowerSource != nil) {
            turkishPowerSource?.turnOn()
        } else if (americanPowerSource != nil) {
            americanPowerSource?.switchSource(value: false)
        }
    }
}

let badPowerManagerWithTurkishPowerSource = BadPowerManager(
    turkishPowerSource: TurkishPowerSourceImpl()
)
badPowerManagerWithTurkishPowerSource.start()

let badPowerManagerWithAmericanPowerSource = BadPowerManager(
    americanPowerSource: AmericanPowerSourceImpl()
)
badPowerManagerWithAmericanPowerSource.start()

// MARK: Good design for adaptation.

class AmericanPowerSourceAdapter: TurkishPowerSource {
    let americanPowerSource: AmericanPowerSource

    init(americanPowerSource: AmericanPowerSource) {
        self.americanPowerSource = americanPowerSource
    }

    func turnOn() {
        americanPowerSource.switchSource(value: true)
    }

    func turnOff() {
        americanPowerSource.switchSource(value: false)
    }
}

class PowerManager {
    private let powerSource: TurkishPowerSource

    init(powerSource: TurkishPowerSource) {
        self.powerSource = powerSource
    }

    func start() {
        powerSource.turnOn()
    }

    func stop() {
        powerSource.turnOn()
    }
}

let goodPowerManagerWithTurkishPowerSource = PowerManager(
    powerSource: TurkishPowerSourceImpl()
)
goodPowerManagerWithTurkishPowerSource.start()

let goodPowerManagerWithAmericanPowerSource = PowerManager(
    powerSource: AmericanPowerSourceAdapter(
        americanPowerSource: AmericanPowerSourceImpl()
    )
)
goodPowerManagerWithAmericanPowerSource.start()

// MARK: There is also a pattern similar to Adapter to be used for ignoring some
// methods of interfaces we are implementing.

protocol MouseListener {
    func mouseClicked()
    func mousePressed()
    func mouseReleased()
}

protocol MouseMotionListener {
    func mouseDragged()
    func mouseMoved()
}

protocol MouseAdapter: MouseListener, MouseMotionListener {
    func mouseClicked()
    func mousePressed()
    func mouseReleased()
    func mouseDragged()
    func mouseMoved()
}

extension MouseAdapter {
    func mouseClicked() { }
    func mousePressed() { }
    func mouseReleased() { }
    func mouseDragged() { }
    func mouseMoved() { }
}

class MouseEvents: MouseAdapter {
    func mouseClicked() {
        print("Mouse clicked.")
    }

    func mousePressed() {
        print("Mouse pressed.")
    }

    func mouseMoved() {
        print("Mouse moved.")
    }
}

let mouseEvents = MouseEvents()
mouseEvents.mouseClicked()
mouseEvents.mousePressed()
mouseEvents.mouseMoved()
