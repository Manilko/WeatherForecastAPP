//
//  Debugger.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

final class Debugger {
    static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    static var isRelease = !isDebug

    /// Use this method in debug scheme
    /// - Parameter debugHandler: this closure will be execute only in debug scheme
    class func run(_ debugHandler: () -> Void) {
        if isDebug { debugHandler() }
    }

    /// Use this method in debug or release scheme
    /// - Parameters:
    ///   - debugHandler: this closure will be execute only in debug scheme
    ///   - releaseHandler: this closure will be execute only in release scheme
    class func run(_ debugHandler: () -> Void, releaseHandler: (() -> Void)) {
        isDebug ? debugHandler() : releaseHandler()
    }
}
