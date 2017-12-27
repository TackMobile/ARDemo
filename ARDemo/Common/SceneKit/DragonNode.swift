//
//  DragonNode.swift
//  ARDemo
//
//  Created by Kelvin Kosbab on 12/27/17.
//  Copyright © 2017 Tack Mobile. All rights reserved.
//

import SceneKit

class DragonNode : VirtualObject {
  
  // MARK: - Required
  
  override var modelName: String {
    return "Dragon 2.5_dae"
  }
  
  override var fileExtension: String {
    return "dae"
  }
  
  // MARK: - Load
  
  override func loadModel(completion: @escaping () -> Void) {
    super.loadModel { [weak self] in
      
      // Size this node to a 1m bounding box
      self?.baseWrapperNode?.set(desiredSizeDimension: 1)
      
      completion()
    }
  }
}
