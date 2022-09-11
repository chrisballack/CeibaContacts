//
//  ViewConfig.swift
//  CeibaContacts
//
//  Created by Dev IOS on 11/09/22.
//

import Foundation
import UIKit

public protocol XIBShadow {
    
    var Shadowview: String? { get set }
    var DropShadowview: String? { get set }
    
}


extension UIView: XIBShadow {
    
    @IBInspectable
    public var DropShadowview: String? {
        
        get { return nil }
        
        set(key) {
            
            if key == "true"{
                
                self.backgroundColor = UIColor.clear
                self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
                self.layer.shadowOffset = CGSize(width: 0, height: 4)
                self.layer.shadowOpacity = 1
                self.layer.shadowRadius = 4.0
                
            }
            
        }
        
    }
    
    @IBInspectable
    public var Shadowview: String? {
        
        get { return nil }
        
        set(key) {
            
            if key == "true"{
                
                self.backgroundColor = UIColor.clear
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowOffset = CGSize(width: 2, height: 2)
                self.layer.shadowOpacity = 0.7
                self.layer.shadowRadius = 4.0
                
            }
            
        }
        
    }
    
    
}

@IBDesignable
class UIViewX: UIView {
    
    // MARK: - Border
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
}

@IBDesignable
class UIImageX: UIImageView {
    
    // MARK: - Border
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
}
