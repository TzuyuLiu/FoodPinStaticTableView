//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Simon Ng on 8/8/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {

    var restaurants:[RestaurantMO] = []

    
    // MARK: - View controller life cycle
    
    //只有程式第一次載入view時才會執行
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //設定背景為一張空白圖片(UIImage())
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        //決定讓返回按鈕右邊不顯示字元(title不填)
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        //設定大標題的文字為紅色，沒出現效果
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0){
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor(red: 231.0/255, green: 76.0/255, blue: 60.0/255, alpha: 1.0), NSAttributedString.Key.font: customFont ]
        }
        
    }
    
    //每次view出現時都會執行
    override func viewWillAppear(_ animated: Bool) {
        
        //要先super才能用
        super.viewWillAppear(animated)
        

        
        //設定往左滑動就能隱藏導覽列(時間下面那條)
        navigationController?.hidesBarsOnSwipe = true
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "datacell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
        
        // Configure the cell...
        cell.nameLabel.text = restaurants[indexPath.row].name
        
        //圖片已經使用core data來存成data物件，要載入圖片是使用data參數來初始化UIImage物件
        if let restaurantImage = restaurants[indexPath.row].image{
            cell.thumbnailImageView.image = UIImage(data: restaurantImage as Data)
        }
        cell.locationLabel.text = restaurants[indexPath.row].location
        cell.typeLabel.text = restaurants[indexPath.row].type
        cell.heartImageView.isHidden = restaurants[indexPath.row].isVisited ? false : true
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            // Delete the row from the data source
            self.restaurants.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Call completion handler with true to indicate
            completionHandler(true)
        }
        
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
            
            //由於我們在FoodPin.xcdatamodeld裡面的屬性都是optional，因此要解開optional
            
            let defaultText = "Just checking in at " + self.restaurants[indexPath.row].name!
            
            
            let activityController: UIActivityViewController
            
            //圖片已經使用core data來存成data物件，要載入圖片是使用data參數來初始化UIImage物件
            if let restaurantImage = self.restaurants[indexPath.row].image,
                let imageToShare = UIImage(data: restaurantImage as Data) {
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            } else  {
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            
          
            if let popoverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        // Set the icon and background color for the actions
        deleteAction.backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        deleteAction.image = UIImage(named: "delete")
        
        shareAction.backgroundColor = UIColor(red: 254.0/255.0, green: 149.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        shareAction.image = UIImage(named: "share")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return swipeConfiguration
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let checkInAction = UIContextualAction(style: .normal, title: "Check-in") { (action, sourceView, completionHandler) in
            
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
            self.restaurants[indexPath.row].isVisited = (self.restaurants[indexPath.row].isVisited) ? false : true
            cell.heartImageView.isHidden = self.restaurants[indexPath.row].isVisited ? false : true
            
            completionHandler(true)
        }
        
        let checkInIcon = restaurants[indexPath.row].isVisited ? "undo" : "tick"
        
        //使用我們在extensions裡宣告的UIColor_Ext檔案來縮寫UIColor
        checkInAction.backgroundColor = UIColor(red: 38, green: 162 , blue: 78 )
        checkInAction.image = UIImage(named: checkInIcon)
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [checkInAction])
        
        
        return swipeConfiguration
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = restaurants[indexPath.row]
            }
        }
    }
    
    //MARK: - 從Add new restaurant畫面返回（關閉畫面 與 儲傳送資料)
    
    //unwindToHome是連結到story borad的exit，所以不管怎麼樣按下按鈕後就會Exit
    @IBAction func unwindToHome(segue: UIStoryboardSegue){
            dismiss(animated: true, completion: nil)
    }
 
}
