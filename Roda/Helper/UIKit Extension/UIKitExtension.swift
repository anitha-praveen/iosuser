//
//  UIKitExtension.swift
//  Roda
//
//  Created by Apple on 23/03/22.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps
import Alamofire
import AWSS3
import AWSCore
import AWSCognito
import CommonCrypto

extension UIView {
   
    @discardableResult
    func applyGradient(radius: CGFloat) -> CAGradientLayer {
        return self.applyGradient(colours: [UIColor(red: 0.024, green: 0.027, blue: 0.035, alpha: 1), UIColor(red: 0.173, green: 0.184, blue: 0.212, alpha: 1),UIColor(red: 0.494, green: 0.404, blue: 0.157, alpha: 1)],radius: radius, locations: [0,1])
    }
    @discardableResult
    func applyGradient(colours: [UIColor],radius: CGFloat ,locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradient.locations = locations
        gradient.cornerRadius = radius
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}

extension UIButton  {
    
    func setAppImage(_ imageName: String) {
       
        self.tintColor = .txtColor
        self.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate).imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        
    }
}
extension UIView {
    func addBorder(edges: UIRectEdge, colour: UIColor = UIColor.themeColor, thickness: CGFloat = 1, leftPadding: CGFloat = 0, rightPadding: CGFloat = 0) -> Void {
        func border() -> UIView {
            let border = UIView()
            border.backgroundColor = colour
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",options: [],metrics: ["thickness": thickness],views: ["top": top]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",options: [],metrics: nil,views: ["top": top]))
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",options: [],metrics: ["thickness": thickness],views: ["left": left]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",options: [],metrics: nil,views: ["left": left]))
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",options: [],metrics: ["thickness": thickness],views: ["right": right]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",options: [],metrics: nil,views: ["right": right]))
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",options: [],metrics: ["thickness": thickness],views: ["bottom": bottom]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(leftPadding)-[bottom]-(rightPadding)-|",options: [],metrics: ["leftPadding": leftPadding,"rightPadding":rightPadding],views: ["bottom": bottom]))
        }
    }
    func addShadow(shadowColor: CGColor = UIColor.txtColor.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    func removeShadow() {
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0
        layer.shadowRadius = 0
        layer.shadowPath = nil
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func roundCornersWithShadow(corners: UIRectCorner, radius: CGFloat, shadowColor: CGColor = UIColor.txtColor.cgColor, shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0), shadowOpacity: Float = 0.4, shadowRadius: CGFloat = 3.0, fillColor: UIColor) {
        self.backgroundColor = .clear
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.fillColor = fillColor.cgColor
        mask.path = path.cgPath
        layer.insertSublayer(mask, at: 0)
        
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    func addLoader(_ color: UIColor = .txtColor)->CALayer {
        self.layoutIfNeeded()
        self.setNeedsLayout()
        let blackLayer = CALayer()
        blackLayer.frame = CGRect(x: 0, y: 0, width: 0, height: 3)
        blackLayer.backgroundColor = UIColor.txtColor.cgColor
        self.layer.addSublayer(blackLayer)
        
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.bounds.minX, y: self.bounds.minY))
        path.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.minY))
        
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = 0.5
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        blackLayer.add(animation, forKey: "position")
        
        let anim = CABasicAnimation(keyPath: "bounds")
        anim.duration = 0.25
        anim.autoreverses = true
        anim.repeatCount = Float.infinity
        anim.fromValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 10, height: 3))
        anim.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 150, height: 3))
        blackLayer.add(anim, forKey: "bounds")
        return blackLayer
    }
    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
extension UIColor {

    class var themeColor: UIColor {
        
        return .hexToColor("ffd60b")
    }
    
    class var secondThemeColor: UIColor {
        
        return UIColor.hexToColor("2F2E2E")
    }
    
    class var themeTxtColor: UIColor {
        
        return UIColor.hexToColor("000000")
    }
    
    
    static let txtColor = UIColor(red: 0.133, green: 0.169, blue: 0.271, alpha: 1)
    static let secondaryColor = UIColor.white
    static let darkGreen = UIColor(red: 0.0/255.0, green: 100.0/255.0, blue: 0.0/255.0, alpha: 1.0)

    static func hexToColor (_ hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

// Used for Dark theme
/*
extension UIColor {
    
    // Used for dark theme
    
    func inverseColor() -> UIColor {
        var alpha: CGFloat = 1.0
        
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: 1.0 - red, green: 1.0 - green, blue: 1.0 - blue, alpha: alpha)
        }
        
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: 1.0 - hue, saturation: 1.0 - saturation, brightness: 1.0 - brightness, alpha: alpha)
        }
        
        var white: CGFloat = 0.0
        if self.getWhite(&white, alpha: &alpha) {
            return UIColor(white: 1.0 - white, alpha: alpha)
        }
        
        return self
    }
    
    class var appThemeColor: UIColor {
        // return UIColor(red: 255.0/255.0, green: 57.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        return UIColor.hexToColor("ffd60b")
    }
    
    static let regTxtColor = UIColor.hexToColor("000000")
    
    static var themeColor: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    
                    return regTxtColor//.hexToColor("021A74")
                } else {
                    
                    return .appThemeColor
                }
            }
        } else {
            
            return .appThemeColor
        }
    }()
    
    static var txtColor: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    
                    return UIColor.white.withAlphaComponent(0.6)
                } else {
                    
                    return .regTxtColor
                }
            }
        } else {
            
            return .regTxtColor
        }
    }()
    
    static var secondaryColor: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    
                    return .secondarySystemBackground//UIColor.hexToColor("121212")//
                    
                } else {
                    
                    return .white
                }
            }
        } else {
            
            return .white
        }
    }()
     
     static func hexToColor (_ hex: String) -> UIColor {
         var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

         if (cString.hasPrefix("#")) {
             cString.remove(at: cString.startIndex)
         }

         if ((cString.count) != 6) {
             return UIColor.gray
         }

         var rgbValue:UInt64 = 0
         Scanner(string: cString).scanHexInt64(&rgbValue)
         
         if #available(iOS 13, *) {
             return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                 if UITraitCollection.userInterfaceStyle == .dark {
                     
                     return UIColor(
                         red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                         green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                         blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                         alpha: CGFloat(1.0)
                     ).inverseColor()
                     
                 } else {
                     
                     return UIColor(
                         red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                         green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                         blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                         alpha: CGFloat(1.0)
                     )
                 }
             }
         } else {
             
             return UIColor(
                 red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                 green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                 blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                 alpha: CGFloat(1.0)
             )
         }
     }
}
 */
 
extension UIButton
{
    func applyGradient(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIImage {
    static func ==(lhs: UIImage, rhs: UIImage)->Bool {
        if let lhsData = lhs.pngData(), let rhsData = rhs.pngData() {
            return lhsData == rhsData
        }
        return false
    }
}

extension String {
    var isBlank:Bool {
            return trimmingCharacters(in: .whitespaces).isEmpty
    }
    var isValidEmail:Bool {
            return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}").evaluate(with:self)
    }
    var isValidPhoneNumber:Bool {
            return NSPredicate(format: "SELF MATCHES %@", "^[0-9]{6,14}$").evaluate(with:self)
    }
}

extension UIFont {
    class func appTitleFont(ofSize:CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: ofSize) ?? UIFont.systemFont(ofSize:ofSize)
    }
    class func appBoldTitleFont(ofSize:CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Bold", size: ofSize) ?? UIFont.boldSystemFont(ofSize:ofSize)
    }
    class func appFont(ofSize:CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: ofSize) ?? UIFont.systemFont(ofSize:ofSize)
    }
    class func appBoldFont(ofSize:CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Bold", size: ofSize) ?? UIFont.boldSystemFont(ofSize:ofSize)
    }
     class func appRegularFont(ofSize:CGFloat) -> UIFont {
           return UIFont(name: "Roboto-Regular", size: ofSize) ?? UIFont.boldSystemFont(ofSize:ofSize)
    }
    class func appSemiBold(ofSize:CGFloat) -> UIFont {
           return UIFont(name: "Roboto-Medium", size: ofSize) ?? UIFont.boldSystemFont(ofSize:ofSize)
    }
    class func appMediumFont(ofSize:CGFloat) -> UIFont {
           return UIFont(name: "Roboto-Medium", size: ofSize) ?? UIFont.boldSystemFont(ofSize:ofSize)
    }
}

extension UIViewController {
    func showAlert(_ title :String? = nil , message: String? = nil)
    {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        if let title = title {
            let titleFont = [NSAttributedString.Key.font: UIFont.appBoldTitleFont(ofSize: 18)]
            let titleAttrString = NSAttributedString(string: title, attributes: titleFont)
            alert.setValue(titleAttrString, forKey: "attributedTitle")
        }
        if let message = message {
            let messageFont = [NSAttributedString.Key.font: UIFont.appFont(ofSize: 16)]
            let messageAttrString = NSAttributedString(string: message, attributes: messageFont)
            alert.setValue(messageAttrString, forKey: "attributedMessage")
        }
        let ok = UIAlertAction(title: "text_ok".localize(), style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

extension UIView {
    func showToast(_ message: String) {
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.secondaryColor
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.appFont(ofSize: 14)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        self.addSubview(toastLabel)
        toastLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        toastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 35).isActive = true
        toastLabel.centerXAnchor.constraint(equalTo: toastLabel.superview!.centerXAnchor).isActive = true
        toastLabel.centerYAnchor.constraint(equalTo: toastLabel.superview!.bottomAnchor, constant: -200).isActive = true
        toastLabel.superview?.layoutIfNeeded()
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension UINavigationItem {
    var backBtnString: String {
        get { return "" }
        set { self.backBarButtonItem = UIBarButtonItem(title: newValue, style: .plain, target: nil, action: nil) }
    }
}

extension UIColor {
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}


extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }

    open override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
}
class ShadowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    func setup()
    {

        self.layer.cornerRadius = 5.0
        self.layer.shadowColor = UIColor.txtColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 4.0
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
}


extension String {
    func localize() -> String {
        if RJKLocalize.shared.details.isEmpty {
            guard let path = try? FileManager().url(for: .documentDirectory, in: .userDomainMask,
                                                    appropriateFor: nil, create: true) else {
                return ""
            }
            let fooURL = path.appendingPathComponent("lang-\(APIHelper.currentAppLanguage).json")
            guard let data = try? Data(contentsOf: fooURL) else {
                return ""
            }
            do {
                if let details =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: String] {
                    RJKLocalize.shared.details = details
                    return RJKLocalize.shared.details[self] ?? ""
                }
            }
            catch {
                print("Localize can't parse your file", error)
            }
            return ""

        } else {
            return RJKLocalize.shared.details[self] ?? self//""
        }
    }
}
extension UIViewController {
    func dismissPresent(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let presentedViewController = self.presentedViewController {
            presentedViewController.dismiss(animated: false) {
                self.present(viewControllerToPresent, animated: animated, completion: completion)
            }
        } else {
            present(viewControllerToPresent, animated: animated, completion: completion)
        }
        
    }
}
extension UILabel {
    func set(text:String, with icon:UIImage?) {
        let attachment = NSTextAttachment()
        attachment.image = icon
        attachment.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
        let attachmentStr = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string: "")
        if APIHelper.appSemanticContentAttribute == .forceRightToLeft {
            myString.append(NSAttributedString(string: text))
            myString.append(NSAttributedString(string: " "))
            myString.append(attachmentStr)
        } else {
            myString.append(attachmentStr)
            myString.append(NSAttributedString(string: " "))
            myString.append(NSAttributedString(string: text))
        }
        attributedText = myString
    }
    
    func sets(text:String, with icon:UIImage?) {
        let attachment = NSTextAttachment()
        attachment.image = icon
        attachment.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
        let attachmentStr = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string: "")
        if APIHelper.appSemanticContentAttribute == .forceRightToLeft {
            myString.append(NSAttributedString(string: text))
            myString.append(NSAttributedString(string: " "))
            myString.append(attachmentStr)
        } else {
            myString.append(attachmentStr)
            myString.append(NSAttributedString(string: " "))
            myString.append(NSAttributedString(string: text))
        }
        attributedText = myString
    }
}

extension Notification.Name {
    static let tripStateChanged = NSNotification.Name("Trip state changed")
    static let locationChanged = NSNotification.Name("location changed")
    static let localToRental = NSNotification.Name("localToRental")
    static let driverRejected = NSNotification.Name("Driver Rejected")
    static let driverStarted = NSNotification.Name("DriverStarted")
    static let noDriverFound = NSNotification.Name("NoDriverRespondNotification")
    static let tripCancelled = NSNotification.Name("TripCancelledNotification")
    static let requestAnotherDriver = NSNotification.Name("RequestedAnotherDriver")
    static let anotherUserLogin = NSNotification.Name("AnotherLoginNotification")
    static let rideLaterNoCaptainFound = NSNotification.Name("rideLaterNoCaptainFound")
}



extension UITextField
{
    enum Direction
    {
        case Left
        case Right
    }
    
    func addImage(direction:Direction,imageName:String,frame:CGRect,backgroundColor:UIColor)
    {
        let view = UIView(frame: frame)
        view.backgroundColor = backgroundColor
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 25))
        imageView.center = view.center
        imageView.image = UIImage(named: imageName)
        
        view.addSubview(imageView)
        
        if direction == Direction.Left
        {
            self.leftViewMode = .always
            self.leftView = view
        }
        else
        {
            self.rightViewMode = .always
            self.rightView = view
        }
    }
    
    func padding(_ width: CGFloat) {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
    
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            leftViewMode = .always
            leftView = view
        } else {
            rightViewMode = .always
            rightView = view
        }
    }
    
}
extension UIView {
    func createDottedLine(width: CGFloat, color: CGColor) {
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = color
        caShapeLayer.lineWidth = width
        caShapeLayer.lineDashPattern = [1,2]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 0, y: 0), CGPoint(x:0, y: self.frame.height)]
        
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        layer.addSublayer(caShapeLayer)
    }
    func createVerticalDottedLine(width: CGFloat, color: CGColor) {
       let caShapeLayer = CAShapeLayer()
       caShapeLayer.strokeColor = color
       caShapeLayer.lineWidth = width
       caShapeLayer.lineDashPattern = [3,3]
       let cgPath = CGMutablePath()
       let cgPoint = [CGPoint(x: self.frame.width/2, y: 5), CGPoint(x: self.frame.width/2, y: self.frame.height-5)]
       cgPath.addLines(between: cgPoint)
       caShapeLayer.path = cgPath
       layer.addSublayer(caShapeLayer)
    }
}

class DateTimeTextField: UITextField {
    var datechanged:((Date)->Void)?
    var datePicker = UIDatePicker()
    var selectedate: Date?
    var formatter = DateFormatter()
    enum PickerType {
        case date
        case time
    }
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    convenience required init(_ type: PickerType) {
        self.init()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "text_Done".localize(), style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "text_cancel".localize(), style: .plain, target: self, action: #selector(cancelDatePicker))
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolbar.tintColor = .blue
        toolbar.barTintColor = .txtColor
        
        self.addTarget(self, action: #selector(txtDidChanged(_:)), for: .editingDidBegin)
        
        if type == .time {
            
            datePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 31, to: Date())
            datePicker.datePickerMode = .time
            formatter.dateFormat = "hh:mm aa"
            
        } else {
            datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
            datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
            datePicker.datePickerMode = .date
            datePicker.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "dd/MM/yyyy"
        }
        self.inputAccessoryView = toolbar
        self.inputView = datePicker
        
    }
    
    @objc func txtDidChanged(_ sender: UITextField) {
        
        datePicker.date = selectedate ?? Date()
    }
    
    @objc func donedatePicker() {
        let str = formatter.string(from: datePicker.date)
        self.text = str
        datechanged?(datePicker.date)
        selectedate = datePicker.date
        self.endEditing(true)
        datePicker.reloadInputViews()
    }
    
    @objc func cancelDatePicker() {
        self.endEditing(true)
    }
    
}

extension UITextField {
    
    func addIcon(_ image: UIImage?) {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let imgView = UIImageView()
        imgView.image = image
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        view.addSubview(imgView)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(4)-[imgView(20)]-(4)-|", options: [], metrics: nil, views: ["imgView":imgView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[imgView(width)]-(10)-|", options: [], metrics: ["width":image == nil ? 0 : 20], views: ["imgView":imgView]))
        
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            leftViewMode = .always
            leftView = view
        } else {
            rightViewMode = .always
            rightView = view
        }
    }
    func addRightIcon(_ image: UIImage?) {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let imgView = UIImageView()
        imgView.image = image
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        view.addSubview(imgView)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(4)-[imgView(20)]-(4)-|", options: [], metrics: nil, views: ["imgView":imgView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[imgView(width)]-(5)-|", options: [], metrics: ["width":image == nil ? 0 : 20], views: ["imgView":imgView]))
        
        if APIHelper.appLanguageDirection == .directionRightToLeft {
            leftViewMode = .always
            leftView = view
        } else {
            rightViewMode = .always
            rightView = view
        }
    }
}

extension UIButton {
    func leftImage(image: UIImage, renderMode: UIImage.RenderingMode) {
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: image.size.width / 2)
        self.contentHorizontalAlignment = .left
        self.imageView?.contentMode = .scaleAspectFit
    }

    func rightImage(image: UIImage, renderMode: UIImage.RenderingMode){
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left:image.size.width / 2, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .right
        self.imageView?.contentMode = .scaleAspectFill
    }
}

extension UIStackView {
    
    func customize(backgroundColor: UIColor = .clear, radiusSize: CGFloat = 0) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = backgroundColor
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)

        subView.layer.cornerRadius = radiusSize
        subView.layer.masksToBounds = true
        subView.clipsToBounds = true
    }
    
}
extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
extension UIView {
    func removeAllConstraints() {
        self.removeConstraints(self.constraints)
        self.subviews.forEach { $0.removeAllConstraints() }
    }
}

extension UIImage {
    func fixedOrientation() -> UIImage {

        if imageOrientation == .up {
            return self
        }

        var transform: CGAffineTransform = CGAffineTransform.identity

        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2)
        case .up, .upMirrored:
            break
        @unknown default:
            print("default")
        }

        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            print("default")
        }

        if let cgImage = self.cgImage, let colorSpace = cgImage.colorSpace,
            let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
            ctx.concatenate(transform)

            switch imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
            default:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }
            if let ctxImage: CGImage = ctx.makeImage() {
                return UIImage(cgImage: ctxImage)
            } else {
                return self
            }
        } else {
            return self
        }
    }
}

extension Dictionary where Key == String {
    func getInAmountFormat(str: String) -> String? {
        if let value = self[str] as? Double, value > 0 {
            return String(format: "%.2f", value)
        }
        return nil
    }
}

/*
 extension Dictionary where Key == String {
     func getInAmountFormat(str: String) -> String? {
         if let value = self[str], let amount = Double("\(value)") {
             return String(format: "%.2f", amount)
         }
         return nil
     }
 }
 */

extension UIViewController {
    
    func retriveImg(key: String, completion:@escaping(Data)->Void) {
    
        let transferUtility = AWSS3TransferUtility.default()
        let expression = AWSS3TransferUtilityDownloadExpression()
//        expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
//            print("task and progress", progress)
//        })
//        }
        
        transferUtility.downloadData(fromBucket: "", key: key, expression: expression) { (task, url, data, error) in
            if let error = error {
                print("ERROR",error)
            }
            DispatchQueue.main.async(execute: {
                if let imgdata = data {
                    print("IMGDATA",imgdata,url)
                    completion(imgdata)
                }
            })

        }
        
    }
    
    
    func retriveImgFromBucket(key: String, completion:@escaping(UIImage)->Void) {
    
        if let cachedImage = ImageCache.shared.object(forKey: key as NSString) {
            print("Image from cache")
            completion(cachedImage)
            return
        }
        let transferUtility = AWSS3TransferUtility.default()
        let expression = AWSS3TransferUtilityDownloadExpression()

        transferUtility.downloadData(fromBucket: "", key: key, expression: expression) { (task, url, data, error) in
            if let error = error {
                print("ERROR",error)
            }
            DispatchQueue.main.async(execute: {
                if let imgdata = data, let image = UIImage(data: imgdata) {
                    print("IMGDATA",imgdata)
                    ImageCache.shared.setObject(image, forKey: key as NSString)
                    completion(image)
                }
            })

        }
        
    }
}

class ImageCache {

    private init() {}

    static let shared = NSCache<NSString, UIImage>()
}

extension UIViewController {
    func checkTime(completion: @escaping(Bool) ->Void) {
        var timeExist:Bool = false
        let calendar = Calendar.current
        print(calendar)
        let startTimeComponent = DateComponents(calendar: calendar, hour: 10, minute: 00)
        let endTimeComponent   = DateComponents(calendar: calendar, hour: 6, minute: 00)

        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let startTime    = calendar.date(byAdding: startTimeComponent, to: startOfToday)!
        let endTime      = calendar.date(byAdding: endTimeComponent, to: startOfToday)!

        if startTime <= now || now <= endTime {
            timeExist = true
        } else {
            timeExist = false
        }
        completion(timeExist)
    }
}

class ShimmerView: UIView {

    var gradientColorOne : CGColor = UIColor(white: 0.85, alpha: 1.0).cgColor
    var gradientColorTwo : CGColor = UIColor(white: 0.95, alpha: 1.0).cgColor
    
    
    
    func addGradientLayer() -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        self.layer.addSublayer(gradientLayer)
        
        return gradientLayer
    }
    
    func addAnimation() -> CABasicAnimation {
       
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 0.9
        return animation
    }
    
    func startAnimating() {
        
        let gradientLayer = addGradientLayer()
        let animation = addAnimation()
       
        gradientLayer.add(animation, forKey: animation.keyPath)
    }
    
    func stopAnimating() {
        let gradientLayer = addGradientLayer()
        gradientLayer.removeAllAnimations()
    }

}



public extension String {
    func aesEncrypt(key: String, iv: String) -> String? {
       
        if let data = self.data(using: .utf8), let key = key.data(using: .utf8) ,let iv = iv.data(using: .utf8) {
            let encrypt = data.encryptAES256(key: key, iv: iv)
            if let base64Data = encrypt?.base64EncodedData() {
                return String(data: base64Data, encoding: .utf8)
            }
        
        }
           return String()
    }

    func aesDecrypt(key: String, iv: String) -> String? {
        guard
            let data = Data(base64Encoded: self),
            let key = key.data(using: .utf8),
            let iv = iv.data(using: .utf8),
            let decrypt = data.decryptAES256(key: key, iv: iv)
            else { return nil }
        return String(data: decrypt, encoding: .utf8)
    }
}

public extension Data {
    /// Encrypts for you with all the good options turned on: CBC, an IV, PKCS7
    /// padding (so your input data doesn't have to be any particular length).
    /// Key can be 128, 192, or 256 bits.
    /// Generates a fresh IV for you each time, and prefixes it to the
    /// returned ciphertext.
    func encryptAES256(key: Data, iv: Data, options: Int = kCCOptionPKCS7Padding) -> Data? {
        // No option is needed for CBC, it is on by default.
        return aesCrypt(operation: kCCEncrypt,
                        algorithm: kCCAlgorithmAES,
                        options: options,
                        key: key,
                        initializationVector: iv,
                        dataIn: self)
    }

    /// Decrypts self, where self is the IV then the ciphertext.
    /// Key can be 128/192/256 bits.
    func decryptAES256(key: Data, iv: Data, options: Int = kCCOptionPKCS7Padding) -> Data? {
        guard count > kCCBlockSizeAES128 else { return nil }
        return aesCrypt(operation: kCCDecrypt,
                        algorithm: kCCAlgorithmAES,
                        options: options,
                        key: key,
                        initializationVector: iv,
                        dataIn: self)
    }

    // swiftlint:disable:next function_parameter_count
    private func aesCrypt(operation: Int,
                          algorithm: Int,
                          options: Int,
                          key: Data,
                          initializationVector: Data,
                          dataIn: Data) -> Data? {
        return initializationVector.withUnsafeBytes { ivUnsafeRawBufferPointer in
            return key.withUnsafeBytes { keyUnsafeRawBufferPointer in
                return dataIn.withUnsafeBytes { dataInUnsafeRawBufferPointer in
                    // Give the data out some breathing room for PKCS7's padding.
                    let dataOutSize: Int = dataIn.count + kCCBlockSizeAES128 * 2
                    let dataOut = UnsafeMutableRawPointer.allocate(byteCount: dataOutSize, alignment: 1)
                    defer { dataOut.deallocate() }
                    var dataOutMoved: Int = 0
                    let status = CCCrypt(CCOperation(operation),
                                         CCAlgorithm(algorithm),
                                         CCOptions(options),
                                         keyUnsafeRawBufferPointer.baseAddress, key.count,
                                         ivUnsafeRawBufferPointer.baseAddress,
                                         dataInUnsafeRawBufferPointer.baseAddress, dataIn.count,
                                         dataOut, dataOutSize,
                                         &dataOutMoved)
                    guard status == kCCSuccess else { return nil }
                    return Data(bytes: dataOut, count: dataOutMoved)
                }
            }
        }
    }
}

public func randomGenerateBytes(count: Int) -> Data? {
    let bytes = UnsafeMutableRawPointer.allocate(byteCount: count, alignment: 1)
    defer { bytes.deallocate() }
    let status = CCRandomGenerateBytes(bytes, count)
    guard status == kCCSuccess else { return nil }
    return Data(bytes: bytes, count: count)
}


import CommonCrypto
struct AES {

    // MARK: - Value
    // MARK: Private
    private let key: Data
    private let iv: Data


    // MARK: - Initialzier
    init?(key: String, iv: String) {
        guard key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
            debugPrint("Error: Failed to set a key.")
            return nil
        }

        guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
            debugPrint("Error: Failed to set an initial vector.")
            return nil
        }


        self.key = keyData
        self.iv  = ivData
    }


    // MARK: - Function
    // MARK: Public
    func encrypt(string: String) -> String {
        guard let cryptData =  crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt)) else { return "" }
        return cryptData.base64EncodedString()
    }

    func decrypt(data: Data?) -> String? {
        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
        return String(bytes: decryptedData, encoding: .utf8)
    }

    func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }

        let cryptLength = data.count + kCCBlockSizeAES128
        var cryptData   = Data(count: cryptLength)

        let keyLength = key.count
        let options   = CCOptions(kCCOptionPKCS7Padding)

        var bytesLength = Int(0)

        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                    CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
                    }
                }
            }
        }

        guard UInt32(status) == UInt32(kCCSuccess) else {
            debugPrint("Error: Failed to crypt data. Status \(status)")
            return nil
        }

        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}

extension String {
    
    /// Create `Data` from hexadecimal string representation
    ///
    /// This creates a `Data` object from hex string. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.
    
    var hexadecimal: Data? {
        var data = Data(capacity: count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
    
}

extension Data {
    
    /// Hexadecimal string representation of `Data` object.
    
    var hexadecimal: String {
        return map { String(format: "%02x", $0) }
            .joined()
    }
}

extension String {
    
    /// Create `String` representation of `Data` created from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a String object from that. Note, if the string has any spaces, those are removed. Also if the string started with a `<` or ended with a `>`, those are removed, too.
    ///
    /// For example,
    ///
    ///     String(hexadecimal: "<666f6f>")
    ///
    /// is
    ///
    ///     Optional("foo")
    ///
    /// - returns: `String` represented by this hexadecimal string.
    
    init?(hexadecimal string: String, encoding: String.Encoding = .utf8) {
        guard let data = string.hexadecimal else {
            return nil
        }
        
        self.init(data: data, encoding: encoding)
    }
            
    /// Create hexadecimal string representation of `String` object.
    ///
    /// For example,
    ///
    ///     "foo".hexadecimalString()
    ///
    /// is
    ///
    ///     Optional("666f6f")
    ///
    /// - parameter encoding: The `String.Encoding` that indicates how the string should be converted to `Data` before performing the hexadecimal conversion.
    ///
    /// - returns: `String` representation of this String object.
    
    func hexadecimalString(encoding: String.Encoding = .utf8) -> String? {
        return data(using: encoding)?
            .hexadecimal
    }
    
}

func createKey(pem: String) -> SecKey? {
    let attributes: [NSObject : NSObject] = [
       kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
       kSecAttrKeyClass: kSecAttrKeyClassPublic,
       kSecAttrKeySizeInBits: NSNumber(value: 2048)
    ]

    let privateKey = pem
        .replacingOccurrences(of: "-----BEGIN PRIVATE KEY-----", with: "")
        .replacingOccurrences(of: "-----END PRIVATE KEY-----", with: "")
        .split(separator: "\n").joined()

    guard let privateKeyData = Data(base64Encoded: privateKey, options: .ignoreUnknownCharacters) else {
        return nil
    }

    var error: Unmanaged<CFError>?
    return SecKeyCreateWithData(privateKeyData as CFData, attributes as CFDictionary, &error)
}

extension NSData {
    /// Create hexadecimal string representation of NSData object.
    /// :returns: String representation of this NSData object.
    
    func hexadecimalString() -> String {
        var string = NSMutableString(capacity: length * 2)
        var byte: UInt8?
        for i in 0 ..< length {
            getBytes(&byte, range: NSMakeRange(i, 1))
            string.appendFormat("%02x", byte!)
        }
        return string as String
    }
}

extension String {
  /// A data representation of the hexadecimal bytes in this string.
  func hexDecodedData() -> Data {
    // Get the UTF8 characters of this string
    let chars = Array(utf8)

    // Keep the bytes in an UInt8 array and later convert it to Data
    var bytes = [UInt8]()
    bytes.reserveCapacity(count / 2)

    // It is a lot faster to use a lookup map instead of strtoul
    let map: [UInt8] = [
      0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, // 01234567
      0x08, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // 89:;<=>?
      0x00, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f, 0x00, // @ABCDEFG
      0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  // HIJKLMNO
    ]

    // Grab two characters at a time, map them and turn it into a byte
    for i in stride(from: 0, to: count, by: 2) {
      let index1 = Int(chars[i] & 0x1F ^ 0x10)
      let index2 = Int(chars[i + 1] & 0x1F ^ 0x10)
      bytes.append(map[index1] << 4 | map[index2])
    }

    return Data(bytes)
  }
}
