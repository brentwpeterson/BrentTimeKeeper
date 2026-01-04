//
//  MenuBarView.swift
//  BrentTimeKeeper
//
//  Created by Brent Peterson on 1/4/26.
//

import SwiftUI
import ServiceManagement

struct MenuBarView: View {
    @ObservedObject var timerManager: TimerManager
    @State private var taskInput: String = ""
    @State private var launchAtLogin: Bool = SMAppService.mainApp.status == .enabled

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.blue)
                Text("Brent Time Keeper")
                    .font(.headline)
            }
            .padding(.bottom, 4)

            Divider()

            // Timer Display
            if timerManager.state != .idle {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Elapsed:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(timerManager.formattedElapsedTime)
                            .font(.system(.title2, design: .monospaced))
                            .fontWeight(.semibold)
                            .foregroundColor(timerManager.state == .paused ? .orange : .primary)
                    }

                    HStack {
                        Text("Started:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(timerManager.formattedStartTime)
                    }

                    if !timerManager.currentTask.isEmpty {
                        HStack {
                            Text("Task:")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(timerManager.currentTask)
                                .lineLimit(1)
                        }
                    }

                    if timerManager.state == .paused {
                        Label("Paused", systemImage: "pause.circle.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                    }
                }
                .padding(.vertical, 4)

                Divider()
            }

            // Task Input (only when idle)
            if timerManager.state == .idle {
                TextField("What are you working on?", text: $taskInput)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        startWithTask()
                    }
            }

            // Action Buttons
            HStack(spacing: 8) {
                switch timerManager.state {
                case .idle:
                    Button(action: startWithTask) {
                        Label("Start", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)

                case .running:
                    Button(action: { timerManager.pause() }) {
                        Label("Pause", systemImage: "pause.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button(action: { timerManager.finish() }) {
                        Label("Finish", systemImage: "stop.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)

                case .paused:
                    Button(action: { timerManager.resume() }) {
                        Label("Resume", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)

                    Button(action: { timerManager.finish() }) {
                        Label("Finish", systemImage: "stop.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
            }

            Divider()

            // Launch at Login Toggle
            Toggle(isOn: $launchAtLogin) {
                Label("Launch at Login", systemImage: "sunrise")
            }
            .toggleStyle(.switch)
            .onChange(of: launchAtLogin) { _, newValue in
                do {
                    if newValue {
                        try SMAppService.mainApp.register()
                    } else {
                        try SMAppService.mainApp.unregister()
                    }
                } catch {
                    print("Failed to update launch at login: \(error)")
                    launchAtLogin = !newValue // revert on failure
                }
            }

            // Quit
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                Label("Quit", systemImage: "power")
            }
            .buttonStyle(.plain)
            .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 280)
    }

    private func startWithTask() {
        timerManager.currentTask = taskInput
        timerManager.start()
        taskInput = ""
    }
}

#Preview {
    MenuBarView(timerManager: TimerManager())
}
