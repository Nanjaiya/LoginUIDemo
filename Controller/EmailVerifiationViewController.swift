
import UIKit

class EmailVerifiationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func btnDiffEmailTapped(_ sender: UIButton) {
        if let changeEmailVC = self.storyboard?.instantiateVC(ChangeEmailViewController.self) {
            self.pushVC(changeEmailVC)
        }
    }
    
    @IBAction func btnContinue(_ sender: UIButton) {
        self.popVC()
    }
    //******
}
