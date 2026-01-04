//
//  BrentTimeKeeperApp.swift
//  BrentTimeKeeper
//
//  Created by Brent Peterson on 1/4/26.
//

import SwiftUI

@main
struct BrentTimeKeeperApp: App {
    @StateObject private var timerManager = TimerManager()

    var body: some Scene {
        MenuBarExtra {
            MenuBarView(timerManager: timerManager)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: timerManager.state == .running ? "timer" : "timer.circle")
                if timerManager.state == .running || timerManager.state == .paused {
                    Text(timerManager.formattedElapsedTime)
                        .monospacedDigit()
                }
            }
        }
        .menuBarExtraStyle(.window)
    }
}
