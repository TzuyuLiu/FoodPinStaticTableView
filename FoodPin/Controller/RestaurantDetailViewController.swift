//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Simon Ng on 13/8/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: RestaurantDetailHeaderView!
    
    var restaurant: RestaurantMO!
    
    
    //只有程式第一次載入view時才會執行
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        //建立與表格視圖(TableView)的連結
        tableView.delegate = self
        tableView.dataSource = self
        
        //設定頭部視圖
        
        headerView.nameLabel.text = restaurant.name
        headerView.typeLabel.text = restaurant.type
        
        //圖片已經使用core data來存成data物件，要載入圖片是使用data參數來初始化UIImage物件
        if let restaurantImage = restaurant.image{
            headerView.headerImageView.image = UIImage(data: restaurantImage as Data)
        }
        
        headerView.heartImageView.isHidden = (restaurant.isVisited) ? false : true

        
        //將分隔線隱藏
        tableView.separatorStyle = .none
        
        //將導覽列變透明，方法為設定背景圖片與陰影圖片為一張空白圖片，使用UIImage()達成
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        //設定返回按鈕與標題的顏色為白色
        navigationController?.navigationBar.tintColor = .white
        
        //是否要自動調整表格視圖的位置？我們不調整位置，讓導覽列與表格試圖重疊
        tableView.contentInsetAdjustmentBehavior = .never
        
        //顯示餐廳評價
        if let rating = restaurant.rating{
            headerView.ratingImageView.image = UIImage(named: rating)
        }
        
    }

    //每次view載入都會執行
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //餐廳導覽至細節不需要使用往左滑隱藏導覽列
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    //將狀態列調成亮色系(時間那一列)
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    //MARK: - cell的實作
    
    //一個畫面要有幾個section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //一個section要有幾個row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    //選到cell時
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
            
            //呈現位置
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView.image = UIImage(named: "phone")
            cell.shortTextLabel.text = restaurant.phone
            cell.selectionStyle = .none
            
            return cell
            
            
            //呈現電話
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView.image = UIImage(named: "map")
            cell.shortTextLabel.text = restaurant.location
            cell.selectionStyle = .none
            
            return cell
            
            
            //呈現敘述
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
            
            //作業：修復bug
            cell.descriptionLabel.text = restaurant.summary
            cell.selectionStyle = .none
            
            return cell
            
            
            //地圖標題：how to get there
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailSeparatorCell.self), for: indexPath) as! RestaurantDetailSeparatorCell
            cell.titleLabel.text = "HOW TO GET THERE"
            cell.selectionStyle = .none
            
            return cell
            
            
            //地圖
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailMapCell.self), for: indexPath) as! RestaurantDetailMapCell
            
            //顯示地圖正確位置(configure是在RestaurantDetailMapCell.swift中)
            //RestaurantMO屬性都是optional，因此要解開
            if let restaurantLocation = restaurant.location{
                cell.configure(location: restaurantLocation)
                cell.selectionStyle = .none
            }
            
            return cell
            
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
        
    }
    
    //MARK: - 當按下按鈕後，若是使用使用show segue，此時可以使用prepare來傳送資料
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMap"{
            
            let destinationController = segue.destination as! MapViewController
            
            destinationController.restaurant = restaurant
        } else if segue.identifier == "showReview"{
            
            //將取得的restaurant資訊傳給打分數的view
            let destinationController = segue.destination as! ReviewViewController
            
            destinationController.restaurant = restaurant
        }
    }
    
    
    //MARK: - 當評分頁面關閉時會呼叫此，此為實作ReviewViewController的退回按鈕
    @IBAction func close(segue: UIStoryboardSegue){
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: - 建立退回segue已進行資料傳遞
    @IBAction func rateRestaurant(segue: UIStoryboardSegue){
        
        
        dismiss(animated: true, completion: {
           
            if let rating = segue.identifier{
                
                self.restaurant.rating = rating
                self.headerView.ratingImageView.image = UIImage(named: rating)
                
                //將資料儲存到資料庫
                if let appDelegate = (UIApplication.shared.delete as? AppDelegate){
                    appDelegate.saveContext()
                }
                
                
                //先將圖片縮小，再將圖片放回原來大小
                let scaleTransform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                self.headerView.ratingImageView.transform = scaleTransform
                self.headerView.ratingImageView.alpha = 0
                
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
                    self.headerView.ratingImageView.transform = .identity
                    self.headerView.ratingImageView.alpha = 1
                }, completion: nil)
            }
        })
        
 
    }
    
 

}
