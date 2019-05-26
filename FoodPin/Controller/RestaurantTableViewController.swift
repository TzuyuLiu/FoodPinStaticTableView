//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Simon Ng on 8/8/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit
import CoreData //要使用NSFetchedRestsController

//NSFetchedResultsControllerDelegate協定在控制器讀取的結果有變化時，提供方法來通知他的委派
//使用UISearchResultsUpdating來更新搜尋結果
class RestaurantTableViewController: UITableViewController , NSFetchedResultsControllerDelegate ,UISearchResultsUpdating{

    var restaurants:[RestaurantMO] = []
    
    
    //為了加上搜尋列所以使用UISearchController
    var searchController: UISearchController!

    //儲存搜尋結果
    var searchResults: [RestaurantMO] = []
    
    //將NSFetchedResultsControllerDelegate方法建立一個實例變數
    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    
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
        
        //設定大標題的文字為紅色，文字使用Rubik-Medium會找不到變成沒出現效果
        if let customFont = UIFont(name: "Rubik", size: 40.0){
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor : UIColor(red: 231.0/255, green: 76.0/255, blue: 60.0/255, alpha: 1.0), NSAttributedString.Key.font: customFont ]
        }
        
        
        //從資料儲存區讀取資料
        
        //從RestaurantMO取得NSFetchRequest物件(建立fetchRequest連線)
        let fetchRequest:NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        
        //使用NSSortDescriptro排序物件，指定sortDescriptor為排序方法
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //誤了讀取變數，需要先取得AppDelegate的參照，使用UIApplication.shared.delegate as? Applegate來取得物件
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            
            
            let context = appDelegate.persistentContainer.viewContext
            
            //使初始化NSFetchedResultsController，並指定他的委派(delegate)來監聽資料變化
            fetchResultController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
            
            //記得要設置delegate，這樣才能在加入新餐廳時使用NSFetchedResultsController來更新tableView
            fetchResultController.delegate = self
            
            do{
                
                //使用performFetch來執行讀取結果
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects{
                    restaurants = fetchedObjects
                }
                
            } catch {
                print(error)
            }
        }
        
        
        //建立UISearchController實例(就是建立搜尋列)
        //如果傳遞nil值，表示搜尋結果會顯示於你正在搜尋的相同視圖中
        searchController = UISearchController(searchResultsController: nil)
        
        //告知搜尋控制器哪一個物件會負責更新搜尋結果
        //使用tableHeaderView來將搜尋器固定在最前面
        tableView.tableHeaderView = searchController.searchBar
        
        //指定目前類別為搜尋結果更新氣
        searchController.searchResultsUpdater = self
        
        //控制器底下的內容在搜尋時期是否要變成暗淡的狀態，因為我們呈現的結果在相同的view，所以是false
        searchController.dimsBackgroundDuringPresentation = false
        
        
        //客製化搜尋列
        searchController.searchBar.barTintColor = .white
        
        
    }
    
    //每次view出現時都會執行
    override func viewWillAppear(_ animated: Bool) {
        
        //要先super才能用
        super.viewWillAppear(animated)
        

        
        //設定往左滑動就能隱藏導覽列(時間下面那條)
        navigationController?.hidesBarsOnSwipe = true
        
    }
    
    //viewDidAppear會由ios自動呼叫
    override func viewDidAppear(_ animated: Bool) {
        
        //判斷是否要跳過導覽，若看過就跳過導覽
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough"){
            return
        }
        
        let storyboard  = UIStoryboard(name: "Onboarding", bundle: nil)
        
        //將WalkthroughContentViewController物件實體化，並將他已強制回應(Modal)方式呈現
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
             present(walkthroughViewController, animated: true, completion:  nil)
        }
        
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //當點擊搜尋欄位，搜尋介面就會被帶出來，isActive屬性會設定為true，用此決定顯示全部餐廳或是搜尋結果
        if searchController.isActive{
            
            //此時就回傳result的數量
            return searchResults.count
        } else{
            
            //預設回傳餐廳數量
            return restaurants.count
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "datacell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
        
        //觀察搜尋列是否有打開來判斷是從搜尋結果取得餐廳還是原來的陣列取得餐廳
        let restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
        
        // Configure the cell...
        cell.nameLabel.text = restaurant.name
        
        //圖片已經使用core data來存成data物件，要載入圖片是使用data參數來初始化UIImage物件
        if let restaurantImage = restaurant.image{
            cell.thumbnailImageView.image = UIImage(data: restaurantImage as Data)
        }
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        cell.heartImageView.isHidden = restaurant.isVisited ? false : true
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            //從資料儲存區刪除
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                
                //從fetchResultController中取得所選的RestaurantMO物件
                let context = appDelegate.persistentContainer.viewContext
                let restaurantToDelete = self.fetchResultController.object(at: indexPath)
                
                //呼叫delete方法將他們刪除
                context.delete(restaurantToDelete)
                
                //儲存這些耕變
                appDelegate.saveContext()
            }
            
            // 以true值來呼叫完成處理器
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
    
    
    //在搜尋期間關閉cell的編輯
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if searchController.isActive{
            return false
        } else {
            return true
        }
    }
    
    //MARK:- NSFetchedResultsControllerDelegate
    
    //當NSFetchedResultsController準備開始處理內容更變時會被呼叫
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        //準備開始更新
        tableView.beginUpdates()
    }
    
    //若託管物件內容有任何更變就會被呼叫(e.g.:加入新餐廳)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        //表示插入新列
        case .insert:
            if let newIndexPath = newIndexPath{
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            
        //表示刪除列
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        case .update:
            if let indexPath = indexPath{
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects{
            
            restaurants = fetchedObjects as! [RestaurantMO]
        }
        
    }
    
    //NSFetchedResultsController變更完成後會呼叫以下方法，告訴tableView已完成變更，他就會以動畫呈現變更
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! RestaurantDetailViewController
                
                //觀察搜尋列是否有打開來判斷是從搜尋結果取得餐廳還是原來的陣列取得餐廳
                destinationController.restaurant = (searchController.isActive) ? searchResults[indexPath.row]: restaurants[indexPath.row]
            }
        }
    }
    
    //MARK: - 從Add new restaurant畫面返回（關閉畫面 與 儲傳送資料)
    
    //unwindToHome是連結到story borad的exit，所以不管怎麼樣按下按鈕後就會Exit
    @IBAction func unwindToHome(segue: UIStoryboardSegue){
            dismiss(animated: true, completion: nil)
    }
 
    //MARK: - 搜尋列實作
    
    //找尋餐廳名稱
    func filterContent(for searchText: String){
        
        //filter:swift中的內建方法，用來過濾目前的陣列
        //使用filter做搜尋，會回傳一個新的陣列，內容是符合搜尋的項目(searchText)
        searchResults = restaurants.filter({ (restaurant) -> Bool in
            
            if let name = restaurant.name,let location = restaurant.location{
                
                //使用localizedCaseInsensitiveContains檢查餐廳名稱是否有含在搜尋文字裡面，有救回傳true
                let isMatch = name.localizedCaseInsensitiveContains(searchText) || location.localizedCaseInsensitiveContains(searchText)
                
                return isMatch
            }
            
           
           
            return false
        })
    }
    
    //更新搜尋結果(使用UISearchResultsUpdating)
    //當使用者選取搜尋列或輸入搜尋關鍵字，updateSearchResults就會被呼叫，searchController是指使用者輸入的關鍵字
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text{
            
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
 
    
    
    
}
