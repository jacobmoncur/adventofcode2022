struct Day1 {
    let input: String
    
    init(input: String) {
        self.input = input
    }
    
    func parseAndCalculate() -> Int {
        let elfInputs: [String] = input.components(separatedBy: "\n\n")
        let elfCalories = elfInputs.map { itemsString in
            let items: [String] = itemsString.components(separatedBy: "\n")
            let itemsAsNumbers = items.map { item in
                return  Int(item) ?? 0
            }
            
            return itemsAsNumbers.reduce(into: 0) { res, num in
                res += num
            }
        }
        
        return elfCalories.sorted().suffix(3).reduce(into: 0) { res, num in
            res += num
        }
    }
    
    func parseAndCalculate2() -> Int {
        let elfInputs: [String] = input.components(separatedBy: "\n\n")
        let elfCalories = elfInputs.map { itemsString in
            let items: [String] = itemsString.components(separatedBy: "\n")
            let itemsAsNumbers = items.map { item in
                return  Int(item) ?? 0
            }
            
            return itemsAsNumbers.reduce(into: 0) { res, num in
                res += num
            }
        }
        
        return elfCalories.reduce(into: 0) { res, num in
            res += num
        }
    }
}
