//
//  UIColor+Ext.swift
//  FoodPin
//
//  Created by 劉子瑜 on 2019/5/1.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit

//MARK: - 覆寫UIColor
extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int){
        let redValue = CGFloat(red) / 255.0
        let greenValue = CGFloat(green) / 255.0
        let blueValue = CGFloat(blue) / 255.0

        self.init(red: redValue, green: greenValue, blue: blueValue , alpha: 1.0)

    }
    
}


//MARK: - 更新狀態列(時間那一列)
extension UINavigationController{
    
    open override var childForStatusBarStyle: UIViewController?{
        return topViewController
    }
}

