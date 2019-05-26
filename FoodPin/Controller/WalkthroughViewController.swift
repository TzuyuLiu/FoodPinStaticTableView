//
//  WalkthroughViewController.swift
//  FoodPin
//
//  Created by 劉子瑜 on 2019/5/25.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController , WalkthroughPageViewControllerDelegate{
    
    var walkthroughPageViewController :WalkthroughPageViewController?
    
    @IBOutlet var pageController : UIPageControl!
    @IBOutlet var nextButton: UIButton! {
        didSet{
            nextButton.layer.cornerRadius = 25.0
            nextButton.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var skipButton: UIButton!
    
    //呼叫dismiss方法來取消view controller
    @IBAction func skipButtonTapped(sender: UIButton){
        //取消畫面前先使用UserDefaults來記錄已經看過導覽畫面了(UserDefaults會記錄在預設系統裡)
        UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
        dismiss(animated: true, completion: nil)
    }
    
    //next按鈕
    @IBAction func nextButtonTapped(sender: UIButton){
        
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            
            //呼叫forwardPage顯示下一個導覽畫面
            case 0...1:
                walkthroughPageViewController?.forwardPage()
                
            //最後一個導覽畫面，在按下next就會取消畫面
            case 2:
                //取消畫面前先使用UserDefaults來記錄已經看過導覽畫面了(UserDefaults會記錄在預設系統裡)
                UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
                dismiss(animated: true, completion: nil)
            default: break
            }
        }
        
        //更新UI顯示的字
        updateUI()
    }
    
    //控制next按鈕標題,判斷skip是否需要隱藏
    func updateUI(){
        
        if let index  = walkthroughPageViewController?.currentIndex{
            switch index {
                case 0...1:
                    nextButton.setTitle("NEXT", for: .normal)
                    skipButton.isHidden = false
                
                //當在最後一頁，就將skip藏起來
                case 2:
                    nextButton.setTitle("GET STARTED", for: .normal)
                    skipButton.isHidden = true
                
            default: break
            }
            
            //透過currentPage設定頁面控制的顯示器
            pageController.currentPage = index
        }
    }
  

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    //prepare()是在經由Segue進入下一個頁面前會被觸發
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController{
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
        }
    }
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    

}
