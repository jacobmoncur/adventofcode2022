import Foundation


struct Day3 {
    var characters: [String] {
        let charactersLower = [
            "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
        ]
        let charactersUpper = charactersLower.map { $0.uppercased() }
        return charactersLower + charactersUpper
    }
    
    let input: String
    
    init(input: String) {
        self.input = input
    }
    
    func parseAndCalculatePart1() -> Int {
        let lines = input.components(separatedBy: "\n")

        var sum = 0

        for line in lines {
            let first = line.prefix(line.count/2)
            let second = line.suffix(line.count/2)
            let firstSet = Set(Array(first))
            let secondSet = Set(Array(second))
            let same = firstSet.intersection(secondSet)
            
            guard let letter = same.first else { continue }
            guard let index = characters.firstIndex(of: String(letter)) else { continue }
            
            sum += (index + 1)
        }

       return sum

    }
    
    func parseAndCalculatePart2() -> Int {
        let lines = input.components(separatedBy: "\n")
        var sum = 0

        for group in lines.chunked(into: 3) {
            let sets = group.map { Set($0) }
            guard !sets.isEmpty else { continue }
            let result = sets.reduce(sets.first!) { $0.intersection($1) }
            
            guard let letter = result.first else { continue }
            guard let index = characters.firstIndex(of: String(letter)) else { continue }
            
            sum += (index + 1)
        }

        return sum
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
