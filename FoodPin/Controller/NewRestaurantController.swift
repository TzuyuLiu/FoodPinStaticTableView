//
//  NewRestaurantController.swift
//  FoodPin
//
//  Created by 劉子瑜 on 2019/5/5.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit

//使用UITextFieldDelegate協定來偵測return被按下
class NewRestaurantController: UITableViewController , UITextFieldDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
}
