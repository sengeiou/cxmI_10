//
//  UserDataModel.swift
//  彩小蜜
//
//  Created by HX on 2018/3/12.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation
import HandyJSON

class UserDataModel: NSObject, HandyJSON, NSCoding{
//    var description: String {
//        return """
//        ***************************************
//
//         headImg   :   \(headImg!)
//         mobile    :   \(mobile!)
//
//        ***************************************
//        """
//    }
    
    var headImg: String!
    var mobile : String!
    var nickName: String!
    var token : String!
    var userId: String!
    var showMsg: String!
    //var xxxxx : String!
    
    required override init() {
        self.headImg = ""
        self.mobile = ""
        self.nickName = ""
        self.token = ""
        self.userId = ""
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(headImg, forKey: "headImg")
        aCoder.encode(mobile, forKey: "mobile")
        aCoder.encode(nickName, forKey: "nickName")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(showMsg, forKey: "showMsg")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.headImg = aDecoder.decodeObject(forKey: "headImg") as! String
        self.mobile = aDecoder.decodeObject(forKey: "mobile") as! String
        self.nickName = aDecoder.decodeObject(forKey: "nickName") as! String
        self.token = aDecoder.decodeObject(forKey: "token") as! String
        self.userId = aDecoder.decodeObject(forKey: "userId") as! String
        self.showMsg = aDecoder.decodeObject(forKey: "showMsg") as! String
    }
}

protocol UserInfoPro {
    
}
extension UserInfoPro {
    public func save(userInfo : UserDataModel) {
        let modelData = NSKeyedArchiver.archivedData(withRootObject: userInfo)
        UserDefaults.standard.set(modelData, forKey: "userInfo")
        UserDefaults.standard.synchronize()
    }
    public func getUserData() -> UserDataModel {
        guard let userData = UserDefaults.standard.object(forKey: "userInfo") as? Data else { return UserDataModel() }
        guard let userInfo = NSKeyedUnarchiver.unarchiveObject(with: userData ) as? UserDataModel else { return UserDataModel() }
        return userInfo
    }
    public func getToken() -> String {
        let userInfo = self.getUserData()
        return userInfo.token
    }
    public func removeUserData() {
        UserDefaults.standard.removeObject(forKey: "userInfo")
    }
}




