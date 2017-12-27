//
//  PermissionsViewController.swift
//  ARDemo
//
//  Created by Kelvin Kosbab on 12/26/17.
//  Copyright © 2017 Tack Mobile. All rights reserved.
//

import UIKit

protocol PermissionsViewControllerDelegate : class {
  func didAuthorizeAllPermissions()
}

class PermissionsViewController : UIViewController {
  
  // MARK: - Static Accessors
  
  private static func newViewController() -> PermissionsViewController {
    return self.newViewController(fromStoryboardWithName: "Main")
  }
  
  static func newViewController(delegate: PermissionsViewControllerDelegate?) -> PermissionsViewController {
    let viewController = self.newViewController()
    viewController.delegate = delegate
    return viewController
  }
  
  // MARK: - Properties
  
  @IBOutlet weak var cameraPermissionButton: UIButton!
  @IBOutlet weak var cameraPermissionActivityIndicator: UIActivityIndicatorView!
  
  weak var delegate: PermissionsViewControllerDelegate? = nil
  var isCameraAuthorized: Bool = CameraPermissionManager.shared.isAccessAuthorized
  var isCameraNotDetermined: Bool = CameraPermissionManager.shared.isAccessNotDetermined
  
  var areAllPermissionAuthorized: Bool {
    return self.isCameraAuthorized
  }
  
  // MARK: - Lifecycle
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    CameraPermissionManager.shared.authorizationDelegate = self
    self.isCameraAuthorized = CameraPermissionManager.shared.isAccessAuthorized
    self.isCameraNotDetermined = CameraPermissionManager.shared.isAccessNotDetermined
    self.reloadContent()
  }
  
  // MARK: - Content
  
  func reloadContent() {
    
    // Camera
    self.cameraPermissionActivityIndicator.stopAnimating()
    self.cameraPermissionActivityIndicator.isHidden = true
    self.cameraPermissionButton.isUserInteractionEnabled = true
    self.cameraPermissionButton.isHidden = false
    if self.isCameraAuthorized {
      self.cameraPermissionButton.setTitle("Camera Access Granted", for: .normal)
      self.cameraPermissionButton.isUserInteractionEnabled = false
      self.cameraPermissionButton.setTitleColor(.lightGray, for: .normal)
    } else {
      self.cameraPermissionButton.setTitle("Allow Camera Access", for: .normal)
      self.cameraPermissionButton.isUserInteractionEnabled = true
      self.cameraPermissionButton.setTitleColor(.cyan, for: .normal)
    }
  }
  
  // MARK: - Actions
  
  @IBAction func cameraPermissionButtonSelected() {
    
    // Check if access has been denied - Settings
    guard self.isCameraNotDetermined else {
      self.showSettingsAlert()
      return
    }
    
    // Show loading
    self.cameraPermissionActivityIndicator.isHidden = false
    self.cameraPermissionActivityIndicator.startAnimating()
    self.cameraPermissionButton.isUserInteractionEnabled = false
    self.cameraPermissionButton.isHidden = true
    
    // Request permissions
    CameraPermissionManager.shared.requestAuthorization()
  }
  
  private func showSettingsAlert() {
    let alertController = UIAlertController (title: "Action Required", message: "Go to Settings?", preferredStyle: .alert)
    
    let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ -> Void in
      
      guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
        return
      }
      
      if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.open(settingsUrl)
      }
    }
    alertController.addAction(settingsAction)
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    alertController.addAction(cancelAction)
    
    self.present(alertController, animated: true, completion: nil)
  }
}

// MARK: - CameraPermissionDelegate

extension PermissionsViewController : CameraPermissionDelegate {
  
  func cameraPermissionManagerDidUpdateAuthorization(isAuthorized: Bool) {
    self.isCameraAuthorized = isAuthorized
    if self.areAllPermissionAuthorized {
      self.delegate?.didAuthorizeAllPermissions()
    }
    
    // Update the content
    self.reloadContent()
  }
}
