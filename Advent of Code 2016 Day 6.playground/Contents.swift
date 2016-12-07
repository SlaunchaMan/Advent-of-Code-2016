import Foundation

// Test Input
guard let testInput = try? String(contentsOf: #fileLiteral(resourceName: "eedadn.txt"))
    else { fatalError("Couldn't open test input") }

func characterCounts(inStrings strings: [String]) -> [[Character: Int]] {
    guard !strings.isEmpty else { fatalError("Empty code!") }
    
    let length = strings[0].characters.count
    
    var characterCounts = Array<[Character: Int]>(repeating: [:],
                                                  count: length)
    
    for i in 0 ..< strings.count {
        let line = strings[i]
        
        for j in 0 ..< line.characters.count {
            let index = line.characters.index(line.characters.startIndex,
                                              offsetBy: j)
            
            let character = line.characters[index]
            
            if let count = characterCounts[j][character] {
                characterCounts[j][character] = count + 1
            }
            else {
                characterCounts[j][character] = 1
            }
        }
    }
    
    return characterCounts
}

func decode(repetitionCode code: [String]) -> String {
    return characterCounts(inStrings: code).map {
        var highestCount = 0
        var highestCharacter: Character = "_"
        
        for (character, count) in $0 {
            if count > highestCount {
                highestCharacter = character
                highestCount = count
            }
        }
        
        return String(highestCharacter)
        }
        .joined()
}

func decode(modifiedRepititionCode code: [String]) -> String {
    return characterCounts(inStrings: code).map {
        var lowestCount = Int.max
        var lowestCharacter: Character = "_"
        
        for (character, count) in $0 {
            if count < lowestCount {
                lowestCharacter = character
                lowestCount = count
            }
        }
        
        return String(lowestCharacter)
        }
        .joined()
}

// Test Input
var testInputCode: [String] = []

testInput.enumerateLines { (line, _) in
    testInputCode.append(line)
}

decode(repetitionCode: testInputCode)
decode(modifiedRepititionCode: testInputCode)

// Input
guard let input = try? String(contentsOf: #fileLiteral(resourceName: "Advent of Code 2016 Day 6 Input 1.txt")) else {
    fatalError("Couldn't load input.")
}

var inputCode: [String] = []

input.enumerateLines { (line, _) in
    inputCode.append(line)
}

// Part 1
decode(repetitionCode: inputCode)

// Part 2
decode(modifiedRepititionCode: inputCode)

