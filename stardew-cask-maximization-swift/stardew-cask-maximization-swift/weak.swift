//
//  weak.swift
//  stardew-cask-maximization-swift
//
//  Created by 박성현 on 2019/10/12.
//  Copyright © 2019 Sean Park. All rights reserved.
//

import Foundation

class WeakReference<T: AnyObject>: NSCopying {
    weak var w: T?
    
    init(_ w: T) {
        self.w = w
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return WeakReference(w!)
    }
}
