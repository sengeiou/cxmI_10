//
//  DeviceInfoModel.swift
//  彩小蜜
//
//  Created by 笑 on 2018/4/23.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import HandyJSON
import Reachability

class DeviceManager: AlertPro  {
    static let share = DeviceManager()
    
    var device : DeviceInfoModel!
    
    init() {
        getDeviceInfo()
    }
    private func getDeviceInfo() {
        var net = ""
        if let reachability = Reachability() {
            try? reachability.startNotifier()
            
            if reachability.connection == .none {
                
            }
            
            switch reachability.connection {
            case .wifi:
                net = "wifi"
            case .cellular:
                net = "mobile"
            case .none:
                net = "UNKNOWN"
            }
        }
        
    
        
        var device = DeviceInfoModel()
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        let infoDictionary = Bundle.main.infoDictionary!
        device.plat = "iphone"
        device.apiv = "1"
        device.appv = infoDictionary["CFBundleShortVersionString"] as! String
        device.appid = UIDevice.current.identifierForVendor?.description
        device.mac = getMacAddress()
        device.w = screenWidth
        device.h = screenHeight
        device.os = String(UIDevice.current.systemVersion)
        device.mid = identifier
        device.build = UIDevice.current.systemVersion
        device.net = net
        device.channel = ""
        
        
        
        self.device = device
        
        //return device
    }
    
    
    func getMacAddress()->String{
        guard let interfaces:NSArray = CNCopySupportedInterfaces() else { return "" }
        
        //var ssid: String?
        
        var mac: String?
        
        for sub in interfaces{
            if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(sub as! CFString)){
            //ssid = dict["SSID"] as? String
            mac = dict["BSSID"] as? String
            }
        }
        guard mac != nil else { return "" }
        return mac!
    }
}

struct DeviceInfoModel: HandyJSON {
    /// 设备平台
    var plat : String = "iphone"
    /// 协议版本号
    var apiv : String!
    /// app版本号
    var appv : String!
    /// app 唯一标识符
    var appid: String!
    /// 设备网卡mac地址
    var mac  : String!
    /// 设备屏幕宽度
    var w    : CGFloat!
    /// 设备屏幕高度
    var h    : CGFloat!
    /// 系统固件版本
    var os   : String!
    /// 设备具体型号信息，据此判断配件类型
    var mid  : String!
    /// 设备厂商信息，
    var brand: String! = "Apple"
    /// app 编译时间，
    var build: String!
    /// 推广渠道
    var channel:String!
    /// 当前网络连接类型
    var net  : String!
    
    var token: String!
}
