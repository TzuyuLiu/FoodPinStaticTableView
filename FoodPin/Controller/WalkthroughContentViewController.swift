//
//  WalkthroughContentViewController.swift
//  FoodPin
//
//  Created by 劉子瑜 on 2019/5/22.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {
    
    @IBOutlet var headingLabel: UILabel!{
        didSet{
            //讓標籤支援多行顯示
            headingLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var subHeadingLabel: UILabel! {
        didSet{
            //讓標籤支援多行顯示
            subHeadingLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var contentImageVew: UIImageView!
    
    var index = 0   //儲存目前頁面的索引值，第一個導覽頁面索引值 = 0
    var heading = ""
    var subHeading = ""
    var imageFile = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化標籤與圖片視圖
        headingLabel.text = heading
        subHeadingLabel.text = subHeading
        contentImageVew.image = UIImage(named: imageFile)
    }
    
    
}
