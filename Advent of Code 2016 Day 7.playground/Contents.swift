import Foundation


extension String {
    var hasABBASequence: Bool {
        guard characters.count >= 4
            else { return false }
        
        let startIndex = characters.startIndex
        for i in 0 ..< characters.count - 3 {
            let firstIndex = characters.index(
                startIndex, offsetBy: i)
            
            let secondIndex = characters.index(after: firstIndex)
            
            guard characters[firstIndex] != characters[secondIndex]
                else { continue }
            
            let thirdIndex = characters.index(after: secondIndex)
            
            let fourthIndex = characters.index(after: thirdIndex)
            
            if characters[firstIndex] == characters[fourthIndex] && characters[secondIndex] == characters[thirdIndex] {
                return true
            }
        }
        
        return false
    }
    
    var abaSequences: [String] {
        guard characters.count >= 3 else { return [] }
        
        var sequences: [String] = []
        
        let startIndex = characters.startIndex
        
        for i in 0 ..< characters.count - 2 {
            let firstIndex = characters.index(startIndex,
                                              offsetBy: i)
            
            let secondIndex = characters.index(after: firstIndex)
            let thirdIndex = characters.index(after: secondIndex)
            
            let firstCharacter = characters[firstIndex]
            let secondCharacter = characters[secondIndex]
            let thirdCharacter = characters[thirdIndex]
            
            if firstCharacter == thirdCharacter &&
                firstCharacter != secondCharacter {
                sequences.append(String([firstCharacter,
                                         secondCharacter,
                                         thirdCharacter]))
            }
        }
        
        return sequences
    }
    
    func inverseABA() -> String? {
        guard characters.count == 3 else { return nil }
        
        let firstIndex = characters.startIndex
        let secondIndex = characters.index(after: firstIndex)
        
        let firstCharacter = characters[firstIndex]
        let secondCharacter = characters[secondIndex]
   
        return String([secondCharacter,
                       firstCharacter,
                       secondCharacter])
    }
    
    func contains(oneOf strings: [String]) -> Bool {
        for str in strings {
            if contains(str) {
                return true
            }
        }
        
        return false
    }
}

struct IPv7Address {
    let characterSequences: [String]
    let hypernetSequences: [String]
    
    init?(string: String) {
        var cs = [String]()
        var hs = [String]()
        
        var cur = ""
        
        for character in string.characters {
            switch character {
            case "[":
                cs.append(cur)
                cur = ""
                
            case "]":
                hs.append(cur)
                cur = ""
                
            default:
                cur += String(character)
            }
        }
        
        if cur != "" {
            cs.append(cur)
        }
        
        guard cs.count > 0, hs.count > 0 
            else { return nil }
        
        self.characterSequences = cs
        self.hypernetSequences = hs
    }
    
    var supportsTLS: Bool {
        let sequenceTest = { (a: String) -> Bool in
            return a.hasABBASequence
        }
        
        return characterSequences.contains(where: sequenceTest) &&
            !hypernetSequences.contains(where: sequenceTest)
    }
    
    var supportsSSL: Bool {
        let allSequences = characterSequences
            .flatMap { $0.abaSequences }
        
        let inverseSequences = allSequences
            .flatMap { $0.inverseABA() }
        
        return !hypernetSequences
            .filter { $0.contains(oneOf: inverseSequences) }
            .isEmpty
    }
}

// Test Input
IPv7Address(string: "abba[mnop]qrst")?.supportsTLS
IPv7Address(string: "abcd[bddb]xyyx")?.supportsTLS
IPv7Address(string: "aaaa[qwer]tyui")?.supportsTLS
IPv7Address(string: "ioxxoj[asdfgh]zxcvbn")?.supportsTLS

IPv7Address(string: "aba[bab]xyz")?.supportsSSL
IPv7Address(string: "xyx[xyx]xyx")?.supportsSSL
IPv7Address(string: "aaa[kek]eke")?.supportsSSL
IPv7Address(string: "zazbz[bzb]cdb")?.supportsSSL

// Input
guard let input = try? String(contentsOf: #fileLiteral(resourceName: "input.txt"))
    else { fatalError() }

var supportsTLSCount = 0
var supportsSSLCount = 0

input.enumerateLines { (line, _) in
    guard let addr = IPv7Address(string: line) else {
        print("Couldn't make address from " + line)
        return
    }
    
    if addr.supportsTLS {
        supportsTLSCount += 1
    }
    
    if addr.supportsSSL {
        supportsSSLCount += 1
    }
}

supportsTLSCount
supportsSSLCount