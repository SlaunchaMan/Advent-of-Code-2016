import Foundation

func validTriangle(a: Int, b: Int, c: Int) -> Bool {
    return (a + b > c &&
        a + c > b &&
        b + c > a)
}

validTriangle(a: 5, b: 10, c: 25)

guard let input = try? String(contentsOf: #fileLiteral(resourceName: "4   21  894.txt")) 
    else { fatalError() }

// Part 1
var part1Count = 0
input.enumerateLines { (line, _) in
    let numbers = line
        .components(separatedBy: CharacterSet.whitespaces)
        .filter { component in
            component.rangeOfCharacter(from: CharacterSet.whitespaces.inverted) != nil
        }
        .flatMap {
            Int($0)
    }
    
    guard numbers.count == 3 else { return }
    
    if validTriangle(a: numbers[0], 
                     b: numbers[1],
                     c: numbers[2]) {
        part1Count += 1
    }
}

part1Count

// Part 2
var part2Count = 0
var lineBuffer: [String] = []
input.enumerateLines { (line, _) in
    lineBuffer.append(line)
    
    if (lineBuffer.count == 3) {
        defer {
            lineBuffer.removeAll()
        }
        
        let numbers = lineBuffer.map {
                $0.components(separatedBy: CharacterSet.whitespaces)
                    .filter { component in
                        component.rangeOfCharacter(from: CharacterSet.whitespaces.inverted) != nil
                    }
                    .flatMap {
                        Int($0)
                }
            }
        
        for i in 0 ..< 3 {
            if validTriangle(a: numbers[0][i],
                             b: numbers[1][i],
                             c: numbers[2][i]) {
                part2Count += 1
            }
        }
    }
}

part2Count



