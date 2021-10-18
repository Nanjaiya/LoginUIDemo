//
//  Extension+UIView.swift
//  SignInDemo
//
//  Created by Nanjaiya on 10/10/21.
//

import UIKit

extension UIView
{
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable open var shadowRadius: CGFloat{
        get{
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable open var shadowColor: UIColor {
        get{
            return UIColor(cgColor: layer.shadowColor!)
        }
        set{
            layer.shadowColor = newValue.cgColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable open var shadowOpacity: CGFloat {
        
        get{
            return CGFloat(layer.shadowOpacity)
        }
        set{
            layer.shadowOpacity = Float(newValue)
            
        }
    }
    
    @IBInspectable var shadowOffset: CGPoint {
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
    }
}





