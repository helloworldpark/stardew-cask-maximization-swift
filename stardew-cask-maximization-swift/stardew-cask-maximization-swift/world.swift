//
//  world.swift
//  stardew-cask-maximization-swift
//
//  Created by 박성현 on 2019/10/12.
//  Copyright © 2019 Sean Park. All rights reserved.
//

import Foundation

class World: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let copied = World(width: self.width, height: self.height, nodes: self.nodes)
        return copied
    }
    
    let nodes: [Node]
    let startingNode: [Node]
    let width: Int
    let height: Int
    
    // For deep copy
    private init(width: Int, height: Int, nodes: [Node]) {
        self.width = width
        self.height = height
        var newNodes: [Node] = []
        for n in nodes {
            newNodes.append(n)
        }
        self.nodes = newNodes
        self.startingNode = self.nodes.filter { $0.state == .start }
    }
    
    init(width: Int, height: Int) {
        let nodes = World.createNodes(width: width, height: height) { _,_ in return .empty }
        
        self.nodes = nodes
        self.width = width
        self.height = height
        
        var startingNode = self.nodes.filter { $0.state == .start }
        if startingNode.isEmpty {
            self.nodes[1 * (width + 2) + 1].state = .start
            startingNode = self.nodes.filter { $0.state == .start }
        }
        self.startingNode = startingNode
    }
    
    init(path: String) {
        let dir = FileManager.default.currentDirectoryPath
        let fileURL = URL(fileURLWithPath: dir).appendingPathComponent(path)
        
        guard let map = try? String(contentsOf: fileURL) else {
            fatalError("Cannot read file \(fileURL.absoluteURL.absoluteString)")
        }
        
        let lineEnd = "\n"
        let impossible: Character = "X"
        let start: Character = "S"
        
        let parsed = map.components(separatedBy: lineEnd).filter { !$0.isEmpty }
        let height = parsed.count
        guard height > 0 else {
            fatalError("No valid map found")
        }
        let width = parsed.map { $0.count }.max()!
        
        let nodes = World.createNodes(width: width, height: height) { (i, j) -> Node.State in
            let row = parsed[i-1]
            let info = row[row.index(row.startIndex, offsetBy: j-1)]
            
            if info == impossible {
                return .impossible
            }
            if info == start {
                return .start
            }
            return .empty
        }
        
        self.nodes = nodes
        self.width = width
        self.height = height
        
        var startingNode = self.nodes.filter { $0.state == .start }
        if startingNode.isEmpty {
            self.nodes[1 * (width + 2) + 1].state = .start
            startingNode = self.nodes.filter { $0.state == .start }
        }
        self.startingNode = startingNode
    }
    
    func printWorld() {
        print("World Width: \(width), Height: \(height)")
        for i in 0..<(height+2) {
            for j in 0..<(width+2) {
                let idx = i * (width+2) + j
                nodes[idx].printNode()
            }
            print()
        }
    }
    
    private static func createNodes(width: Int, height: Int, stateModifier: (_ i: Int, _ j: Int)->Node.State ) -> [Node] {
        var nodes: [Node] = []
        for j in 0..<(width+2) {
            for i in 0..<(height+2) {
                nodes.append(Node(state: .dummy, i: i, j: j))
            }
        }
        
        func idxFunc(i: Int, j: Int) -> Int {
            return i * (width+2) + j
        }
        
        for i in 1..<(height+1) {
            for j in 1..<(width+1) {
                let centerIdx = i * (width+2) + j
                let node = nodes[centerIdx]
                
                node.state = stateModifier(i, j)
                
                var idx = -1
                idx = idxFunc(i: i-1, j: j)
                var neighbor = nodes[idx]
                node.appendNeighbor(node: neighbor, at: .north)
                
                idx = idxFunc(i: i+1, j: j)
                neighbor = nodes[idx]
                node.appendNeighbor(node: neighbor, at: .south)
                
                idx = idxFunc(i: i, j: j-1)
                neighbor = nodes[idx]
                node.appendNeighbor(node: neighbor, at: .west)
                
                idx = idxFunc(i: i, j: j+1)
                neighbor = nodes[idx]
                node.appendNeighbor(node: neighbor, at: .east)
                
                idx = idxFunc(i: i-1, j: j-1)
                neighbor = nodes[idx]
                node.appendNeighbor(node: neighbor, at: .northwest)
                
                idx = idxFunc(i: i+1, j: j-1)
                neighbor = nodes[idx]
                node.appendNeighbor(node: neighbor, at: .southwest)
                
                idx = idxFunc(i: i-1, j: j+1)
                neighbor = nodes[idx]
                node.appendNeighbor(node: neighbor, at: .northeast)
                
                idx = idxFunc(i: i+1, j: j+1)
                neighbor = nodes[idx]
                node.appendNeighbor(node: neighbor, at: .southeast)
            }
        }
        
        return nodes
    }
}
