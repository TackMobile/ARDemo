//
//  ARViewController.swift
//  ARDemo
//
//  Created by Kelvin Kosbab on 12/26/17.
//  Copyright © 2017 Tack Mobile. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ARViewController : UIViewController {
  
  // MARK: - Properties
  
  @IBOutlet weak var sceneView: ARSCNView!
  
  weak var trackingStateDelegate: ARStateDelegate? = nil
  private let session = ARSession()
  private let sessionConfig = ARWorldTrackingConfiguration()
  
  // MARK: - AR Scene Properties
  
  private var currentCameraTrackingState: ARCamera.TrackingState? = nil {
    didSet {
      self.trackingStateDelegate?.arStateDidUpdate(self.state)
    }
  }
  
  var state: ARState {
    guard let currentCameraTrackingState = self.currentCameraTrackingState else {
      return .configuring
    }
    
    switch currentCameraTrackingState {
    case .limited(.insufficientFeatures):
      return .limited(.insufficientFeatures)
    case .limited(.excessiveMotion):
      return .limited(.excessiveMotion)
    case .limited(.initializing):
      return .limited(.initializing)
    case .normal:
      return .normal
    case .notAvailable:
      return .notAvailable
    }
  }
  
  var sceneViewCenter: CGPoint {
    return self.sceneView.bounds.mid
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Setup the scene
    self.sceneView.setUp(delegate: self, session: self.session)
    
    // Listen for taps
    self.registerTapRecognizer()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Set idle timer flag
    UIApplication.shared.isIdleTimerDisabled = true
    
    // Start / restart plane detection
    self.restartPlaneDetection()
    
    // Check camera tracking state
    self.trackingStateDelegate?.arStateDidUpdate(self.state)
    
    // Notifications
    NotificationCenter.default.addObserver(self, selector: #selector(self.restartPlaneDetection), name: .UIApplicationDidBecomeActive, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.pauseScene), name: .UIApplicationWillResignActive, object: nil)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    // Reset idle timer flat
    UIApplication.shared.isIdleTimerDisabled = true
    
    // Pause the AR scene
    self.pauseScene()
    
    // Check camera tracking state
    self.trackingStateDelegate?.arStateDidUpdate(self.state)
    
    // Remove self from notifications
    NotificationCenter.default.removeObserver(self, name: .UIApplicationDidBecomeActive, object: nil)
    NotificationCenter.default.removeObserver(self, name: .UIApplicationWillResignActive, object: nil)
  }
  
  // MARK: - Scene
  
  @objc func pauseScene() {
    self.session.pause()
  }
  
  @objc func restartPlaneDetection() {
    
    // Remove all nodes
    self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
      node.removeFromParentNode()
    }
    
    // Configure session
    self.sessionConfig.planeDetection = .horizontal
    self.sessionConfig.isLightEstimationEnabled = true
    self.sessionConfig.worldAlignment = .gravityAndHeading
    self.session.run(self.sessionConfig, options: [.resetTracking, .removeExistingAnchors])
  }
  
  // MARK: - Hit Detection
  
  func registerTapRecognizer() {
    let tapGestureRecognizer = UITapGestureRecognizer(target:self ,action : #selector(self.screenTapped(_:)))
    self.sceneView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  @objc func screenTapped(_ tapRecognizer: UITapGestureRecognizer) {
    let tappedLocation = tapRecognizer.location(in: self.sceneView)
    let hitResults = self.sceneView.hitTest(tappedLocation, options: [:])
    
    // Check if the user tapped a dragon
    if let dragonNode = hitResults.first?.node.parent as? DragonNode {
      
      // Toggle the dragon animation
      dragonNode.isPaused = !dragonNode.isPaused
    }
  }
  
  // MARK: - Dragon Nodes
  
  func addDragon(to anchor: ARPlaneAnchor) {
    let dragonNode = DragonNode()
    dragonNode.loadModel { [weak self] in
      
      // Scale the dragon
      let scale: Float = 0.01
      dragonNode.scale = SCNVector3(x: scale, y: scale, z: scale)
      
      // Position the dragon
      let position = anchor.transform
      dragonNode.position = SCNVector3(x: position.columns.3.x, y: position.columns.3.y, z: position.columns.3.z)
      
      // Pause any animations
      dragonNode.isPaused = true
      
      // Add the dragon to the scene
      self?.sceneView.scene.rootNode.addChildNode(dragonNode)
    }
  }
}

// MARK: - ARSCNViewDelegate

extension ARViewController : ARSCNViewDelegate {
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    Log.logMethodExecution()
    
    guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
    
//    if self.planeAnchor == nil {
//      self.planeAnchor = planeAnchor
    
      // Clear out the debugging options once a plane has been detected
      self.sceneView.debugOptions = []
    self.addDragon(to: planeAnchor)
//    }
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    Log.logMethodExecution()
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
    Log.logMethodExecution()
  }
  
  func sessionWasInterrupted(_ session: ARSession) {
    Log.extendedLog("Session was interrupted")
  }
  
  func sessionInterruptionEnded(_ session: ARSession) {
    Log.extendedLog("Session interruption ended")
  }
  
  func session(_ session: ARSession, didFailWithError error: Error) {
    Log.extendedLog("Session did fail with error: \(error.localizedDescription)")
  }
  
  func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
    self.currentCameraTrackingState = camera.trackingState
    switch camera.trackingState {
    case .limited(.insufficientFeatures):
      Log.extendedLog("camera did change tracking state: limited, insufficient features")
    case .limited(.excessiveMotion):
      Log.extendedLog("camera did change tracking state: limited, excessive motion")
    case .limited(.initializing):
      Log.extendedLog("camera did change tracking state: limited, initializing")
    case .normal:
      Log.extendedLog("camera did change tracking state: normal")
    case .notAvailable:
      Log.extendedLog("camera did change tracking state: not available")
    }
  }
}
