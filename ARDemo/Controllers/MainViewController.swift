//
//  MainViewController.swift
//  ARDemo
//
//  Created by Kelvin Kosbab on 12/26/17.
//  Copyright © 2017 Tack Mobile. All rights reserved.
//

import UIKit

class MainViewController : UIViewController {
  
  // MARK: - Static Accessors
  
  static func newViewController() -> MainViewController {
    return self.newViewController(fromStoryboardWithName: "Main")
  }
  
  // MARK: - Properties
  
  var arViewController: ARViewController? = nil
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.largeTitleDisplayMode = .never
    self.clearNavigationBarElements()
  }
  
  // MARK: - Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let arViewController = segue.destination as? ARViewController {
      arViewController.trackingStateDelegate = self
      self.arViewController = arViewController
    }
  }
  
  // MARK: - Navigation Items
  
  func loadConfiguredNavigationBar() {
    self.navigationItem.title = "Tack Dragon"
    self.navigationItem.hidesBackButton = false
  }
  
  func clearNavigationBarElements() {
    self.navigationItem.title = nil
    self.navigationItem.leftBarButtonItem = nil
    self.navigationItem.rightBarButtonItem = nil
    self.navigationItem.hidesBackButton = true
  }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension MainViewController : UIPopoverPresentationControllerDelegate {
  
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
}

// MARK: - ARStateDelegate

extension MainViewController : ARStateDelegate {
  
  func arStateDidUpdate(_ state: ARState) {
    switch state {
    case .configuring:
      self.title = "Configuring"
    case .limited(.insufficientFeatures):
      self.title = "Insufficent Features"
    case .limited(.excessiveMotion):
      self.title = "Excessive Motion"
    case .limited(.initializing):
      self.title = "Initializing"
    case .normal:
      self.title = "Tack Dragon"
    case .notAvailable:
      self.title = "❌ Not Available ❌"
    }
  }
}
