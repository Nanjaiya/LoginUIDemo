
import UIKit
import SkyFloatingLabelTextField
import GoogleSignIn
import AuthenticationServices


class RegisterViewController: UIViewController {
    
    @IBOutlet var lblPrivacyAndTerms: UILabel!
    @IBOutlet var lblLogin: UILabel!
    
    @IBOutlet var btnAppleSignIn: UIButton!
    @IBOutlet var btnGoogleSignIn: UIButton!
    @IBOutlet var btnContinue: UIButton!
    
    @IBOutlet var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet var txtLastName: SkyFloatingLabelTextField!
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
        //lblPrivacyAndTerms
        let textPrivacyAndTerms = lblPrivacyAndTerms.text
        let strPrivacy = NSMutableAttributedString(string: textPrivacyAndTerms!)
        
        let range1 = (textPrivacyAndTerms! as NSString).range(of: "Privacy Policy")
        strPrivacy.addAttribute(NSAttributedString.Key.font, value: AppFont.fontSemibold(12.0), range: range1)
        strPrivacy.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColor.hyperLinkText!, range: range1)
        lblPrivacyAndTerms.attributedText = strPrivacy
        
        let range2 = (textPrivacyAndTerms! as NSString).range(of: "Terms & Conditions")
        strPrivacy.addAttribute(NSAttributedString.Key.font, value: AppFont.fontSemibold(12.0), range: range2)
        strPrivacy.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColor.hyperLinkText!, range: range2)
        lblPrivacyAndTerms.attributedText = strPrivacy
        
        //lblLogin
        let textLogin = lblLogin.text
        let strLogin = NSMutableAttributedString(string: textLogin!)
        
        let range3 = (textLogin! as NSString).range(of: "Login")
        strLogin.addAttribute(NSAttributedString.Key.font, value: AppFont.fontMedium(14), range: range3)
        strLogin.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColor.hyperLinkText!, range: range3)
        
        lblLogin.attributedText = strLogin
        
        lblLogin.isUserInteractionEnabled = true
        lblLogin.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
    }
    
    func setUpTextFiledsUI(){
        txtFirstName.placeholderLight()
        txtLastName.placeholderLight()
        txtEmail.placeholderLight()
        txtPwd.placeholderLight()
        
        txtFirstName.errorMessagePlacement = .bottom
        txtLastName.errorMessagePlacement = .bottom
        txtEmail.errorMessagePlacement = .bottom
        txtPwd.errorMessagePlacement = .bottom
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.btnContinueBottomConstraint.constant == 0{
                self.btnContinueBottomConstraint.constant = keyboardSize.height
                self.btnContinueHeightConstraint.constant = 53
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
        
        let text = lblLogin.text
        let loginRange = (text! as NSString).range(of: "Login")
        
        if gesture.didTapAttributedTextInLabel(label: lblLogin, inRange: loginRange) {
            print("Login")
            if let loginvc = self.storyboard?.instantiateVC(LoginViewController.self) {
                self.pushVC(loginvc)
            }
        } else {
            print("Tapped none")
        }
    }
    
    @IBAction func btnAppleSignInTapped(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            appleLoginManager = AppleLoginManager(vc: self, onSignedIn: { (isSuccess) in
                if isSuccess{
                    if isSuccess{
                        self.navigateToEmailVerificationVCMethod()
                    }
                }else{
                    print("apple not signed in")
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
    
    @IBAction func btnContinue(_ sender: UIButton) {
        if txtFirstName.text?.isEmptyField == true{
            txtFirstName.errorMessage = kEnterFirstName
        }
        else if txtLastName.text?.isEmptyField == true{
            txtLastName.errorMessage = kEnterLastName
        }
        else if txtEmail.text?.isEmptyField == true {
            txtEmail.errorMessage = kEnterEmail
        }else if txtPwd.text?.isEmptyField == true {
            txtPwd.errorMessage = kEnterPassword
        }
        else if txtEmail.errorMessage == nil && txtPwd.errorMessage == nil{
            self.view.endEditing(true)
            navigateToEmailVerificationVCMethod()
        }
    }
    
    //******
}

extension RegisterViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField.tag {
        case 1:
            txtFirstName.placeholderBold()
        case 2:
            txtLastName.placeholderBold()
        case 3:
            txtEmail.placeholderBold()
        case 4:
            txtPwd.placeholderBold()
        default:
            
            txtFirstName.placeholderLight()
            txtLastName.placeholderLight()
            txtEmail.placeholderLight()
            txtPwd.placeholderLight()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
        case 1:
            txtFirstName.placeholderLight()
        case 2:
            txtLastName.placeholderLight()
        case 3:
            txtEmail.placeholderLight()
        case 4:
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
            if txtFirstName.text?.isEmptyField == true{
                txtFirstName.errorMessage = kEnterFirstName
                txtFirstName.errorMessagePlacement = .bottom
            }else{
                txtFirstName.errorMessage = nil
            }
            
        case 2:
            if txtLastName.text?.isEmptyField == true{
                txtLastName.errorMessage = kEnterLastName
            }else{
                txtLastName.errorMessage = nil
            }
            
        case 3:
            if CommonMethods.isValidEmail(testStr: txtEmail.text!) == false{
                txtEmail.errorMessage = kEnterValidEmail
            }else{
                txtEmail.errorMessage = nil
            }
            
        case 4:
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
}

