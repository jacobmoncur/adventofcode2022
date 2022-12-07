import Foundation

struct Day6 {
    let input: String
    
    func parseAndCalculate() -> Int {
        let windowSize = 14
        let windowCount = input.count - windowSize
        for i in 0..<windowCount {
            let start = input.index(input.startIndex, offsetBy: i)
            let end = input.index(input.startIndex, offsetBy: i+(windowSize-1))
            let windowSet = Set(input[start...end])
            if windowSet.count == windowSize {
                return i+windowSize
            }
        }
        
        return 0
    }
}
