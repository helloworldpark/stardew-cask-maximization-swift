//
//  main.swift
//  stardew-cask-maximization-swift
//
//  Created by 박성현 on 2019/10/12.
//  Copyright © 2019 Sean Park. All rights reserved.
//

import Foundation

let world = World(width: 3, height: 4)
world.printWorld()

let worldCopied = world.copy() as! World
worldCopied.printWorld()

let world2 = World(path: "map_test.txt")
world2.printWorld()
