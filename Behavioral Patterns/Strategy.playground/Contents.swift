// MARK: Sorting Example

class BadSorter {
    func sorted(array: [Int]) -> [Int] {
        let sortedArray: [Int]

        if array.count < 100 {
            sortedArray = bubbleSorted(array: array)
        } else {
            sortedArray = quickSorted(array: array)
        }

        return sortedArray
    }

    private func bubbleSorted(array: [Int]) -> [Int] {
        // ...
        return [1, 2, 3, 4, 5]
    }

    private func quickSorted(array: [Int]) -> [Int] {
        // ...
        return [1, 2, 3, 4, 5]
    }
}

// MARK: Strategy Pattern

protocol Sorter {
    func sort(array: [Int]) -> [Int]
}

class BubbleSorter: Sorter {
    func sort(array: [Int]) -> [Int] {
        // ...
        return [1, 2, 3, 4, 5]
    }
}

class QuickSorter: Sorter {
    func sort(array: [Int]) -> [Int] {
        // ...
        return [1, 2, 3, 4, 5]
    }
}

protocol SorterFactory {
    func createBubbleSorter() -> Sorter
    func createQuickSorter() -> Sorter
}

class SorterFactoryImpl: SorterFactory {
    func createBubbleSorter() -> Sorter {
        BubbleSorter()
    }

    func createQuickSorter() -> Sorter {
        QuickSorter()
    }
}

class SortingContext {
    private let factory: SorterFactory

    init(factory: SorterFactory) {
        self.factory = factory
    }

    func sort(array: [Int]) -> [Int] {
        let sorter: Sorter

        if array.count < 100 {
            sorter = factory.createBubbleSorter()
        } else {
            sorter = factory.createQuickSorter()
        }

        return sorter.sort(array: array)
    }
}

let sorterFactory = SorterFactoryImpl()
let sortingContext = SortingContext(factory: sorterFactory)
let array = sortingContext.sort(array: [2, 5, 3, 1, 4])

