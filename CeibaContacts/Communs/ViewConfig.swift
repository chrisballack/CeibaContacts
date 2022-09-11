//
//  ViewConfig.swift
//  CeibaContacts
//
//  Created by Dev IOS on 11/09/22.
//

import Foundation
import UIKit

var GlbAppName = "CeibaContacts"
var GlbErrorConexion = "Sorry, a server connection error has occurred, please contact FletX support."

func AlertErrorConexion(vista:UIViewController){
    
    DispatchQueue.main.async(execute: {
        
        let miAlerta = UIAlertController(title: GlbAppName, message: GlbErrorConexion, preferredStyle: UIAlertController.Style.alert)
        let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "HurmeGeometricSans3-SemiBold", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor(named: "Colorlabelscomunes")!]
        let titleString = NSAttributedString(string: GlbAppName, attributes: titleAttributes)
        let messageAttributes = [NSAttributedString.Key.font: UIFont(name: "HurmeGeometricSans3-Regular", size: 12)!, NSAttributedString.Key.foregroundColor: UIColor(named: "Colorlabelscomunes")!]
        let messageString = NSAttributedString(string: GlbErrorConexion, attributes: messageAttributes)
        
        miAlerta.setValue(messageString, forKey: "attributedMessage")
        miAlerta.setValue(titleString, forKey: "attributedTitle")
        let okBoton = UIAlertAction(title: NSLocalizedString("Accept", comment: "").capitalized, style: UIAlertAction.Style.cancel, handler: nil)
        miAlerta.addAction(okBoton)
        vista.present(miAlerta, animated: true, completion: nil)
        
        
        
    })
    
}


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
                self.layer.shadowColor = UIColor(named: "ShadowColor")!.cgColor
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
