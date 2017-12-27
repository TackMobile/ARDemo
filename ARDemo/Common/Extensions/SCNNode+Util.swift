//
//  SCNNode+Util.swift
//  ARDemo
//
//  Created by Kelvin Kosbab on 12/27/17.
//  Copyright © 2017 Tack Mobile. All rights reserved.
//

import SceneKit

extension SCNNode {
  
  // Scales a node to a specific size dimension
  func set(desiredSizeDimension maxSize: Float) {
    let boundingBox = self.boundingBox.max - self.boundingBox.min
    let maxNodeBound = max(boundingBox.x, max(boundingBox.y, boundingBox.z))
    let scale = maxSize / maxNodeBound
    self.scale = SCNVector3(x: scale, y: scale, z: scale)
  }
}
