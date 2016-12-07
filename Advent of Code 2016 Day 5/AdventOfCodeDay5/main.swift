//
//  main.swift
//  AdventOfCodeDay5
//
//  Created by Jeff Kelley on 12/5/16.
//  Copyright © 2016 Jeff Kelley. All rights reserved.
//

import Foundation

extension String {
    
    var md5: String {
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        
        var digest = Array<UInt8>(repeating:0,
                                  count:Int(CC_MD5_DIGEST_LENGTH))
        
        CC_MD5_Init(context)
        CC_MD5_Update(context, self, CC_LONG(utf8.count))
        CC_MD5_Final(&digest, context)
        
        context.deallocate(capacity: 1)
        
        return digest
            .map { String(format:"%02x", $0) }
            .joined()
    }
    
    var startsWithFiveZeroes: Bool {
        return hasPrefix("00000")
    }
    
    var part1Password: String {
        var index = 0
        var password = String()
        
        while password.characters.count < 8 {
            index += 1
            
            let md5 = (self + String(index)).md5
            
            if md5.startsWithFiveZeroes {
                let sixthIndex = md5.characters.index(md5.characters.startIndex,
                                                      offsetBy: 5)
                
                let sixthCharacter = md5.characters[sixthIndex]
                
                password.append(sixthCharacter)
            }
        }
        
        return password
    }
    
    var part2Password: String {
        var index = 0
        
        var password = "________"
        
        while password.contains("_") {
            index += 1
            
            let md5 = (self + String(index)).md5
            
            if md5.startsWithFiveZeroes {
                let sixthIndex = md5.characters.index(md5.characters.startIndex,
                                                      offsetBy: 5)
                
                let sixthCharacter = md5.characters[sixthIndex]
                
                if let digit = Int(String(sixthCharacter)) {
                    guard digit < 8 else { continue }
                    
                    let seventh = md5.characters.index(md5.characters.startIndex,
                                                       offsetBy: 6)
                    
                    let seventhCharacter = md5.characters[seventh]
                    
                    let index = password.characters.index(password.characters.startIndex,
                                                          offsetBy: digit)
                    
                    if password.characters[index] == "_" {
                        password.remove(at: index)
                        password.insert(seventhCharacter, at: index)
                        print(password)
                    }
                }
            }
        }
        
        return password
    }
    
}

// Part 1
print("Starting at \(Date())")

print("abc")
print("Password of abc: \("abc".part1Password)")

print("cxdnnyjw")
print("Password of cxdnnyjw: \("cxdnnyjw".part1Password)")

// Part 2
print("abc")
print("Password of abc: \("abc".part2Password)")

print("cxdnnyjw")
print("Password of cxdnnyjw: \("cxdnnyjw".part2Password)")

print("Finishing at \(Date())")
