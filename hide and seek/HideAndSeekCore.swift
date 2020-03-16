//
//  HideAndSeekCore.swift
//  hide and seek
//
//  Created by Yasushi Sakai on 3/15/20.
//  Copyright © 2020 Yasushi Sakai. All rights reserved.
//

import Foundation

class HideAndSeekCore {
    
    func generateProof() {
        let proof = prove("{\"value\":2}")
        
        let mirror = Mirror(reflecting: proof.bytes)
        let elements = mirror.children.map({$0.value})

        print(elements)
        
    }
    
}
