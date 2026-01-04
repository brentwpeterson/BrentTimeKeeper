//
//  TimerManager.swift
//  BrentTimeKeeper
//
//  Created by Brent Peterson on 1/4/26.
//

import Foundation
import Combine

enum TimerState {
    case idle
    case running
    case paused
}

@MainActor
class TimerManager: ObservableObject {
    @Published var state: TimerState = .idle
    @Published var currentTask: String = ""
    @Published var elapsedSeconds: Int = 0

    private var timer: Timer?
    private var startTime: Date?
    private var pausedElapsed: Int = 0

    private let workLogWriter = WorkLogWriter()

    var formattedElapsedTime: String {
        let hours = elapsedSeconds / 3600
        let minutes = (elapsedSeconds % 3600) / 60
        let seconds = elapsedSeconds % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }

    var formattedStartTime: String {
        guard let startTime = startTime else { return "--:--" }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: startTime)
    }

    func start() {
        state = .running
        startTime = Date()
        elapsedSeconds = 0
        pausedElapsed = 0
        startTimer()
    }

    func pause() {
        state = .paused
        pausedElapsed = elapsedSeconds
        stopTimer()
    }

    func resume() {
        state = .running
        startTimer()
    }

    func finish() {
        stopTimer()

        // Write to work log
        if let start = startTime {
            let hours = Double(elapsedSeconds) / 3600.0
            workLogWriter.logSession(
                startTime: start,
                endTime: Date(),
                hours: hours,
                task: currentTask.isEmpty ? nil : currentTask
            )
        }

        // Reset state
        state = .idle
        startTime = nil
        elapsedSeconds = 0
        pausedElapsed = 0
        currentTask = ""
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.elapsedSeconds = (self?.pausedElapsed ?? 0) + Int(Date().timeIntervalSince(self?.startTime ?? Date()))
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
