//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by 劉子瑜 on 2019/5/2.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    //背景圖片
    @IBOutlet var backgroundImageView: UIImageView!
    
    //評價按鈕
    @IBOutlet var rateButtons: [UIButton]!
    
    //評價頁面關閉按鈕
    @IBOutlet var closeButton: UIButton!
    
    
    var restaurant = Restaurant()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //插入餐廳圖片作為背景圖片
        backgroundImageView.image = UIImage(named: restaurant.image)
        
        
        //將圖片模糊
        let blurEffect = UIBlurEffect(style: .dark)
        
        //UIVisualEffectView世代有模糊的效果物件
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = view.bounds
        
        backgroundImageView.addSubview(blurEffectView)
        
        //評價按鈕往右移
        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)

        
        //關閉頁面按鈕往上移
        let moveUpTransform = CGAffineTransform.init(translationX: 0, y: -500)

        //先讓按鈕隱藏，動畫才能出現
        for rateButton in rateButtons{

            //使按鈕往右移至右側畫面外
            rateButton.transform = moveRightTransform
            rateButton.alpha = 0
            
            //使按鈕往上移至外面外
            closeButton.transform = moveUpTransform
            closeButton.alpha = 0
        }
        
        
//        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
//
//        //scale:縮放變形動畫
//        let scaleUpTransform = CGAffineTransform.init(scaleX: 5.0, y: 5.0)
//        let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform)
//
//        //使按鈕往右移至右側畫面外
//        for rateButton in rateButtons{
//
//            rateButton.transform = moveScaleTransform
//            rateButton.alpha = 0
//        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
     
 
//        //彈簧動畫
//        UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.3, options: [], animations: {
//
//            //按鈕圖片依照順序為0~4
//            //aplha=1.0由終止動畫狀態
//            self.rateButtons[1].alpha = 1.0
//
//            //將畫面按鈕移至原來位置
//            self.rateButtons[1].transform = .identity
//        }, completion: nil)
        
        UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
            
            self.closeButton.alpha = 1.0
            self.closeButton.transform = .identity
            
        }, completion: nil)
        
        for i in 0 ... 4{
            
            UIView.animate(withDuration: 0.4, delay: (TimeInterval(0.1 + 0.05 * Float(i))), options: [], animations: {
                
                //按鈕圖片依照順序為0~4
                //aplha=1.0由終止動畫狀態
                self.rateButtons[i].alpha = 1.0
                
                //將畫面按鈕移至原來位置
                self.rateButtons[i].transform = .identity
                
            }, completion: nil)
            
        }
    
    }
    
}
