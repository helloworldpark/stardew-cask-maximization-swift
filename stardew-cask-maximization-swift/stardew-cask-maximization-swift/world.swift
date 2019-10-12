//
//  world.swift
//  stardew-cask-maximization-swift
//
//  Created by 박성현 on 2019/10/12.
//  Copyright © 2019 Sean Park. All rights reserved.
//

import Foundation

class World {
    
    let nodes: [Node]
    
    init(width: Int, height: Int) {
        var nodes: [Node] = []
        for _ in 0..<(width+2) {
            for _ in 0..<(height+2) {
                nodes.append(Node(state: .dummy))
            }
        }
        
        func idxFunc(i: Int, j: Int) -> Int {
            return i * (width+2) + j
        }
        
        for i in 1..<(height+1) {
            for j in 1..<(width+1) {
                let centerIdx = i * (width+2) + j
                let node = nodes[centerIdx]
                
                var idx = -1
                idx = idxFunc(i: i-1, j: j)
                var neighbor = nodes[idx]
                neighbor.state = .empty
                node.appendNeighbor(node: neighbor, at: .north)
                
                idx = idxFunc(i: i+1, j: j)
                neighbor = nodes[idx]
                neighbor.state = .empty
                node.appendNeighbor(node: neighbor, at: .north)
                
                idx = idxFunc(i: i, j: j-1)
                neighbor = nodes[idx]
                neighbor.state = .empty
                node.appendNeighbor(node: neighbor, at: .north)
                
                idx = idxFunc(i: i, j: j+1)
                neighbor = nodes[idx]
                neighbor.state = .empty
                node.appendNeighbor(node: neighbor, at: .north)
                
                idx = idxFunc(i: i-1, j: j-1)
                neighbor = nodes[idx]
                neighbor.state = .empty
                node.appendNeighbor(node: neighbor, at: .north)
                
                idx = idxFunc(i: i+1, j: j-1)
                neighbor = nodes[idx]
                neighbor.state = .empty
                node.appendNeighbor(node: neighbor, at: .north)
                
                idx = idxFunc(i: i-1, j: j+1)
                neighbor = nodes[idx]
                neighbor.state = .empty
                node.appendNeighbor(node: neighbor, at: .north)
                
                idx = idxFunc(i: i+1, j: j+1)
                neighbor = nodes[idx]
                neighbor.state = .empty
                node.appendNeighbor(node: neighbor, at: .north)
            }
        }
        
        
        self.nodes = nodes
    }
}
