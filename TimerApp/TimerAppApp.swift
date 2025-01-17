//
//  TimerAppApp.swift
//  TimerApp
//
//  Created by Artem Kyselov on 17.01.2025.
//

import SwiftUI
import AVFoundation

@main
struct TimerAppApp: App {
    init() {
        configureAudioSession()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
        }
    }
}
