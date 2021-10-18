
import UIKit
import AVFoundation

let appDelegateObj = UIApplication.shared.delegate as! AppDelegate
let USERDEFAULT = UserDefaults.standard

class CommonMethods: NSObject {
    
    // MARK:- showAlert Method
    static func showAlert(_ messageT:String,title:String,targetViewController: UIViewController){
        let alertController = UIAlertController(title: messageT, message: title, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        targetViewController.present(alertController, animated: true, completion: nil)
    }
    
    // MARK:- showAlert Method
    static func showAlertwithOneAction(_ messageT:String,title:String,targetViewController: UIViewController,okHandler: @escaping ((UIAlertAction?) -> Void)){
        let alertController = UIAlertController(title: messageT, message: title, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: okHandler)
        alertController.addAction(okAction)
        targetViewController.present(alertController, animated: true, completion: nil)
    }
    
    // show alert view with Ok and cancel actions
    static func showAlertViewWithTwoActions(title alerTitle:String ,message alertMessage:String, preferredStyle style:UIAlertController.Style, okLabel: String, cancelLabel: String, targetViewController: UIViewController,okHandler: ((UIAlertAction?) -> Void)!, cancelHandler: ((UIAlertAction?) -> Void)!){
        
        let alertController = UIAlertController(title: alerTitle, message: alertMessage, preferredStyle: style)
        let okAction = UIAlertAction(title: okLabel, style: .default, handler: okHandler)
        let cancelAction = UIAlertAction(title: cancelLabel, style: .default,handler: cancelHandler)
        
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        // Add Actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present Alert Controller
        targetViewController.present(alertController, animated: true, completion: nil)
    }
    
    // MARK:- PutShadow Method
    static func putShadow(button: UIButton, cornerRadious:Int)  {
      //  button.layer.borderWidth = 1
        button.layer.cornerRadius = CGFloat(cornerRadious)
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 6
        //  button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        button.layer.shadowOpacity = 0.2
     //   view.layer.shadowColor = #colorLiteral(red: 0.5607843137, green: 0.5607843137, blue: 0.5607843137, alpha: 1)
        button.layer.masksToBounds = true
        button.clipsToBounds = false
    }
    
    static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
        
//    static func isValidPassword(testStr:String) -> Bool {
//        let regularExpression = "(?!^[0-9]*$)(?!^[a-zA-Z]*$)^([a-zA-Z0-9]{6,16})$"
//        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
//        return passwordValidation.evaluate(with: testStr)
//    }
    
    static func isValidPassword(testStr:String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
            return passwordTest.evaluate(with: testStr)
    }
        
    static  func isvalidnumber(value: String) -> Bool {
        // let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let PHONE_REGEX = "^[0-9._%+-]{4,15}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
}

extension StringProtocol where Index == String.Index {
    var isEmptyField: Bool {
        return trimmingCharacters(in: .whitespaces) == ""
    }
}
extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    func trim() -> String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var containsSpecialCharacter: Bool {
        let regex = ".*[^A-Za-z0-9].*"
        let testString = NSPredicate(format:"SELF MATCHES %@", regex)
        return testString.evaluate(with: self)
    }
}

