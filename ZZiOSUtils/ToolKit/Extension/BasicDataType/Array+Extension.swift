//
//  Array+Ex.swift
//  PictureLive
//
//  Created by Ja on 2023/9/4.
//

import Foundation

public extension Array {        
    /// 获取数组中的任一元素
     var any:Element? {
        get {
            let itemCount = count
            if itemCount == 0 {
                return nil
            }
            
            if itemCount == 1 {
                return first
            }
            
            let num = Int(arc4random()) % itemCount
            return self[num]
        }
    }
    
    /// 根据查询条件, 获取数组中的某一元素
     func one(_ finder:(Element)->Bool) -> Element? {
        for n in self {
            if finder(n) { return n }
        }
        return nil
    }
    
    /// 根据查询条件, 获取数组中的某一元素(反向查询)
     func oneRev(_ finder:(Element)->Bool) -> Element? {
        for i in indices.reversed() {    //使用indices的reversed, 而不是self的reversed, 可以减少内存占用
            let n = self[i]
            if finder(n) { return n }
        }
        return nil
    }
    
    /// 根据查询条件, 获取数组中的Index值
     func oneIndex(_ finder:(Element)->Bool) -> Index? {
        for i in indices {
            let n = self[i]
            if finder(n) { return i }
        }
        return nil
    }
    
    /// 根据查询条件, 获取数组中的Index值(反向查询)
     func oneIndexRev(_ finder:(Element)->Bool) -> Index? {
        let count = self.count
        if count == 0 { return nil }
        
        for i in indices.reversed() {
            let n = self[i]
            if finder(n) { return count - i - 1 }
        }
        return nil
    }
    
    /// 交换某两个元素的位置
     mutating func exchange(_ one:Index, _ another:Index) {
        let swap = self[one]
        self[one] = self[another]
        self[another] = swap
    }
    
    /// Map函数的带Index版本
     func mapIndex<T>(_ event: @escaping (_ value: Element, _ index: Int) -> T) -> [T] {
        return indices.map { event(self[$0], $0) }
    }

    /// ForEach函数的带Index版本
     func forEachIndex(_ event: @escaping (_ value: Element, _ index: Int) -> Void) {
        indices.forEach { event(self[$0], $0) }
    }

    /// Reduce函数的带Index版本
     func reduceIndex<T>(_ inital: T, combine: (T, (value: Element, index: Int)) -> T) -> T {
        return indices.reduce(inital, { combine($0, (value: self[$1], index: $1)) })
    }

    /// Filter函数的带Index版本
     func filterIndex(_ event: @escaping (_ value: Element, _ index: Int) -> Bool) -> [Element] {
        return indices.filter { event(self[$0], $0) }.map { self[$0] }
    }
    
    /// 判断每个元素都符合验证
     func isAll(_ checker:(_ value:Element)->Bool) -> Bool {
        for n in self {
            if checker(n) == false { return false }
        }
        return true
    }
    
    /// 判断任一一个元素符合验证
     func isAny(_ checker:(_ value:Element)->Bool) -> Bool {
        for n in self {
            if checker(n) == true { return true }
        }
        return false
    }
    
    /// 字符串类型的数组合并, 这是一个危险的函数, 只适用于[String], 如果是其它类型, 则会有问题.
     func combine(_ sep:String) -> String {
        let count = self.count
        return reduceIndex("") { (prev:String, next:(value: Element, index: Int)) -> String in
            let str = next.value as? String ?? ""
            if next.index == count - 1 {
                return prev + str
            } else {
                return prev + str + sep
            }
        }
    }
    
     func toDict<Key, Value>(_ combiner:(Element)->(Key, Value)) -> [Key:Value] {
        var result:[Key:Value] = [:]
        
        for n in self {
            let kv = combiner(n)
            result[kv.0] = kv.1
        }
        
        return result
    }
    
    ///安全取值
    public func safeIndex(newIndex: Int) -> Element? {
        if newIndex < 0 {
            return nil
        }
        if newIndex < count {
            return self[newIndex]
        }
        else {
            return nil
        }
    }
    
    /// 检查一个索引值是否在数组边界内
    public subscript(guarded idx: Int) -> Element? {
        guard (startIndex..<endIndex).contains(idx) else {
            return nil
        }
        return self[idx]
    }
    
    ///转化为json字符串
    public func toJsonString() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self,
                                                     options: []) else {
            return nil
        }
        guard let str = String(data: data, encoding: .utf8) else {
            return nil
        }
        return str
     }
}
