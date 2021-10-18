//
//  ChangeEmailViewController.swift
//  CollectUserEmail
//
//  Created by Nanjaiya on 14/10/21.
//

import UIKit
import SkyFloatingLabelTextField
import GoogleSignIn
import AuthenticationServices

class ChangeEmailViewController: UIViewController {
    
    @IBOutlet var txtOldEmail: SkyFloatingLabelTextField!
    @IBOutlet var txtNewEmail: SkyFloatingLabelTextField!
    @IBOutlet var txtPwd: SkyFloatingLabelTextField!
    
    @IBOutlet var btnAppleSignIn: UIButton!
    @IBOutlet var btnGoogleSignIn: UIButton!
    
    var appleLoginManager: AppleLoginManager! = nil
    var googleLoginManager: GooogleLoginManager! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFiledsUI()
        
        CommonMethods.putShadow(button: btnAppleSignIn, cornerRadious: 9)
        CommonMethods.putShadow(button: btnGoogleSignIn, cornerRadious: 9)
        
    }
    
    func setUpTextFiledsUI(){
        txtOldEmail.placeholderLight()
        txtNewEmail.placeholderLight()
        txtPwd.placeholderLight()
        
        txtOldEmail.errorMessagePlacement = .bottom
        txtNewEmail.errorMessagePlacement = .bottom
        txtPwd.errorMessagePlacement = .bottom
    }
    
    func navigateToEmailVerificationVCMethod() {
         if let emailVerifiationVC = self.storyboard?.instantiateVC(EmailVerifiationViewController.self) {
              self.pushVC(emailVerifiationVC)
         }
    }
    
    @IBAction func btnProcessToChangeTapped(_ sender: UIButton) {
        if txtOldEmail.text?.isEmptyField == true {
            txtOldEmail.errorMessage = kEnterEmail
        }else if txtNewEmail.text?.isEmptyField == true{
            txtNewEmail.errorMessage = kEnterEmail
        }
        else if txtPwd.text?.isEmptyField == true {
            txtPwd.errorMessage = kEnterPassword
        }
        else if txtOldEmail.errorMessage == nil && txtNewEmail.errorMessage == nil && txtPwd.errorMessage == nil{
            self.view.endEditing(true)
           // navigateToEmailVerificationVCMethod()
        }
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func btnAppleSignInTapped(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            appleLoginManager = AppleLoginManager(vc: self, onSignedIn: { (isSuccess) in
                if isSuccess{
                    self.navigateToEmailVerificationVCMethod()
                }
            })
            
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = appleLoginManager
            controller.presentationContextProvider = appleLoginManager
            controller.performRequests()
        }
    }
    
    @IBAction func btnGoogleSignInTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
        googleLoginManager = GooogleLoginManager(vc: self, onSignedIn: { (isSuccess) in
            if isSuccess{
                print("google signed in")
                self.navigateToEmailVerificationVCMethod()
            }else{
                print("google not signed in")
            }
        })
        
        GIDSignIn.sharedInstance()?.delegate = googleLoginManager
    }
    
    //******
}

extension ChangeEmailViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField.tag {
        case 1:
            txtOldEmail.placeholderBold()
        case 2:
            txtNewEmail.placeholderBold()
        case 3:
            txtPwd.placeholderBold()
        default:
            txtOldEmail.placeholderLight()
            txtNewEmail.placeholderLight()
            txtPwd.placeholderLight()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
        case 1:
            txtOldEmail.placeholderLight()
        case 2:
            txtNewEmail.placeholderLight()
        case 3:
            txtPwd.placeholderLight()
        default:
            print("no textfiled deselect!!!!")
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        switch textField.tag {
        case 1:
            if CommonMethods.isValidEmail(testStr: txtOldEmail.text!) == false{
                txtOldEmail.errorMessage = kEnterValidEmail
            }else{
                txtOldEmail.errorMessage = nil
            }
            
        case 2:
            if CommonMethods.isValidEmail(testStr: txtNewEmail.text!) == false{
                txtNewEmail.errorMessage = kEnterValidEmail
            }else{
                txtNewEmail.errorMessage = nil
            }
            
        case 3:
            if CommonMethods.isValidPassword(testStr: txtPwd.text!) == false{
                txtPwd.errorMessage = kEnterValidPwd
            }else{
                txtPwd.errorMessage = nil
            }
            
        default:
            print("none")
        }
        return true
    }
    
//******
}
