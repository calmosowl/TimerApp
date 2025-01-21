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
    requestNotificationPermission()
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }

  /// Configures the audio session for playback.
  private func configureAudioSession() {
    do {
      let audioSession = AVAudioSession.sharedInstance()
      try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
      try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    } catch {
      print("Failed to configure audio session: \(error.localizedDescription)")
    }
  }

  /// Requests permission for sending notifications.
  private func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if let error = error {
        print("Error requesting notification permission: \(error.localizedDescription)")
      } else {
        print("Notification permission granted: \(granted)")
      }
    }
  }
}
