//
//  RestaurantDetailMapCell.swift
//  FoodPin
//
//  Created by 劉子瑜 on 2019/5/1.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailMapCell: UITableViewCell {
    
    @IBOutlet var mapView: MKMapView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - 地圖相關
    
    
    //加入大頭針
    func configure(location: String){
        
        //使用Geocoder類別將文字位置轉換成全球經緯度的座標位置
        let geoCoder = CLGeocoder()
        
        //取得成功的物件稱為placemarks，越精準物件數量越少
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
    
            //如果有出錯
            if let error = error{
                print(error.localizedDescription)
                
                //停止執行
                return
            }
            
            if let placemarks = placemarks{
                
                //取得第一個地標標記
                let placemark = placemarks[0]
                
                //加上記號
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location{
                    
                    //地圖上加上大頭針
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    
                    //設定地圖的縮放程度為250半徑範圍
                    let region = MKCoordinateRegion(
                        center: annotation.coordinate,
                        latitudinalMeters: 250,
                        longitudinalMeters: 250)
                    
                    self.mapView.setRegion(region, animated: false)
                }
                
            }
            
            
        }
    }

}
