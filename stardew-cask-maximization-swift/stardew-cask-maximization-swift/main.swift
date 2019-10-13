//
//  main.swift
//  stardew-cask-maximization-swift
//
//  Created by 박성현 on 2019/10/12.
//  Copyright © 2019 Sean Park. All rights reserved.
//

import Foundation

let world = World(width: 3, height: 3)
let farmer = Farmer(start: world.startingNode[0], world: world)
farmer.install()

print()
print("-------------------")
print()

let world2 = World(path: "map_test.txt")
let farmer2 = Farmer(start: world2.startingNode[0], world: world2)
farmer2.install()

