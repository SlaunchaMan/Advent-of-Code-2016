import Foundation

let input = "L5, R1, R4, L5, L4, R3, R1, L1, R4, R5, L1, L3, R4, L2, L4, R2, L4, L1, R3, R1, R1, L1, R1, L5, R5, R2, L5, R2, R1, L2, L4, L4, R191, R2, R5, R1, L1, L2, R5, L2, L3, R4, L1, L1, R1, R50, L1, R1, R76, R5, R4, R2, L5, L3, L5, R2, R1, L1, R2, L3, R4, R2, L1, L1, R4, L1, L1, R185, R1, L5, L4, L5, L3, R2, R3, R1, L5, R1, L3, L2, L2, R5, L1, L1, L3, R1, R4, L2, L1, L1, L3, L4, R5, L2, R3, R5, R1, L4, R5, L3, R3, R3, R1, R1, R5, R2, L2, R5, L5, L4, R4, R3, R5, R1, L3, R1, L2, L2, R3, R4, L1, R4, L1, R4, R3, L1, L4, L1, L5, L2, R2, L1, R1, L5, L3, R4, L1, R5, L5, L5, L1, L3, R1, R5, L2, L4, L5, L1, L1, L2, R5, R5, L4, R3, L2, L1, L3, L4, L5, L5, L2, R4, R3, L5, R4, R2, R1, L5"

enum Direction {
    case north
    case south
    case east
    case west
    
    var right: Direction {
        switch self {
        case .north:
            return .east
            
        case .south:
            return .west
            
        case .east:
            return .south
            
        case .west:
            return .north
        }
    }
    
    var left: Direction {
        switch self {
        case .north:
            return .west
            
        case .south:
            return .east
            
        case .east:
            return .north
            
        case .west:
            return .south
        }
    }
}

enum TurnDirection: String {
    case left = "L"
    case right = "R"
}

struct Coordinate {
    let x: Int
    let y: Int
    
    static func +(lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        return Coordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    func coordinates(spaces distance: Int, inDirection direction: Direction) -> [Coordinate] {
        var newCoordinates: [Coordinate] = []
        
        for i in 1 ... distance {
            
            let newCoordinate: Coordinate
        switch direction {
        case .north:
            newCoordinate = Coordinate(x: 0, y: i)
            
        case .south:
            newCoordinate = Coordinate(x: 0, y: -i)
            
        case .east:
            newCoordinate = Coordinate(x: i, y: 0)
            
        case .west:
            newCoordinate = Coordinate(x: -i, y: 0)
        }
        
        newCoordinates.append(self + newCoordinate)
        }
        
        return newCoordinates
    }
}

extension Coordinate: Equatable {
    static func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

struct Instruction {
    let turnDirection: TurnDirection
    let distance: Int
    
    init?(string: String) {
        let index = string.index(string.startIndex, offsetBy: 1)
        
        guard let turnDirection = TurnDirection(rawValue: string.substring(to: index)),
            let distance = Int(string.substring(from: index))
            else { return nil }
        
        self.turnDirection = turnDirection
        self.distance = distance
    }
}

struct Position {
    let coordinate: Coordinate
    let heading: Direction
    
    func positions(followingInstruction instruction: Instruction) -> [Position] {
        let newHeading: Direction
        
        switch instruction.turnDirection {
        case .right:
            newHeading = self.heading.right
            
        case .left:
            newHeading = self.heading.left
        }
        
        return self.coordinate.coordinates(spaces: instruction.distance, inDirection: newHeading)
            .map { Position(coordinate: $0, heading: newHeading) }
    }
}

let origin = Coordinate(x: 0, y: 0)
let initialPosition = Position(coordinate: origin, heading: .north)

let instructions = input
    .components(separatedBy: ", " as String)
    .flatMap(Instruction.init(string:))

// Part 1
//let finalDestination: Coordinate = instructions 
//.reduce(initialPosition) { $0.positions(followingInstruction: $1).last ?? $0}
//.coordinate

//let distance = abs(finalDestination.x) + abs(finalDestination.y)

// Part 2
var currentPosition = initialPosition
var visitedCoordinates: [Coordinate] = []
var firstCoordinateVisitedTwice: Coordinate? = nil

instructionLoop: for instruction in instructions {
    for newPosition in currentPosition.positions(followingInstruction: instruction) {
        if visitedCoordinates.contains(newPosition.coordinate) {
            firstCoordinateVisitedTwice = newPosition.coordinate
            break instructionLoop
        }
        else {
            visitedCoordinates.append(newPosition.coordinate)
        }
    
        currentPosition = newPosition
    }
}

visitedCoordinates
firstCoordinateVisitedTwice
guard let coordinate = firstCoordinateVisitedTwice else { fatalError("Didn't visit anything twice.") }

let secondDistance = abs(coordinate.x) + abs(coordinate.y)

