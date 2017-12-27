//
//  SCNVector3+Util.swift
//  ARDemo
//
//  Created by Kelvin Kosbab on 12/27/17.
//  Copyright © 2017 Tack Mobile. All rights reserved.
//

import SceneKit

extension SCNVector3 {
  
  init(_ vec: vector_float3) {
    self.x = vec.x
    self.y = vec.y
    self.z = vec.z
  }
  
  func length() -> Float {
    return sqrtf(x * x + y * y + z * z)
  }
  
  mutating func setLength(_ length: Float) {
    self.normalize()
    self *= length
  }
  
  mutating func setMaximumLength(_ maxLength: Float) {
    if self.length() <= maxLength {
      return
    } else {
      self.normalize()
      self *= maxLength
    }
  }
  
  mutating func normalize() {
    self = self.normalized()
  }
  
  func normalized() -> SCNVector3 {
    if self.length() == 0 {
      return self
    }
    
    return self / self.length()
  }
  
  static func positionFromTransform(_ transform: matrix_float4x4) -> SCNVector3 {
    return SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
  }
  
  func friendlyString() -> String {
    return "(\(String(format: "%.2f", x)), \(String(format: "%.2f", y)), \(String(format: "%.2f", z)))"
  }
  
  func dot(_ vec: SCNVector3) -> Float {
    return (self.x * vec.x) + (self.y * vec.y) + (self.z * vec.z)
  }
  
  func cross(_ vec: SCNVector3) -> SCNVector3 {
    return SCNVector3(self.y * vec.z - self.z * vec.y, self.z * vec.x - self.x * vec.z, self.x * vec.y - self.y * vec.x)
  }
  
  func distance(toVector vec: SCNVector3) -> Float {
    return sqrtf(powf(vec.x - self.x, 2) + powf(vec.y - self.y, 2) + powf(vec.z - self.z, 2))
  }
  
  func angleTo(position: SCNVector3) -> Float {
    return acosf(self.dot(position) / (self.length() * position.length()))
  }
}

public let SCNVector3One: SCNVector3 = SCNVector3(1.0, 1.0, 1.0)

func SCNVector3Uniform(_ value: Float) -> SCNVector3 {
  return SCNVector3Make(value, value, value)
}

func SCNVector3Uniform(_ value: CGFloat) -> SCNVector3 {
  return SCNVector3Make(Float(value), Float(value), Float(value))
}

func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
  return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
  return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}

func += (left: inout SCNVector3, right: SCNVector3) {
  left = left + right
}

func -= (left: inout SCNVector3, right: SCNVector3) {
  left = left - right
}

func / (left: SCNVector3, right: Float) -> SCNVector3 {
  return SCNVector3Make(left.x / right, left.y / right, left.z / right)
}

func * (left: SCNVector3, right: Float) -> SCNVector3 {
  return SCNVector3Make(left.x * right, left.y * right, left.z * right)
}

func /= (left: inout SCNVector3, right: Float) {
  left = left / right
}

func *= (left: inout SCNVector3, right: Float) {
  left = left * right
}
