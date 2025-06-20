//
//  Date+Extension.swift
//  iWallart
//
//  Created by 谭鹏 on 2022/6/16.
//

import Foundation

public extension Date{
    
    //两个时间间隔秒数
    func timeSinceDate( _ fromDate:Date) -> TimeInterval{
        let inter = self.timeIntervalSince(fromDate)
        return inter
    }
    //日期转字符串
    func toString() ->String{
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    
    //获取今天前N天的日期字符串
    func getNDayAgo( _ n:Int) -> String{
        let oneDay:TimeInterval = 24 * 60 * 60
        let theDate = Date.init(timeIntervalSinceNow: Double(-n)*oneDay)
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: theDate)
        return dateString
    }
    
    
    func getNDayAgoFromDate(_ n:Int) -> String{
        let oneDay:TimeInterval = 24 * 60 * 60
        let theDate = Date.init(timeInterval:  Double(-n)*oneDay, since: self)
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: theDate)
        return dateString
    }
    
    // MARK: 2022-11-21 新增时间相关方法扩展
    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    /// 获取当前时间戳
    /// - Returns: 当前时间戳
    static func getNowTimeStamp() -> Int {
        let nowDate = Date.init()
        //10位数时间戳
        let interval = Int(nowDate.timeIntervalSince1970)
        return interval
    }
    
    /// 获取当前时间字符串
    /// - Returns: 当前时间戳
    static func getNowTimeString(dateFormat: String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        let nowDate = Date.init()
        return dateformatter.string(from: nowDate)
    }
    
    
    
    /// 时间戳转换时间字符串
    /// - Parameters:
    ///   - timeStamp: 时间戳
    ///   - dateFormat: 自定义日期格式（如：yyyy-MM-dd HH:mm:ss）
    /// - Returns: 时间字符串
    static func getTimeString(timeStamp: Int, dateFormat: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval.init(timeStamp))
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        return dateformatter.string(from: date)
    }
    
    
    /// 日期转Date
    /// - Parameters:
    ///   - timeString: 日期字符串
    ///   - dateFormat: 自定义日期格式（如：yyyy-MM-dd HH:mm:ss）
    /// - Returns: Date
    static func getDate(timeString: String, dateFormat: String) -> Date {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        let date = dateformatter.date(from: timeString) ?? Date()
        return date
    }
    
    /// 日期转时间戳
    /// - Parameters:
    ///   - timeString: 日期字符串
    ///   - dateFormat: 自定义日期格式（如：yyyy-MM-dd HH:mm:ss）
    /// - Returns: 时间戳
    static func getTimeStamp(timeString: String, dateFormat: String) -> Int {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        let date = self.getDate(timeString: timeString, dateFormat: dateFormat)
        return Int(date.timeIntervalSince1970)
    }
    
    
    /// 时间戳转换时间date
    /// - Parameters:
    ///   - timeStamp: 时间戳
    /// - Returns: date
    static func getDateWith(timeStamp: Int) -> Date {
        let date = Date(timeIntervalSince1970: TimeInterval.init(timeStamp))
        return date
    }
    
    
    /// 获取（年，月，日，时，分，秒）
    /// - Returns: （年，月，日，时，分，秒）
    func getTime() -> (String, String, String, String, String, String) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy"
        let y = dateformatter.string(from: self)
        dateformatter.dateFormat = "MM"
        let mo = dateformatter.string(from: self)
        dateformatter.dateFormat = "dd"
        let d = dateformatter.string(from: self)
        dateformatter.dateFormat = "HH"
        let h = dateformatter.string(from: self)
        dateformatter.dateFormat = "mm"
        let m = dateformatter.string(from: self)
        dateformatter.dateFormat = "ss"
        let s = dateformatter.string(from: self)
        
        return (y, mo, d, h, m, s)
    }
    
    
    /// 获取时间字符串
    /// - Parameter dateFormat: 自定义日期格式（如：yyyy-MM-dd HH:mm:ss）
    /// - Returns: 时间字符串
    func getStringTime(dateFormat: String) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        return dateformatter.string(from: self)
    }
    
    // MARK: 2023-03-13 新增扩展
    func getNowTimeYearMonthDayString () -> String {    //获取当前的年月日拼接的字符串
        let calendar = Calendar.current
        let date = Date()
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let nowStr = String(format: "%d%d%d", year,month,day)
        return nowStr
    }
    
}
