import Foundation

let fileURL = Bundle.main.url(forResource: "input4", withExtension: "txt")
let input4 = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
let lines = input4.components(separatedBy: "\n").filter { !$0.isEmpty }
var number = 0
var totalScanned = 0
var encompassed: [String] = []
for line in lines {
    let parts = line.components(separatedBy: ",")
    let firstPart = parts.first!
    let firstItems = firstPart.components(separatedBy: "-")
    let firstStart = firstItems.first!
    let firstEnd = firstItems.last!
    let firstStartInt = Int(firstStart)!
    let firstEndInt = Int(firstEnd)!
    let firstRange = (firstStartInt...firstEndInt)

    let secondPart = parts.last!
    let secondItems = secondPart.components(separatedBy: "-")
    let secondStart = secondItems.first!
    let secondEnd = secondItems.last!
    let secondStartInt = Int(secondStart)!
    let secondEndInt = Int(secondEnd)!
    let secondRange = (secondStartInt...secondEndInt)

    var firstContainsAnyOfSecond = false
    for s in secondRange {
        firstContainsAnyOfSecond = firstContainsAnyOfSecond || firstRange ~= s
    }


    var secondContainsAnyOfFirst = false
    for f in firstRange {
        secondContainsAnyOfFirst = secondContainsAnyOfFirst || secondRange ~= f
    }

    let somewhatEncompassed = firstContainsAnyOfSecond || secondContainsAnyOfFirst
    if somewhatEncompassed {
        encompassed.append(line)
    }
    totalScanned += 1
    attempts[i] = encompassed
}
