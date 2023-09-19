//
//  AppLogger.swift
//  WeatherForecastAPP
//
//  Created by Yevhenii Manilko  on 19.09.2023.
//

import Foundation

final class AppLogger {

    enum Level: String {
        case debug = "🔹"
        case info = "ℹ️"
        case success = "🟢"
        case warning = "⚠️"
        case error = "🚫"
        case exertion = "❗️"
    }

    private init() {}

    static var displayLog: Bool {
        #if PRODUCTION
            return false
        #else
            return true
        #endif
    }

    static func log(level: Level = .debug, _ message: Any..., filePath: String = #file, function: String = #function, line: Int = #line) {
        for message in message {
            customPrint(message, level: level, filePath: filePath, function: function, line: line)
        }
    }

    private static func customPrint(_ message: Any, level: Level, filePath: String, function: String, line: Int, toFile: Bool = false) {
        guard displayLog else { return }

        let fileName = filePath.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? "unkonwn_file_name"
        let stringToPrint = "\(Date()) \(level.rawValue) \(fileName).swift => \(function) => at line \(line) => \(message)"
        Debugger.run({
            print(stringToPrint)
        }, releaseHandler: {
            print("RELEASE SCHEME: \(stringToPrint)")
        })
    }
}


