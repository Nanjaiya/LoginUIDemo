
import Foundation
import UIKit

struct AppFont {
    
    static func fontBold(_ pointSize: CGFloat = 18) -> UIFont {
        return UIFont.init(name: "SFUIDisplay-Bold", size: pointSize)!
    }
    
    static func fontSemibold(_ pointSize: CGFloat = 18) -> UIFont {
        return UIFont.init(name: "SFUIDisplay-Semibold", size: pointSize)!
    }
    
    static func fontMedium(_ pointSize: CGFloat = 18) -> UIFont {
        return UIFont.init(name: "SFUIDisplay-Medium", size: pointSize)!
    }
    
    static func fontLight(_ pointSize: CGFloat = 18) -> UIFont {
        return UIFont.init(name: "SFUIDisplay-Light", size: pointSize)!
    }
    
}
