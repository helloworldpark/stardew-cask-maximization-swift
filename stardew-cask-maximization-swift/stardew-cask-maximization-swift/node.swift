//
//  node.swift
//  stardew-cask-maximization-swift
//
//  Created by 박성현 on 2019/10/12.
//  Copyright © 2019 Sean Park. All rights reserved.
//

import Foundation

class Node {
    
    enum State {
        case dummy
        case empty
        case start
        case path
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
}
