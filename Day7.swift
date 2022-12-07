import Foundation

enum Command {
    case home
    case list
    case navigateTo(dir: String)
    case navigateBack
    
    static func from(raw: String) -> Command? {
        guard raw.hasPrefix("$") else {
            return nil
        }
        
        if raw == "$ ls" {
            return .list
        }
        
        if raw == "$ cd /" {
            return .home
        }
        
        if raw == "$ cd .." {
            return .navigateBack
        }
        
        return .navigateTo(dir: raw.components(separatedBy: " ")[2])
    }
}

class Node {
    let name: String
    let size: Int?
    let parent: Node?
    
    var leafs: [Node]?
    
    init(parent: Node, raw: String) {
        let components = raw.components(separatedBy: " ")
        let first = components[0]
        let second = components[1]
        
        if first == "dir" {
            self.name = second
            self.size = nil
            self.leafs = []
        } else {
            self.name = second
            self.size = Int(first)
            self.leafs = nil
        }
        self.parent = parent
    }
    
    init(){
        self.name = "home"
        self.size = nil
        self.parent = nil
        self.leafs = []
        
    }
    
    var files: [Node]? {
        return leafs?.filter({ node in
            node.leafs == nil && size != nil
        })
    }
    
    var directories: [Node]? {
        return leafs?.filter({ node in
            node.leafs != nil || size == nil
        })
    }
    
    var calculatedSize: Int {
        if let size = size {
            return size
        } else {
            return leafs?.reduce(into: 0, { res, node in
                res += node.calculatedSize
            }) ?? 0
        }
    }
    
    func leaf(withName name: String) -> Node? {
        return leafs?.first(where: { node in
            node.name == name
        })
    }
    
    func appendLeaf(node: Node) {
        leafs?.append(node)
    }
    
    func nodesOfSizeLessThanOrEqualTo(size: Int) -> [Node] {
        var nodes = directories?.reduce(into: [], { res, node in
            res.append(contentsOf: node.nodesOfSizeLessThanOrEqualTo(size: size))
        }) ?? []
        
        if self.size == nil && calculatedSize <= size {
            nodes.append(self)
        }
        return nodes
    }
    
    func findClosestDirectoryToSize(size: Int) -> (Node, Int)? {
        var closest: Node?
        var distance: Int = 100000000000000000
        if self.size == nil {
            let currentSize = calculatedSize
            if calculatedSize >= size {
                closest = self
                distance = calculatedSize - size
            }
        }
        
        
        for dir in directories ?? [] {
            if let result = dir.findClosestDirectoryToSize(size: size), result.1 < distance {
                closest = result.0
                distance = result.1
            }
        }
        
        if let closest = closest {
            return (closest, distance)
        }
        
        return nil
    }
}

struct Day7 {
    let input: String
    
    func parseAndCalculate() {
        var previousCommand: Command? = nil
        var homeNode = Node()
        var currentNode: Node = homeNode
        for line in input.components(separatedBy: "\n") {
            guard !line.isEmpty else {
                continue
            }
            if let command = Command.from(raw: line) {
                switch command {
                case .home:
                    currentNode = homeNode
                case .list: ()
                case .navigateTo(let dir):
                    if let nextNode = currentNode.leaf(withName: dir) {
                        currentNode = nextNode
                    }
                case .navigateBack:
                    if let parent = currentNode.parent {
                        currentNode = parent
                    }
                }
                previousCommand = command
            } else {
                let node = Node(parent: currentNode, raw: line)
                currentNode.appendLeaf(node: node)
            }
        }

        print("Finding nodes less than 100k")
        let nodesLessThan100_000 = homeNode.nodesOfSizeLessThanOrEqualTo(size: 100_000)
        
        print("There are supposedly \(nodesLessThan100_000.count) with less than 100k")
        print(nodesLessThan100_000.map({ $0.name }))
        
        let totalSize = nodesLessThan100_000.reduce(into: 0, { res, node in
            res += node.calculatedSize
        })
        
        print("Total size is:")
        print(totalSize)


        let totalDiskSpace = 70000000
        let needUnusedSpace = 30000000

        let currentSpaceUsed = homeNode.calculatedSize
        let currentUnusedSpacee = totalDiskSpace - currentSpaceUsed
        let closestToThisSize = needUnusedSpace - currentUnusedSpacee

        var scannedEntireTree = false
        var closestNode: Node?
        var watchingNode: Node = homeNode

        if let result = homeNode.findClosestDirectoryToSize(size: closestToThisSize) {
            let name = result.0.name
            let calculatedSize = result.0.calculatedSize
            let other = result.1
            print(calculatedSize)
        }
    }
}
