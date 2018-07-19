//
//  Protocol.swift
//  彩小蜜
//
//  Created by 笑 on 2018/7/11.
//  Copyright © 2018年 韩笑. All rights reserved.
//

import Foundation

protocol LotteryProtocol : DateProtocol { }

extension LotteryProtocol {
    func matchStart(with time : Int) -> Bool {
        let currentDate = Date()
        let startDate = timeStampToDate(time)
        let xxxx =  currentDate >= startDate
        return xxxx
    }
    
    func matchIntervalue (with time : Int) -> Int {
        let calendar = Calendar.current
        
        let currentDate = Date()
        let startDate = timeStampToDate(time)
        
        let dateCom = calendar.dateComponents([.minute], from: startDate, to: currentDate)
        
        return dateCom.minute!
    }
    
    func currentMinute () -> Int {
        let calendar = Calendar.current
        
        let dateCom = calendar.dateComponents([.minute], from: Date())
        return dateCom.minute!
    }
    
    
}


typealias ActionBlock = () -> ()

class CXMGCDTimer {
    //单例
    static let shared = CXMGCDTimer()
    
    lazy var timerContainer = [String: DispatchSourceTimer]()
    
    /// GCD定时器
    ///
    /// - Parameters:
    ///   - name: 定时器名字
    ///   - timeInterval: 时间间隔
    ///   - queue: 队列
    ///   - repeats: 是否重复
    ///   - action: 执行任务的闭包
    func scheduledDispatchTimer(WithTimerName name: String?, timeInterval: Double, queue: DispatchQueue, repeats: Bool, action: @escaping ActionBlock) {
        
        if name == nil {
            return
        }
        
        var timer = timerContainer[name!]
        if timer == nil {
            timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
            timer?.resume()
            timerContainer[name!] = timer
        }
        
        
        let currentMin = currentMinute()
        let dely : Double = Double( 60 - currentMin)
        
       
        
        //精度0.1秒
        timer?.schedule(deadline: .now() + dely , repeating: timeInterval, leeway: DispatchTimeInterval.milliseconds(100))
        timer?.setEventHandler(handler: { [weak self] in
            action()
            if repeats == false {
                self?.cancleTimer(WithTimerName: name)
            }
        })
    }
    
    /// 取消定时器
    ///
    /// - Parameter name: 定时器名字
    func cancleTimer(WithTimerName name: String?) {
        let timer = timerContainer[name!]
        if timer == nil {
            return
        }
        timerContainer.removeValue(forKey: name!)
        timer?.cancel()
    }
    
    
    /// 检查定时器是否已存在
    ///
    /// - Parameter name: 定时器名字
    /// - Returns: 是否已经存在定时器
    func isExistTimer(WithTimerName name: String?) -> Bool {
        if timerContainer[name!] != nil {
            return true
        }
        return false
    }
    
    func currentMinute () -> Int {
        let calendar = Calendar.current
        
        let dateCom = calendar.dateComponents([.second], from: Date())
        return dateCom.second!
    }
    
}

