//
//  VirtualObject.swift
//  ARDemo
//
//  Created by Kelvin Kosbab on 12/27/17.
//  Copyright © 2017 Tack Mobile. All rights reserved.
//

import SceneKit

class VirtualObject : SCNNode {
  
  // MARK: - Properties
  
  var modelName: String {
    return "UNDEFINED_VIRTUAL_OBJECT"
  }
  
  var fileExtension: String {
    return "scn"
  }
  
  var modelLoaded: Bool = false
  weak var baseWrapperNode: SCNNode? = nil
  
  // MARK: - Init
  
  func loadModel(completion: @escaping () -> Void) {
    DispatchQueue.global().async { [weak self] in
      
      guard let strongSelf = self else {
        return
      }
      
      let virtualObjectScene: SCNScene
      if let scene = SCNScene(named: "\(strongSelf.modelName).\(strongSelf.fileExtension)", inDirectory: "Models.scnassets/") {
        virtualObjectScene = scene
      } else {
        Log.log("Virtual object '\(strongSelf.modelName).\(strongSelf.fileExtension)' is undefined. Using empty scene.")
        virtualObjectScene = SCNScene()
      }
      
      let wrapperNode = SCNNode()
      strongSelf.baseWrapperNode = wrapperNode
      
      for child in virtualObjectScene.rootNode.childNodes {
        wrapperNode.addChildNode(child)
      }
      
      DispatchQueue.main.async { [weak self] in
        self?.addChildNode(wrapperNode)
        self?.modelLoaded = true
        completion()
      }
    }
  }
  
  func unloadModel() {
    for child in self.childNodes {
      child.removeFromParentNode()
    }
    
    self.modelLoaded = false
  }
}
