//
//  GCD+Extension.swift
//  CallerShow
//
//  Created by 谷广州 on 2023/9/8.
//

import Foundation

public struct GCD {

    // 异步执行回主线程写法
    static func asyncExcuteInMainThread(block: @escaping( () -> Void )) {
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                block()
            }
        }
    }

    // 延迟执行
    static func delyAsyncExcuteInMainThread(timeInter: Double, block: @escaping( () -> Void )) {
        let deadline = DispatchTime.now() + timeInter
        DispatchQueue.global().asyncAfter(deadline: deadline, execute: {
            DispatchQueue.main.async {
                block()
            }
        })
    }
}
