import Foundation

struct Day8 {
    let input: String
    
    func parseAndCalculate() -> Int {
        let lines: [String] = input.components(separatedBy: "\n").filter({ !$0.isEmpty })
        let grid: [[Int]] = lines.map({ line in
            return line.map { Int(String($0))! }
        })


        var startOfColumn = 0
        var endOfColumn = grid.count - 1
        var startOfRow = 0
        var endOfRow = grid.first!.count - 1

        var bestScore = 0

        for (rowIndex, row) in grid.enumerated() {
            for (columnIndex, item) in row.enumerated() {
                if rowIndex == 0 || rowIndex == (grid.count-1) || columnIndex == 0 || columnIndex == (row.count-1) {
                    // It's an edge
                } else {
                    // Check top
                    var topScore = 0
                    for i in (startOfColumn..<rowIndex).reversed() {
                        let value = grid[i][columnIndex]
                        if value < item {
                            topScore += 1
                        } else {
                            topScore += 1
                            break
                        }
                    }
                    
                    // Check bottom
                    var bottomScore = 0
                    for i in (rowIndex+1...endOfColumn) {
                        let value = grid[i][columnIndex]
                        if value < item {
                            bottomScore += 1
                        } else {
                            bottomScore += 1
                            break
                        }
                    }
                    
                    // Check left
                    var leftScore = 0
                    for i in (startOfRow..<columnIndex).reversed() {
                        let value = grid[rowIndex][i]
                        if value < item {
                            leftScore += 1
                        } else {
                            leftScore += 1
                            break
                        }
                    }
                    
                    // Check right
                    var rightScore = 0
                    for i in (columnIndex+1...endOfRow) {
                        let value = grid[rowIndex][i]
                        if value < item {
                            rightScore += 1
                        } else {
                            rightScore += 1
                            break
                        }
                    }
                    
                    let score = topScore * bottomScore * leftScore * rightScore
                    if score > bestScore {
                        bestScore = score
                    }
                }
            }
        }
        return bestScore
    }
}
