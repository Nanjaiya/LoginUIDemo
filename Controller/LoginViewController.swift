

import UIKit
import SkyFloatingLabelTextField
import GoogleSignIn
import AuthenticationServices

class LoginViewController: UIViewController {
     
     @IBOutlet var lblForgetPwd: UILabel!
     @IBOutlet var lblCreateAccount: UILabel!
     
     @IBOutlet var btnAppleSignIn: UIButton!
     @IBOutlet var btnGoogleSignIn: UIButton!
     
     @IBOutlet var txtEmail: SkyFloatingLabelTextField!
     @IBOutlet var txtPwd: SkyFloatingLabelTextField!
     
     @IBOutlet var btnContinueBottomConstraint: NSLayoutConstraint!
     @IBOutlet var btnContinueHeightConstraint: NSLayoutConstraint!
     
     var appleLoginManager: AppleLoginManager! = nil
     var googleLoginManager: GooogleLoginManager! = nil
     
     override func viewDidLoad() {
          super.viewDidLoad()
          customLabels()
          setUpTextFiledsUI()
          
          CommonMethods.putShadow(button: btnAppleSignIn, cornerRadious: 9)
          CommonMethods.putShadow(button: btnGoogleSignIn, cornerRadious: 9)
          
          NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          
          NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
     }
     
     func customLabels() {
          //lblForgetPwd
          let textForgetPwd = lblForgetPwd.text
          let strForgetPwdHere = NSMutableAttributedString(string: textForgetPwd!)
          
          let range1 = (textForgetPwd! as NSString).range(of: "here.")
          strForgetPwdHere.addAttribute(NSAttributedString.Key.font, value: AppFont.fontMedium(14), range: range1)
          strForgetPwdHere.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColor.hyperLinkText!, range: range1)
          lblForgetPwd.attributedText = strForgetPwdHere
          
          lblForgetPwd.isUserInteractionEnabled = true
          lblForgetPwd.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
          
          //lblCreateAccount
          let textCreateAccount = lblCreateAccount.text
          let strCreateAccountHere = NSMutableAttributedString(string: textCreateAccount!)
          
          let range2 = (textCreateAccount! as NSString).range(of: "here.")
          strCreateAccountHere.addAttribute(NSAttributedString.Key.font, value: AppFont.fontMedium(14), range: range2)
          strCreateAccountHere.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColor.hyperLinkText!, range: range2)
          
          lblCreateAccount.attributedText = strCreateAccountHere
          lblCreateAccount.isUserInteractionEnabled = true
          lblCreateAccount.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
     }
     
     func setUpTextFiledsUI(){
          txtEmail.placeholderLight()
          txtPwd.placeholderLight()
          
          txtEmail.errorMessagePlacement = .bottom
          txtPwd.errorMessagePlacement = .bottom
     }
     
     @objc func keyboardWillShow(notification: NSNotification) {
          if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
               
               if btnContinueBottomConstraint.constant == 0{
                    btnContinueBottomConstraint.constant = keyboardSize.height
                    btnContinueHeightConstraint.constant = 53
               }
               
               UIView.animate(withDuration: 0.1) {
                    self.view.layoutIfNeeded()
               }
          }
     }
     
     @objc func keyboardWillHide(notification: NSNotification) {
          if btnContinueBottomConstraint.constant != 0{
               btnContinueBottomConstraint.constant = 0
               btnContinueHeightConstraint.constant = 70
          }
          
          UIView.animate(withDuration: 0.1) {
               self.view.layoutIfNeeded()
          }
     }
     
     func navigateToEmailVerificationVCMethod() {
          if let emailVerifiationVC = self.storyboard?.instantiateVC(EmailVerifiationViewController.self) {
               self.pushVC(emailVerifiationVC)
          }
     }
     
     @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
          
          let forgetPwdHereRange = (lblForgetPwd.text! as NSString).range(of: "here.")
          let createAccountHereRange = (lblCreateAccount.text! as NSString).range(of: "here.")
          
          if gesture.didTapAttributedTextInLabel(label: lblForgetPwd, inRange: forgetPwdHereRange) {
               print("Forget Pwd")
               if let forgetPwdVC = self.storyboard?.instantiateVC(ForgetPasswordViewController.self) {
                    self.pushVC(forgetPwdVC)
               }
          } else if gesture.didTapAttributedTextInLabel(label: lblCreateAccount, inRange: createAccountHereRange) {
               print("Cerate Account")
               self.popVC()
          }
          else {
               print("Tapped none")
          }
     }
     
     @IBAction func btnContinueTapped(_ sender: UIButton) {
          if txtEmail.text?.isEmptyField == true {
               txtEmail.errorMessage = kEnterEmail
          }else if txtPwd.text?.isEmptyField == true {
               txtPwd.errorMessage = kEnterPassword
          }
          else if txtEmail.errorMessage == nil && txtPwd.errorMessage == nil{
               self.view.endEditing(true)
               navigateToEmailVerificationVCMethod()
          }
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

extension LoginViewController: UITextFieldDelegate{
     
     func textFieldDidBeginEditing(_ textField: UITextField) {
          
          switch textField.tag {
          case 1:
               txtEmail.placeholderBold()
          case 2:
               txtPwd.placeholderBold()
          default:
               txtEmail.placeholderLight()
               txtPwd.placeholderLight()
          }
     }
     
     func textFieldDidEndEditing(_ textField: UITextField) {
          
          switch textField.tag {
          case 1:
               txtEmail.placeholderLight()
          case 2:
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
               if CommonMethods.isValidEmail(testStr: txtEmail.text!) == false{
                    txtEmail.errorMessage = kEnterValidEmail
               }else{
                    txtEmail.errorMessage = nil
               }
               
          case 2:
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

