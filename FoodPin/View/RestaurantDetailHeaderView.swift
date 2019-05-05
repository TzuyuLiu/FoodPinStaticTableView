//
//  RestaurantDetailHeaderView.swift
//  FoodPin
//
//  Created by 劉子瑜 on 2019/4/30.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit

class RestaurantDetailHeaderView: UIView {

    @IBOutlet var ratingImageView: UIImageView!
    
    //MARK: - 宣告各種IBOutlet
    @IBOutlet var headerImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!{
        
        //由於名字太長，所以交給系統判斷名字需要多少行
        //numberOfLines設為0代表系統判斷
        didSet{
            nameLabel.numberOfLines = 0
        }
        
    }
    
    @IBOutlet var typeLabel: UILabel!{
        
        //任何有格子的東西都能使用㘣角
        didSet{
            typeLabel.layer.cornerRadius = 5.0
            typeLabel.layer.masksToBounds = true
        }
        
    }
    
    @IBOutlet var heartImageView: UIImageView!{
        
        //將心型圖案轉轉換成白色
        didSet{
            headerImageView.image = UIImage(named: "heart-tick")?.withRenderingMode(.alwaysTemplate)
            heartImageView.tintColor = .white
        }
    }

    
    

}
