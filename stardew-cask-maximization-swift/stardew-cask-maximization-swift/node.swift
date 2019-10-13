//
//  node.swift
//  stardew-cask-maximization-swift
//
//  Created by 박성현 on 2019/10/12.
//  Copyright © 2019 Sean Park. All rights reserved.
//

import Foundation

class Node: NSCopying {
    
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
    
    init(state: State) {
        self.state = state
    }
    
    func appendNeighbor(node: Node, at: Direction) {
        if neighbors.isEmpty {
            for _ in 0..<8 {
                neighbors.append(WeakReference(Node(state: .dummy)))
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
            print("O", terminator: "")
        case .cask:
            print("C", terminator: "")
        case .impossible:
            print("X", terminator: "")
        case .start:
            print("S", terminator: "")
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copied = Node(state: self.state)
        copied.neighbors = self.neighbors
        copied.visited = self.visited
        
        return copied
    }
}
