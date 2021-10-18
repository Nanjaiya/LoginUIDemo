//
//  Extension+SkyFloatingLabelTextField.swift
//  CollectUserEmail
//
//  Created by Nanjaiya on 10/10/21.
//

import UIKit
import SkyFloatingLabelTextField

extension SkyFloatingLabelTextField {
    func placeholderBold() {
        self.placeholderFont = AppFont.fontBold(18)
        self.placeholderColor = .black
    }
   
    func placeholderLight() {
        self.placeholderFont = AppFont.fontLight(14)
        self.placeholderColor = AppColor.disableText!
    }
}
