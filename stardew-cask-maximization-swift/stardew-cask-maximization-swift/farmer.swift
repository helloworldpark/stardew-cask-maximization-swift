//
//  farmer.swift
//  stardew-cask-maximization-swift
//
//  Created by 박성현 on 2019/10/12.
//  Copyright © 2019 Sean Park. All rights reserved.
//

import Foundation

// Farmer's objective
// 0. Fill the world to one of these:
//    1) Impossible
//    2) Cask
//    3) Empty
// 1. Travel the world and fill with cask as much as possible
//    This is equivalent to making a path as few as possible
// 2. Farmer can move freely to
//    1) Start <-> Empty
//    2) Empty <-> Empty
//    The possible directions are North, South, East, West only.
// 3. Farmer can access(i.e. touch cask) freely to
//    1) Start <-> Empty
//    2) Start -> Cask
//    3) Empty <-> Empty
//    4) Empty -> Cask
//    The possible directions are N, S, E, W, NE, NW, SE, SW only
// 4. Farmer can place cask freely to
//    1) Start -> Cask
//    2) Empty -> Cask
//    if the node is an empty state. If cask occupied, it can be destroyed.
//    The possible directions are N, S, E, W, NE, NW, SE, SW only
// 5. Farmer should travel as such:
//    1) Move N, S, W, E
//    2) Once moved, the node standing is marked 'visited'. Farmer does not visit 'visited' again unless the node is a deadend.
//    3) Move and install casks as much as possible. If deadend and no improvement on counts of casks, then roll back.
//    4) Deadend node is a node that no more proceeding is possible by 'impossibles' or 'dummy' state nodes.
//    5) If deadend can be resolved by removing casks accessible, then remove it
//    6) Save the result(the installation map) if casks installed are larger or equal to the last one.

class Farmer {
    
    private static let accessibleDirection: [Node.Direction] = [.north, .south, .east, .west, .northeast, .northwest, .southeast, .southwest]
    private static let walkableDirection: [Node.Direction] = [.north, .south, .east, .west]
    
    private var start: Node
    private let world: World
    private var caskCount: Int
    
    init(start: Node, world: World) {
        self.start = start
        self.world = world
        self.caskCount = 0
    }
    
    func install()  {
        var queue: [(last: Node, now: Node)] = [(last: self.start, now: self.start)]
        while queue.isEmpty == false {
            let popped = queue.removeLast()
            let next = moveAndInstall(last: popped.last, now: popped.now)
            if next.isEmpty {
                // Deadend
                print("Deadend")
            } else {
                // Can proceed
                for direction in next {
                    queue.append((last: popped.now, now: popped.now.neighbor(at: direction)))
                    print("Move to \(direction)")
                }
            }
            print("----------")
        }
        
        world.printWorld()
        print("Casks: \(self.caskCount)")
    }
    
    private func moveAndInstall(last: Node, now: Node) -> [Node.Direction] {
        guard now.visited == false else {
            print("Visited")
            return []
        }
        // 1. Install cask
        var modified: [Node] = []
        for d in Farmer.accessibleDirection {
            let node = now.neighbor(at: d)
            if node === last {
                continue
            }
            if node.state != .empty {
                continue
            }
            node.state = .cask
            modified.append(node)
            self.caskCount += 1
        }
        
        var modifiedNow = false
        if now.state == .cask {
            now.state = .empty
            self.caskCount -= 1
            modifiedNow = true
        }
        now.visited = true
        
        // 2. Check if deadend
        var possibleMovements: [Node.Direction] = []
        for d in Farmer.walkableDirection {
            let neighbor = now.neighbor(at: d)
            if neighbor.accessible {
                possibleMovements.append(d)
            }
        }
        let isDeadend = possibleMovements.isEmpty ? true : possibleMovements.reduce(false) { return $0 || !now.neighbor(at: $1).accessible }

        // 3. If deadend, rollback
        //    Else, proceed
        if isDeadend {
            for node in modified {
                node.state = .empty
                self.caskCount -= 1
            }
            if modifiedNow {
                now.state = .cask
                self.caskCount += 1
            }
            return []
        }
        
        return possibleMovements
    }
}
