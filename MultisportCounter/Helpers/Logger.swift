//
//  Logger.swift
//  MultisportCounter
//
//  Created by Patryk Jastrzębski on 14/11/2023.
//

import IteoLogger

public func log(_ level: IteoLoggerLevel, _ module: IteoLoggerModule, _ value: Any) {
    Logger.shared.logger.log(level, module, value)
}

final class Logger {

    static let shared = Logger()

    static let loggerDirectoryName = "Logs"

    let logger = IteoLogger(consumers: [
        IteoLoggerConsoleItemConsumer(),
        IteoLoggerStorageItemConsumer(logsDirectoryName: Logger.loggerDirectoryName)
    ])

    func displayLogs() {
        logger.displayLogs(logsDirectoryName: Logger.loggerDirectoryName)
    }
}
