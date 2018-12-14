//
//  Location.swift
//  彩小蜜
//
//  Created by 笑 on 2018/11/27.
//  Copyright © 2018 韩笑. All rights reserved.
//

import Foundation
import CoreLocation

let a : Double = 6378245.0
let ee : Double = 0.00669342162296594323
let pi : Double = Double(CGFloat.pi)
let xPi : Double = Double(CGFloat.pi * 3000.0 / 180.0)

struct Location: LocationPro {

    var latitude: Double
    
    var longitude: Double

    init(latitude : Double, longitude : Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
}

class LocationModel : NSObject, NSCoding {
    /// 省
    var administrativeArea : String = ""
    /// 自治区
    var subAdministrativeArea : String = ""
    var locality : String = ""
    /// 区
    var subLocality : String = ""
    /// 地名
    var name : String = ""
    ///
    var latitude: Double!
    
    var longitude: Double!
    
    override init() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        administrativeArea = aDecoder.decodeObject(forKey: "administrativeArea") as? String ?? ""
        subAdministrativeArea = aDecoder.decodeObject(forKey: "subAdministrativeArea") as? String ?? ""
        locality = aDecoder.decodeObject(forKey: "locality") as? String ?? ""
        subLocality = aDecoder.decodeObject(forKey: "subLocality") as? String ?? ""
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        latitude = aDecoder.decodeObject(forKey: "latitude") as? Double ?? 0.0
        longitude = aDecoder.decodeObject(forKey: "longitude") as? Double ?? 0.0
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(administrativeArea, forKey: "administrativeArea")
        aCoder.encode(subAdministrativeArea, forKey: "subAdministrativeArea")
        aCoder.encode(locality, forKey: "locality")
        aCoder.encode(subLocality, forKey: "subLocality")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
    }
}

class LocationManager: NSObject {
    
    typealias locationCallBack = (_ curLocation:CLLocation?,_ curAddress:LocationModel?,_ errorReason:String?)->()
    
    
    
    //MARK:-属性
    
    ///单例,唯一调用方法
    static let shareManager:LocationManager =  LocationManager()
    
    private override init() {

    }
    
    var manager:CLLocationManager?
    
    //当前坐标
    var curLocation: CLLocation?
    //当前选中位置的坐标
    var curAddressCoordinate: CLLocationCoordinate2D?
    //当前位置地址
    var curAddress: String?
    
    
    //回调闭包
    var  callBack:locationCallBack?
    
    func creatLocationManager() -> LocationManager{
        manager = CLLocationManager()
        //设置定位服务管理器代理
        manager?.delegate = self
        //设置定位模式
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        manager?.distanceFilter = 100
        //发送授权申请
        manager?.requestWhenInUseAuthorization()
        
        return self
    }
    
    //更新位置
    open func startLocation(resultBack:@escaping locationCallBack){
        
        self.callBack = resultBack
        
        if CLLocationManager.locationServicesEnabled(){
            //允许使用定位服务的话，开启定位服务更新
            manager?.startUpdatingLocation()
            print("定位开始")
        }
    }
    
}


extension LocationManager:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        curLocation = locations.last!
        //停止定位
        if locations.count > 0{
            manager.stopUpdatingLocation()
            LonLatToCity()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        callBack!(nil,nil,"定位失败===\(error)")
    }
    
    ///经纬度逆编
    func LonLatToCity() {
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(self.curLocation!) { (placemark, error) -> Void in
            if(error == nil){
                let firstPlaceMark = placemark!.first
                
                let model = LocationModel()
                model.latitude = self.curLocation?.coordinate.latitude
                model.longitude = self.curLocation?.coordinate.longitude
                
                self.curAddress = ""
                //省
                if let administrativeArea = firstPlaceMark?.administrativeArea {
                    self.curAddress?.append(administrativeArea)
                    model.administrativeArea = administrativeArea
                }
                //自治区
                if let subAdministrativeArea = firstPlaceMark?.subAdministrativeArea {
                    self.curAddress?.append(subAdministrativeArea)
                    model.subAdministrativeArea = subAdministrativeArea
                }
                //市
                if let locality = firstPlaceMark?.locality {
                    self.curAddress?.append(locality)
                    model.locality = locality.replacingOccurrences(of: "市", with: "")
                    if model.administrativeArea == "" {
                        model.administrativeArea = locality.replacingOccurrences(of: "市", with: "")
                    }
                }
                //区
                if let subLocality = firstPlaceMark?.subLocality {
                    self.curAddress?.append(subLocality)
                    model.subLocality = subLocality
                }
                //地名
                if let name = firstPlaceMark?.name {
                    self.curAddress?.append(name)
                    model.name = name
                }
                
                self.callBack!(self.curLocation,model,nil)
                
            }else{
                self.callBack!(nil,nil,"\(String(describing: error))")
            }
        }
    }
    
}
extension LocationManager {
    static func saveLocation(location : LocationModel) {
        let data = NSKeyedArchiver.archivedData(withRootObject: location)
        UserDefaults.standard.set(data, forKey: "location")
    }
    static func getLocation() -> LocationModel? {
        guard let location = UserDefaults.standard.data(forKey: "location") else { return nil }
        guard let model = NSKeyedUnarchiver.unarchiveObject(with: location) as? LocationModel else { return nil }
        return model
    }
}

protocol LocationPro {
    var latitude : Double {get set}
    var longitude : Double {get set}
}

extension LocationPro {
    func transformFromGPSToGD() -> (latitude : Double, longitude : Double) {
        let coor = transformFromWGSToGCJ(wgsLoc: CLLocationCoordinate2DMake(self.latitude, self.longitude))
        return (latitude : coor.latitude, longitude : coor.longitude)
    }
    func transformFromGDToBD() -> (latitude : Double, longitude : Double) {
        let coor = transformFromGCJToBaidu(p: CLLocationCoordinate2DMake(self.latitude, self.longitude))
        return (latitude : coor.latitude, longitude : coor.longitude)
    }
    mutating func transformFromGPSToBD() -> (latitude : Double, longitude : Double) {
        let gd = transformFromGPSToGD()
        self.latitude = gd.latitude
        self.longitude = gd.longitude
        return transformFromGDToBD()
    }
    
    
    private func transformFromWGSToGCJ(wgsLoc : CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        var adjustLoc : CLLocationCoordinate2D!
        
        if isLocationOutOfChina(location: wgsLoc) {
            adjustLoc = wgsLoc
        }else {
            var adjustLat = transformLatWithX(x: wgsLoc.longitude - 105.0 , y: wgsLoc.latitude - 35.0 )
            var adjustLon = transformLonWithX(x: wgsLoc.longitude - 105.0, y: wgsLoc.latitude - 35.0 )
            let radLat : Double = wgsLoc.latitude / 180.0 * pi
            var magic : Double = sin(radLat)
            magic = 1 - ee * magic * magic
            let sqrtMagic : Double = sqrt(magic)
            
            adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi)
            adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi)
            
            adjustLoc = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
            
            adjustLoc.latitude = wgsLoc.latitude + adjustLat
            adjustLoc.longitude = wgsLoc.longitude + adjustLon
        }
        return adjustLoc
    }
    
    private func transformLatWithX(x : Double, y : Double) -> Double {
        var lat : Double = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x))
        lat += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0
        lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0
        lat += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0
        return lat
    }
    private func transformLonWithX(x : Double, y : Double) -> Double{
        var lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x))
        lon += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0
        lon += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0
        lon += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0
        return lon
    }
    private func transformFromGCJToBaidu(p : CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let z : Double = sqrt(p.longitude * p.longitude + p.latitude * p.latitude) + 0.00002 * sqrt(p.latitude * pi)
        let theta : Double = atan2(p.latitude, p.longitude) + 0.000003 * cos(p.longitude * pi)
        
        var geoPoint : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        geoPoint.latitude  = (z * sin(theta) + 0.006)
        geoPoint.longitude = (z * cos(theta) + 0.0065)
        
        return geoPoint
    }
    // 判断某个点point是否在p1和p2之间
    private func isContains(point : CLLocationCoordinate2D, p1 : CLLocationCoordinate2D, p2 : CLLocationCoordinate2D) -> Bool {
        return (point.latitude >= min(p1.latitude, p2.latitude) && point.latitude <= max(p1.latitude, p2.latitude)) && (point.longitude >= min(p1.longitude, p2.longitude) && point.longitude <= max(p1.longitude, p2.longitude))
    }
    
    // 判断是不是在中国
    private func isLocationOutOfChina(location : CLLocationCoordinate2D) -> Bool {
        if location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271 {
            return true
        }
        return false
    }
}
