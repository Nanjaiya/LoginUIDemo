
import UIKit
import SkyFloatingLabelTextField

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet var txtEmail: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextFiledsUI()
    }
    
    func setUpTextFiledsUI(){
        txtEmail.placeholderLight()
        txtEmail.errorMessagePlacement = .bottom
    }
    
    @IBAction func btnResetPwdTapped(_ sender: UIButton) {
        if txtEmail.text?.isEmptyField == true {
            txtEmail.errorMessage = kEnterEmail
        }
        else if txtEmail.errorMessage == nil{
            self.view.endEditing(true)
            self.popVC()
        }
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.popVC()
    }
    
    //******
}

extension ForgetPasswordViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtEmail.placeholderBold()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        txtEmail.placeholderLight()
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
        default:
            print("nothing")
        }
        
        return true
    }
    
}
