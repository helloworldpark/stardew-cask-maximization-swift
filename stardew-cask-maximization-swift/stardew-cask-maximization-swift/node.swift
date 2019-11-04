//
//  node.swift
//  stardew-cask-maximization-swift
//
//  Created by 박성현 on 2019/10/12.
//  Copyright © 2019 Sean Park. All rights reserved.
//

import Foundation

class Node: CustomStringConvertible, Equatable, Hashable {
    
    enum State {
        case dummy
        case empty
        case start
        case impossible
        case cask
    }
    
    enum Direction: Int {
        case north = 0
        case south = 1
        case east = 2
        case west = 3
        case northeast = 4
        case northwest = 5
        case southeast = 6
        case southwest = 7
        case center = 8
    }
    
    var state: State = .empty
    var neighbors: [WeakReference<Node>] = []
    var visited: Bool = false
    
    var accessible: Bool {
        if state == .dummy || state == .impossible {
            return false
        }
        return true
    }
    var coord: (i: Int, j: Int)
    
    init(state: State, i: Int, j: Int) {
        self.state = state
        self.coord = (i: i, j: j)
    }
    
    func appendNeighbor(node: Node, at: Direction) {
        if neighbors.isEmpty {
            for _ in 0..<8 {
                neighbors.append(WeakReference(Node(state: .dummy, i: -1, j: -1)))
            }
        }
        neighbors[at.rawValue] = WeakReference(node)
    }
    
    func neighbor(at: Direction) -> Node {
        return neighbors[at.rawValue].w!
    }
    
    func printNode() {
        switch state {
        case .dummy:
            print(".", terminator: "")
        case .empty:
            print(" ", terminator: "")
        case .cask:
            print("C", terminator: "")
        case .impossible:
            print("X", terminator: "")
        case .start:
            print("S", terminator: "")
        }
    }
    
    var description: String {
        return "(\(coord.i), \(coord.j)) \(state)"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(coord.i)
        hasher.combine(coord.j)
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.coord.i == rhs.coord.i && lhs.coord.j == rhs.coord.j
    }
    
//    func copy(with zone: NSZone? = nil) -> Any {
//        let copied = Node(state: self.state)
//        copied.neighbors = self.neighbors
//        copied.visited = self.visited
//
//        return copied
//    }
}
