//
//  RoutineContainerView.swift
//  SW_etapa_IV
//
//  Created by Mario Canto on 7/27/18.
//  Copyright © 2018 Aldo Gutierrez Montoya. All rights reserved.
//

import UIKit

@IBDesignable
final class RoutineContainerView: UIView {

    enum ContainerType: Int {
        case normal
        case large
    }
    
    var _containerType: ContainerType = .normal
    @IBInspectable
    var containerType: Int {
        set {
            guard let type = ContainerType(rawValue: newValue) else {
                return
            }
            _containerType = type
        }
        get {
            return _containerType.rawValue
        }
    }
    
    
    override open var bounds: CGRect {
        didSet(oldBounds) {
            if oldBounds.height != bounds.height {
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    override open var frame: CGRect {
        didSet(oldBounds) {
            if oldBounds.height != frame.height {
                invalidateIntrinsicContentSize()
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        switch _containerType {
        case .normal:
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 7.0)
        case .large:
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 4.0)
        }
    }

}
