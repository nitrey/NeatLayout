//
//  Edge.swift
//  NeatLayout
//
//  Created by Antonov Aleksandr on 06/04/2018.
//  Copyright © 2018 nitrey. All rights reserved.
//

import Foundation

public enum NLEdge {
    
    case left
    case top
    case right
    case bottom
    
    var axis: NLAxis {
        
        switch self {
            
        case .left, .right:
            return .horizontal
        case .top, .bottom:
            return .vertical
        }
    }
    
}
