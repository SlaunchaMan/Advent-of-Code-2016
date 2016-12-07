import Foundation

let separatorSet = CharacterSet(charactersIn: "[]")
let dashSet = CharacterSet(charactersIn: "-")

extension String {
    private var mainComponents: [String] {
        return components(separatedBy: separatorSet)
            .filter { !$0.isEmpty }
    }
    var checksum: String {
        var characterCounts: [Character: Int] = [:]
        
        for scalar in unicodeScalars {
            if CharacterSet.letters.contains(scalar) {
                let char = Character(scalar)
                if let count = characterCounts[char] {
                    characterCounts[char] = count + 1
                }
                else {
                    characterCounts[char] = 1
                }
            }
        }
        
        characterCounts.map {
            "\($0.key) : \($0.value)"
        }
        
        var checksum = characterCounts.sorted { (l, r) in
            if l.value > r.value {
                return true
            }
            
            if l.value == r.value && l.key < r.key {
                return true
            }
            
            return false
            }
            .map {  $0.key }
            .map { String($0) }
            .joined()
        
        if checksum.characters.count > 5 {
            checksum = checksum.substring(to: checksum.index(checksum.startIndex, offsetBy: 5))
        }
        
        return checksum
    }
    
    var sectorID: Int? {
        guard mainComponents.count == 2 else {
            return nil
        }
        
        guard let sector = mainComponents[0]
            .components(separatedBy: dashSet)
            .last
            .flatMap({ (a) -> Int? in
                Int(a)
            }) else { return nil }
        
        return sector
    }
    
    var isRealRoom: Bool {
        guard mainComponents.count == 2 else {
            return false
        }
        
        let letters = mainComponents[0]
            .components(separatedBy: dashSet)
            .joined()
        
        let givenChecksum = mainComponents[1]
        let computedChecksum = letters.checksum
        
        return givenChecksum == computedChecksum
    }
    
    var decrypted: String? {
        guard isRealRoom, let sectorID = sectorID
            else { return nil }
        
        let shift = sectorID % 26
        
        return mainComponents[0]
            .components(separatedBy: dashSet)
            .map { 
                let newScalars = $0.unicodeScalars
                    .map { (scalar) -> UnicodeScalar in  
                        guard CharacterSet.letters.contains(scalar) else { return scalar
                        }
                        
                    let shifted = UnicodeScalar(scalar.value + UInt32(shift))
                
                    if shifted! > UnicodeScalar("z")! {
                        return UnicodeScalar(shifted!.value - UInt32(26))!
                    }
                
                    return shifted!
                }
                
                var view = UnicodeScalarView(newScalars)
                
                return view.description
            }
            .joined(separator: " ")
    }
}

// Test Input
let testInput = "aaaaa-bbb-z-y-x-123[abxyz]\na-b-c-d-e-f-g-h-987[abcde]\nnot-a-real-room-404[oarel]\ntotally-real-room-200[decoy]"

testInput.enumerateLines { (line, _) in
    if (line.isRealRoom) {
        print("real")
    }
    else {
        print("decoy")
    }
}

// Real Input
guard let input = try? String(contentsOf: #fileLiteral(resourceName: "Advent of Code 2016 Day 4 Input.txt"))
    else { fatalError("Couldn't load input") }

// Part 1
var realRooms: [String] = []
input.enumerateLines(invoking:  { (line, _) in
    if line.isRealRoom {
        realRooms.append(line)
    }
})

let sum = realRooms.reduce(0) { (sum, roomString) in
    if let sectorID = roomString.sectorID {
        return sum + sectorID
    }
    
    return sum
}

sum

// Part 2
let decrypted = realRooms.flatMap { $0.decrypted }

let north = decrypted.filter {
    $0.contains("north")
    }.filter {
        $0.contains("pole")
}

north

