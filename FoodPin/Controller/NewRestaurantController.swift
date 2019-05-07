//
//  NewRestaurantController.swift
//  FoodPin
//
//  Created by 劉子瑜 on 2019/5/5.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit

//使用UITextFieldDelegate協定來偵測return被按下
//使用UIImagePickerControllerDelegate與UINavigationControllerDelegate來知道選擇哪張圖片
class NewRestaurantController: UITableViewController , UITextFieldDelegate ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet var photoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //設定navigation bar外觀
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        
        if let customFont = UIFont(name: "Rubik", size: 35.0){
            
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.red,
                NSAttributedString.Key.font: customFont]
        }   else{
            print("navigation bar字體設置失敗")
        }
        
    }

    //我們為所有的文字欄位與圖示增加標籤值
    @IBOutlet var nameTextField: RoundedTextField!{
        
        didSet{
            nameTextField.tag = 1
            
            //將最小的標籤值視為第一個響應者
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
        }
    }
    
    @IBOutlet var typeTextField: RoundedTextField!{
        
        didSet{
            typeTextField.tag = 2
            typeTextField.delegate = self
        }
    }
    
    @IBOutlet var addressTextField: RoundedTextField!{
        
        didSet{
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
    
    @IBOutlet var phoneTextField: RoundedTextField!{
        
        didSet{
            phoneTextField.tag = 4
            phoneTextField.delegate = self
        }
    }
    
    @IBOutlet var descriptionTextView: UITextView!{
        
        didSet{

            descriptionTextView.tag = 5
            
            descriptionTextView.layer.cornerRadius = 5.0
            descriptionTextView.layer.masksToBounds = true
        }
    }
    
    
    
    //MARK: - 按下return會呼叫此function
    
    //使用此方法當使用者按下return後將游標移動至下一個位置
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //將目前的tag+1並且使用view.viewWithTag來取得下一個文字欄位
        if let nextTextField = view.viewWithTag(textField.tag + 1){
            
            //移除隊目前文字欄位的焦點
            textField.resignFirstResponder()
            
            //讓下一個文字欄位成為第一個響應者
            nextTextField.becomeFirstResponder()
            
        }
        
        return true
    }
    
    
    //MARK: - 實作挑選照片. 或是拍照
    
    //某個cell被選取後會呼叫table:didselectrowat方法
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //如果是第一個cell(也就是image那邊)
        if indexPath.row == 0{
            
            //建立一個AlertController
            let photoSourceRequestController =
                UIAlertController(title: "",            //UIAlertController：代表要建立一個跳出來的選單
                    message: "Choose your photo source",
                    preferredStyle: .actionSheet) //actionSheet:從下方出現AlertController
            
            //相機
            let cameraAction =
                UIAlertAction(title: "Camera", style: .default) {   //新增一個UIAlertAction，表示為相機
                    (action) in
                    
                    //isSourceTypeAvailable：如果使用者同意使用某種特定的type來選取media
                    if UIImagePickerController.isSourceTypeAvailable(.camera){
                        
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = self
                        imagePicker.allowsEditing = false
                        
                        //.sourceType:代表從哪裡取得
                        imagePicker.sourceType = .camera
                        
                        //使用present:animated:completion帶出來相機
                        self.present(imagePicker, animated: true, completion: nil)
                        
                    }
            }
            
            //相簿
            let photoLibraryAction =
                UIAlertAction(title: "Photo library", style: .default) {   //新增一個UIAlertAction
                    (action) in
                    
                    //isSourceTypeAvailable：如果使用者同意使用某種特定的type來選取media
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                        
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = self

                        imagePicker.allowsEditing = false
                        imagePicker.sourceType = .photoLibrary
                        
                        //使用present:animated:completion帶出來相簿
                        self.present(imagePicker, animated: true, completion: nil)
                        
                    }
            }
            
            //將兩種action加入UIAlertController選單裡面
            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)
            
            
            //針對ipad
            if let popoverController = photoSourceRequestController.popoverPresentationController{
                
                if let cell = tableView.cellForRow(at: indexPath){
                    
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            present(photoSourceRequestController, animated: true, completion: nil)
        }
    }
    
    //當從圖片庫選擇照片後，imagePickerController:didFinishPickingMediaWithInfo會被呼叫
    //當被呼叫時，系統會傳送一個包含圖片的info字典物件
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //MARK: - 使用程式碼刻出Auto layout
        //UIImagePickerController.InfoKey.originalImage是使用者所選圖片的鍵
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            photoImageView.image = selectedImage
            
            //圖片以什麼模式呈現
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
            
            let leadingConstraint =
                NSLayoutConstraint(item: photoImageView,    //item對應到First Item
                                   attribute: .leading,     //attribute對應到First item.後面的項目
                                   relatedBy: .equal,       //對應到Relation
                                   toItem: photoImageView.superview,    //toItem對應到Second Item
                                   attribute: .leading,     //attribute對應到Second Item.後面的項目
                                   multiplier: 1,       //一樣對應到multiplier
                                   constant: 0)     //一樣
            
            //isActive要true才會有layout
            leadingConstraint.isActive = true
            
            
            let trailingConstraint =
                NSLayoutConstraint(item: photoImageView,    //item對應到First Item
                    attribute: .trailing,     //attribute對應到First item.後面的項目
                    relatedBy: .equal,       //對應到Relation
                    toItem: photoImageView.superview,    //toItem對應到Second Item
                    attribute: .trailing,     //attribute對應到Second Item.後面的項目
                    multiplier: 1,       //一樣對應到multiplier
                    constant: 0)     //一樣
            
            //isActive要true才會有layout
            trailingConstraint.isActive = true
            
            
            let topConstraint =
                NSLayoutConstraint(item: photoImageView,    //item對應到First Item
                    attribute: .top,     //attribute對應到First item.後面的項目
                    relatedBy: .equal,       //對應到Relation
                    toItem: photoImageView.superview,    //toItem對應到Second Item
                    attribute: .top,     //attribute對應到Second Item.後面的項目
                    multiplier: 1,       //一樣對應到multiplier
                    constant: 0)     //一樣
            
            //isActive要true才會有layout
            topConstraint.isActive = true
            
            
            let bottomConstraint =
                NSLayoutConstraint(item: photoImageView,    //item對應到First Item
                    attribute: .bottom,     //attribute對應到First item.後面的項目
                    relatedBy: .equal,       //對應到Relation
                    toItem: photoImageView.superview,    //toItem對應到Second Item
                    attribute: .bottom,     //attribute對應到Second Item.後面的項目
                    multiplier: 1,       //一樣對應到multiplier
                    constant: 0)     //一樣
            
            //isActive要true才會有layout
            bottomConstraint.isActive = true
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    //MARK: - 練習一：移除分隔符號
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //分隔符號名稱叫做separator，將它設定為無
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
     }
    
    
    //MARK: - 練習2：做一個Save button
    @IBAction func saveRestaurant(sender:AnyObject){
        if nameTextField.text == "" || typeTextField.text == "" || addressTextField.text == "" || phoneTextField.text == "" || descriptionTextView.text == ""{
            
            //使用UIAlertController產生alert，UIAlertController是回傳一個View，所以沒辦法有按下的行為
            let warningView = UIAlertController(title: "Warning", message: "有空格歐", preferredStyle: .alert)
            
            //要有動作(按下button)只能使用UIAlertAction，定義為 An action that can be taken when the user taps a button in an alert.
            let okButton = UIAlertAction(title: "OK", style: .cancel , handler: nil)
            
            //別忘了加ok按鈕，要不然會悲劇
            warningView.addAction(okButton)
            
            //產生alert之後要顯示出來
            present(warningView,animated: true, completion: nil)
            
            
            
            //強制返回，不做任何事情
            return
        }
        
        //輸入完畢之後就可以跳回去主畫面了
        dismiss(animated: true, completion: nil)
        
        //使用??來把內容拆出來
        print("name:\(nameTextField.text ?? " ")")
        print("type:\(typeTextField.text ?? " ")")
        print("address:\(addressTextField.text ?? " ")")
        print("phone:\(phoneTextField.text ?? " ")")
        print("description:\(descriptionTextView.text ?? " ")")

        
    
    }
 
    

}
