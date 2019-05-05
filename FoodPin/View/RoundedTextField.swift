//
//  RoundedTextField.swift
//  FoodPin
//
//  Created by 劉子瑜 on 2019/5/4.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import UIKit
//MARK: - 將輸入框的四角改成圓形
class RoundedTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    //以下三個override都是對文字縮排
    
    //
    override func textRect(forBounds bounds: CGRect) -> CGRect{
        
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.inset(by: padding)
    }
    
    //建立圓角
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 5.0
        
        self.layer.masksToBounds = true
        
    }
    
    

}
