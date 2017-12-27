//
//  ARSCNView.swift
//  ARDemo
//
//  Created by Kelvin Kosbab on 12/26/17.
//  Copyright © 2017 Tack Mobile. All rights reserved.
//

import ARKit
import SceneKit

extension ARSCNView {
  
  func setUp(delegate: ARSCNViewDelegate, session: ARSession) {
    self.delegate = delegate
    self.session = session
    self.antialiasingMode = .multisampling4X
    self.automaticallyUpdatesLighting = false
    self.preferredFramesPerSecond = 60
    self.contentScaleFactor = 1.3
    self.enableEnvironmentMapWithIntensity(25.0)
    if let camera = self.pointOfView?.camera {
      camera.wantsHDR = true
      camera.wantsExposureAdaptation = true
      camera.exposureOffset = -1
      camera.minimumExposure = -1
    }
  }
  
  func enableEnvironmentMapWithIntensity(_ intensity: CGFloat) {
    if self.scene.lightingEnvironment.contents == nil {
      if let environmentMap = UIImage(named: "Models.scnassets/sharedImages/environment_blur.exr") {
        self.scene.lightingEnvironment.contents = environmentMap
      }
    }
    self.scene.lightingEnvironment.intensity = intensity
  }
}
