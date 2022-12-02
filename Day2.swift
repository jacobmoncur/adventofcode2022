enum BattleErrors: Error {
    case parseError
}

enum Column1: String {
    case rock = "A"
    case paper = "B"
    case scissors = "C"
    
    init(value: String) throws {
        switch value {
        case "A": self = .rock
        case "B": self = .paper
        case "C": self = .scissors
        default: throw BattleErrors.parseError
        }
    }

    var points: Int {
        switch self {
        case .rock: return 1
        case .paper: return 2
        case .scissors: return 3
        }
    }
}

enum Column2: String {
    case rock = "X"
    case paper = "Y"
    case scissors = "Z"
    
    init(value: String) throws {
        switch value {
        case "X": self = .rock
        case "Y": self = .paper
        case "Z": self = .scissors
        default: throw BattleErrors.parseError
        }
    }

    var points: Int {
        switch self {
        case .rock: return 1
        case .paper: return 2
        case .scissors: return 3
        }
    }
}

enum Column2Result: String {
    case loss = "X"
    case draw = "Y"
    case win = "Z"
    
    init(value: String) throws {
        switch value {
        case "X": self = .loss
        case "Y": self = .draw
        case "Z": self = .win
        default: throw BattleErrors.parseError
        }
    }

    func play(column1: Column1) -> Column2 {
        switch (self, column1) {
        case (.loss, .rock): return .scissors
        case (.loss, .paper): return .rock
        case (.loss, .scissors): return .paper
            
        case (.draw, .rock): return .rock
        case (.draw, .paper): return .paper
        case (.draw, .scissors): return .scissors
            
        case (.win, .rock): return .paper
        case (.win, .paper): return .scissors
        case (.win, .scissors): return .rock
        }
    }
}

struct Battle {
    let column1: Column1
    let column2: Column2

    enum Result {
        case win(Int)
        case loss(Int)
        case draw(Int)

        var points: Int {
            switch self {
            case .win(let points): return points
             case .loss(let points): return points
                case .draw(let points): return points
            }
        }
    }

    func column1Result() -> Result {
        switch (column1, column2) {
        case (.rock, .rock): return .draw(column1.points + 3)
        case (.rock, .paper): return .loss(column1.points + 0)
        case (.rock, .scissors): return .win(column1.points + 6)
        case (.paper, .rock): return .win(column1.points + 6)
        case (.paper, .paper): return .draw(column1.points + 3)
        case (.paper, .scissors): return .loss(column1.points + 0)
        case (.scissors, .scissors): return .draw(column1.points + 3)
        case (.scissors, .paper): return .win(column1.points + 6)
        case (.scissors, .rock): return .loss(column1.points + 0)
        }
    }

    func column2Result() -> Result {
        switch (column2, column1) {
        case (.rock, .rock): return .draw(column2.points + 3)
        case (.rock, .paper): return .loss(column2.points + 0)
        case (.rock, .scissors): return .win(column2.points + 6)
        case (.paper, .rock): return .win(column2.points + 6)
        case (.paper, .paper): return .draw(column2.points + 3)
        case (.paper, .scissors): return .loss(column2.points + 0)
        case (.scissors, .scissors): return .draw(column2.points + 3)
        case (.scissors, .paper): return .win(column2.points + 6)
        case (.scissors, .rock): return .loss(column2.points + 0)
        }
    }

}

public struct Day2 {
    let input: String
    
    public init(inputString: String) {
        print("Setting up string")
        self.input = inputString
    }
    
    public func parseAndCalculate() -> Int {
        var totalPoints = 0
        let battleStrings: [String] = input.components(separatedBy: "\n")

        for battleString in battleStrings {
            let items = battleString.components(separatedBy: " ")
            
            do {
                let column1 = try Column1(value: items.first!)
                let result = try Column2Result(value: items.last!)
                let column2 = result.play(column1: column1)
                let battle = Battle(column1: column1, column2: column2)
                let result1 = battle.column1Result()
                let result2 = battle.column2Result()
                totalPoints += result2.points
                
                print("Items \(items) \(column1) \(result) \(column2) \(result1) \(result2)")
            } catch {
                print("Failed \(error)")
            }
        }
        return totalPoints
    }
}
