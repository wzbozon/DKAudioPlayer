//
//  DKImage.swift
//  
//
//  Created by Denis Kutlubaev on 07.10.2022.
//

import UIKit

internal func DKImage(named name: String) -> UIImage? {
    UIImage(named: name, in: Bundle.module, compatibleWith: nil)
}
