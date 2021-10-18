
import UIKit
import GoogleSignIn
import AuthenticationServices

class GooogleLoginManager: NSObject{
    
    var vc = UIViewController()
    let signInSucceeded: (Bool) -> Void
    
    init(vc: UIViewController, onSignedIn: @escaping (Bool) -> Void) {
        self.vc = vc
        self.signInSucceeded = onSignedIn
    }
    //******
}

extension GooogleLoginManager: GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
                
        if let error = error {
            print("\(error.localizedDescription)")
            self.signInSucceeded(false)
        }
        else
        {
            let userId = user.userID
            let idToken = user.authentication.idToken
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            //  let imgUrl = user.profile.imageURL(withDimension: 400)
            //  let data = try? Data(contentsOf: imgUrl!)
            
            print("userId =>", userId!)
            print("idToken =>", idToken ?? "")
            print("fullName =>", fullName ?? "")
            print("givenName =>", givenName ?? "")
            print("familyName =>", familyName ?? "")
            print("email =>", email ?? "")
            self.signInSucceeded(true)
            //  print("imgUrl", imgUrl)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        vc.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        vc.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        self.signInSucceeded(false)
        // Perform any operations when the user disconnects from app here.
    }
}

class AppleLoginManager: NSObject {
    
    var vc = UIViewController()
    let signInSucceeded: (Bool) -> Void
    
    init(vc: UIViewController, onSignedIn: @escaping (Bool) -> Void) {
        self.vc = vc
        self.signInSucceeded = onSignedIn
    }
}

@available(iOS 13.0, *)
extension AppleLoginManager: ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let userFirstName = appleIDCredential.fullName?.givenName
            let userLastName = appleIDCredential.fullName?.familyName
            let userEmail = appleIDCredential.email
             
            self.signInSucceeded(true)
            
            print("userIdentifier!!!!!!!",userIdentifier)
            print("userFirstName!!!!!!!",userFirstName)
            print("userLastName!!!!!!!",userLastName)
            print("userEmail!!!!!!!",userEmail)
            
            // navigateSignOutVCMethod()
        }
        else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            let username = passwordCredential.user
            let password = passwordCredential.password

            print("username!!!!!!!",username)
            print("password!!!!!!!",password)
            
            self.signInSucceeded(true)
            
            // navigateSignOutVCMethod()
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("\(error.localizedDescription)")
        self.signInSucceeded(false)
    }
}

@available(iOS 13.0, *)
extension AppleLoginManager: ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return vc.view.window!
    }
}
