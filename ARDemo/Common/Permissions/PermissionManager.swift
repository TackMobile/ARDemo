//
//  PermissionManager.swift
//  ARDemo
//
//  Created by Kelvin Kosbab on 12/26/17.
//  Copyright © 2017 Tack Mobile. All rights reserved.
//

import Foundation

enum PermissionAuthorizationStatus {
  case authorized, denied, notDetermined
}

protocol PermissionManagerDelegate {
  var status: PermissionAuthorizationStatus { get }
  var isAccessAuthorized: Bool { get }
  var isAccessDenied: Bool { get }
  var isAccessNotDetermined: Bool { get }
}

struct PermissionManager : PermissionManagerDelegate {
  
  // MARK: - Singleton
  
  static let shared = PermissionManager()
  
  private init() {}
  
  // MARK: - Properties
  
  let cameraManager = CameraPermissionManager.shared
  
  // MARK: - PermissionManagerDelegate
  
  var status: PermissionAuthorizationStatus {
    let cameraStatus = self.cameraManager.status
    
    // Check authorized status
    if cameraStatus == .authorized {
      return .authorized
    }
    
    // Check not determiend status
    if cameraStatus == .notDetermined {
      return .notDetermined
    }
    
    // Access is denied
    return .denied
  }
  
  var isAccessAuthorized: Bool {
    return self.cameraManager.isAccessAuthorized
  }
  
  var isAccessDenied: Bool {
    return self.cameraManager.isAccessDenied
  }
  
  var isAccessNotDetermined: Bool {
    return self.cameraManager.isAccessNotDetermined
  }
}
