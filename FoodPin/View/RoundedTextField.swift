//
//  RoundedTextField.swift
//  FoodPin
//
//  Created by 劉子瑜 on 2019/5/4.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit

//MARK: - 將輸入框的四角改成圓形
class RoundedTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    //以下三個override都是對文字縮排，我們希望縮排文字到文字欄位中，因此override以下三個方法，回傳一個有縮排的矩形，使用UIEdgeInsets為文字欄為左右側增加邊距區域，呼叫bounds.inset(by: padding)來讓邊緣內縮排，已縮減矩形
    
    //此方法所回傳的繪製矩陣是針對text區塊，重寫來重置文字區域
    override func textRect(forBounds bounds: CGRect) -> CGRect{
        
        return bounds.inset(by: padding)
    }
    
    //此方法所回傳的繪製矩陣是針對place holder，重寫來重置place holder
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.inset(by: padding)
    }
    
    //此方法回傳的舉行是用於顯示可編輯的文字，重寫來重置輸入文字區域
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return bounds.inset(by: padding)
    }
    
    //每次文字欄位佈局時都會呼叫layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        //建立圓角
        self.layer.cornerRadius = 5.0
        
        self.layer.masksToBounds = true
        
    }
    
    

}
