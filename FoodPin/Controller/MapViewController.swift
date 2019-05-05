//
//  MapViewController.swift
//  FoodPin
//
//  Created by 劉子瑜 on 2019/5/1.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import MapKit

//地圖contorller
class MapViewController: UIViewController ,MKMapViewDelegate{
    
    //用來找餐廳位置
    var restaurant = Restaurant()

    @IBOutlet var mapView: MKMapView!
    
    
    //MARK: -關於view載入與結束
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //顯示交通流量大的短
        mapView.showsTraffic = true
        
        //地圖上左上角顯示比例尺
        mapView.showsScale = true
        
        //底圖上右上角顯示指南針
        mapView.showsTraffic = true
        
        //mapView的delegate是自己
        mapView.delegate = self
        
        //設定返回按鈕與標題的顏色為白色
        navigationController?.navigationBar.tintColor = .darkGray
        
        
        //將地址轉換成全球經緯度並標記在地圖上
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(restaurant.location) { (placemarks, error) in
            
            //如果有出錯
            if let error = error{
                
                print(error)
                
                //停止程式執行
                return
            }
            
            if let placemarks = placemarks{
                
                //取得眾多地標的第一個地標
                let placemark = placemarks[0]
                
                //加上大頭針，大頭針底下有標題與副標題
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                //嘗試取得位置
                if let location = placemark.location{
                    
                    annotation.coordinate = location.coordinate
                    
                    
                    //顯示標記
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
                
            }
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //設定返回按鈕與標題的顏色為白色
        navigationController?.navigationBar.tintColor = .white
    }
 
    

    //MARK: - 關於地圖標示
    
    //每次要顯示標記都會呼叫以下function
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyMarker"
        
        //標記會標出所有位置，包含使用者位置，如果目前的位置為現在使用者位置標記會標出所有位置，包含使用者位置，則應該不要標示出來
        if annotation.isKind(of: MKUserLocation.self){
            return nil
        }
        
    //如果可行則在重複使用標記，使用dequeueReusableAnnotationView來達成是否有未使用的View，並將它轉型成MKMarkerAnnotationView
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil{
            
            //如果沒有任何可用的視圖，則我們自己創立一個View
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotationView?.glyphText = "😚"
        annotationView?.markerTintColor = UIColor.orange
        
        return annotationView
    }
}
