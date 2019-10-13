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
