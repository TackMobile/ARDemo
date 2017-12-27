//
//  ARStateDelegate.swift
//  ARDemo
//
//  Created by Kelvin Kosbab on 12/26/17.
//  Copyright © 2017 Tack Mobile. All rights reserved.
//

import Foundation

protocol ARStateDelegate : class {
  func arStateDidUpdate(_ state: ARState)
}
