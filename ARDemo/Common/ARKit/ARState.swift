//
//  ARState.swift
//  ARDemo
//
//  Created by Kelvin Kosbab on 12/26/17.
//  Copyright © 2017 Tack Mobile. All rights reserved.
//

import ARKit

enum ARState {
  case configuring, normal, limited(Reason), notAvailable
  
  enum Reason {
    case insufficientFeatures, excessiveMotion, initializing
  }
}
