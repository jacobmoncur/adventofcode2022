import Foundation

class Stack {
    let id: String
    var items: [String]
    
    var peek: String? {
        items.last
    }
    
    init(id: String, items: [String]) {
        self.id = id
        self.items = items
    }
    
    func push(_ newItems: [String]) {
        items.append(contentsOf: newItems)
    }
    
    func pop(_ quantity: Int, inSequence: Bool) -> [String] {
        let poppedItems: [String] = (0..<quantity).map({ _ in items.popLast() ?? "" }).filter({ !$0.isEmpty })
        if inSequence {
            return poppedItems.reversed()
        } else {
            return poppedItems
        }
    }
    
    var description: String {
        "\(id) - \(items)"
    }
}

struct Command {
    let quantity: Int
    let from: String
    let to: String
    
    init(string: String) {
        let pieces = string.components(separatedBy: " ")
        self.quantity = Int(pieces[1])!
        self.from = pieces[3]
        self.to = pieces[5]
    }
}

class Yard {
    let stacks: [Stack]
    let commands: [Command]
    
    init(initialString: String, commandsString: String) {
        let lines = initialString.components(separatedBy: "\n")
        
        let parsed: [[String]] = lines.map { line in
            let lineArray = line.map({ String($0) })
            let lineChunked = lineArray.chunked(into: 4)
            
            let itemsInLine: [String] = lineChunked.map { items in
                let itemRemovedSpaces: String = items.joined(separator: "").replacingOccurrences(of: " ", with: "")
                return itemRemovedSpaces
            }
            return itemsInLine
        }
        var setup: [Int: Stack] = [:]
        
        for items in parsed.reversed(){
            for (index, item) in items.enumerated() {
                if item.contains("[") {
                    setup[index]?.push([item])
                } else if !item.isEmpty {
                    setup[index] = Stack(id: item, items: [])
                }
            }
        }
        
        let newCommands: [Command] = commandsString.components(separatedBy: "\n").compactMap { c in
            guard !c.isEmpty else { return nil }
            return Command(string: c)
        }
        
        
        self.stacks = setup.values.map({ $0 })
        self.commands = newCommands
        
    }
    
    init(stacks: [Stack], commands: [Command]) {
        self.stacks = stacks
        self.commands = commands
    }
    
    func executeCommands(inSequence: Bool) -> String {
        for command in commands {
            executeCommand(command: command, inSequence: inSequence)
        }
        
        return stacks.sorted(by: { i1, i2 in
            i1.id <= i2.id
        }).map { "\($0.peek ?? "?")" }
            .joined(separator: "")
            .replacingOccurrences(of: "[", with: "")
            .replacingOccurrences(of: "]", with: "")
    }
    
    private func executeCommand(command: Command, inSequence: Bool) -> Bool {
        guard let fromStack = stacks.first(where: { stack in
            stack.id == command.from
        }) else { return false }
        
        guard let toStack = stacks.first(where: { stack in
            stack.id == command.to
        }) else { return false }
        let items = fromStack.pop(command.quantity, inSequence: inSequence)
        toStack.push(items)
        return true
    }
    
}


extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
