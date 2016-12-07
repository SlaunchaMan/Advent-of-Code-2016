import Foundation

guard let input = try? String(contentsOf: #fileLiteral(resourceName: "DLRRRRLRLDRRRURRURULRLLULUURRRDDLDULDULLUUDLURLURLLDLUUUDUUUULDRDUUDUDDRRLRDDDUDLDLLRUURDRULUULRLRDU.txt")) else { fatalError() }

let sampleInput = "ULL\nRRDDD\nLURDL\nUUUUD"

func code(digits: [[Int?]], pattern input: String) -> [Int] {
    var code: [Int] = []
    
    var rowCount = digits.count
    var colCount = digits[0].count
    
    var row = 0
    var col = 0
    
    find5: for i in 0 ..< rowCount {
        for j in 0 ..< colCount {
            if digits[i][j] == 5 {
                row = i
                col = j
                break find5
            }
        }
    }
    
    input.enumerateLines { (line, _) in
        line.characters.forEach {
            switch $0 {
            case "U" where row > 0 && digits[row - 1][col] != nil:
                row = row - 1
                
            case "D" where row + 1 < rowCount && digits[row + 1][col] != nil:
                row = row + 1
                
            case "L" where col > 0 && digits[row][col - 1] != nil:
                col = col - 1
                
            case "R" where col + 1 < colCount && digits[row][col + 1] != nil:
                col = col + 1
                
            default:
                break
            }
        }
        
        guard let digit = digits[row][col] else { fatalError() }
        
        code.append(digit)
    }
    
    return code
}

// Part 1
let part1Digits = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]]

let part1Code = code(digits: part1Digits, pattern: input)

// Part 2
let part2Digits: [[Int?]] = [
    [nil, nil,   1, nil, nil],
    [nil,   2,   3,   4, nil],
    [  5,   6,   7,   8,   9],
    [nil, 0xA, 0xB, 0xC, nil],
    [nil, nil, 0xD, nil, nil]]

let part2Code = code(digits: part2Digits, pattern: input)


