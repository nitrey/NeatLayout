//
//  CGRect+Center.swift
//  NeatLayoutTests
//
//  Created by Antonov Aleksandr on 04/04/2018.
//  Copyright © 2018 nitrey. All rights reserved.
//

import UIKit

// MARK: - Extension that simplifies CGRects' centers comparing

extension CGRect {
    
    var center: CGPoint {
        return CGPoint(x: self.origin.x + self.width * 0.5, y: self.origin.y + height * 0.5)
    }
    
}
