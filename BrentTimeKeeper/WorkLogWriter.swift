//
//  WorkLogWriter.swift
//  BrentTimeKeeper
//
//  Created by Brent Peterson on 1/4/26.
//

import Foundation

class WorkLogWriter {
    // Path to work log - reads from environment variable or uses default
    private let workLogPath: String

    // Default path (users should set TIMEKEEPER_LOG_PATH environment variable)
    private static let defaultPath = "~/Documents/WORK-LOG.md"

    init() {
        if let envPath = ProcessInfo.processInfo.environment["TIMEKEEPER_LOG_PATH"] {
            workLogPath = NSString(string: envPath).expandingTildeInPath
        } else {
            workLogPath = NSString(string: WorkLogWriter.defaultPath).expandingTildeInPath
        }
    }

    func logSession(startTime: Date, endTime: Date, hours: Double, task: String?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: Date())

        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short

        let startString = timeFormatter.string(from: startTime)
        let endString = timeFormatter.string(from: endTime)
        let hoursString = String(format: "%.2f", hours)

        // Read existing content
        var content = (try? String(contentsOfFile: workLogPath, encoding: .utf8)) ?? ""

        // Check if today's date header exists
        let dateHeader = "## \(todayString)"
        if !content.contains(dateHeader) {
            // Add new date section
            content += "\n\n\(dateHeader)\n"
            content += "| Start | End | Hours | Task |\n"
            content += "|-------|-----|-------|------|\n"
        }

        // Add the session row
        let taskDisplay = task ?? "-"
        let newRow = "| \(startString) | \(endString) | \(hoursString) | \(taskDisplay) |\n"

        // Find where to insert (after the table header for today)
        if let range = content.range(of: dateHeader) {
            // Find the end of the table header (after |-------|)
            let searchStart = range.upperBound
            if let headerEnd = content.range(of: "|------|\n", range: searchStart..<content.endIndex) {
                let insertIndex = headerEnd.upperBound
                content.insert(contentsOf: newRow, at: insertIndex)
            } else {
                // Fallback: append to end
                content += newRow
            }
        } else {
            content += newRow
        }

        // Write back
        do {
            try content.write(toFile: workLogPath, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to write to work log: \(error)")
        }
    }
}
