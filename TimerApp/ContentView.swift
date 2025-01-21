//
//  ContentView.swift
//  TimerApp
//
//  Created by Artem Kyselov on 17.01.2025.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
  @State private var pickerValue: TimeInterval = 30 * 60 // Default: 30 minutes
  @State private var timeRemaining: TimeInterval = 30 * 60
  @State private var isRunning: Bool = false
  @State private var endDate: Date? = nil
  @State private var timer: Timer? = nil

  var body: some View {
    VStack(spacing: 20) {

      // Countdown display
      Text(formatTime(timeRemaining))
        .font(.system(size: 68, weight: .bold, design: .monospaced))
        .fontWeight(.regular)
        .foregroundColor(Color(hue: 1.0, saturation: 0.154, brightness: 0.168))
        .padding()

      // Time Picker
      Picker("", selection: $pickerValue) {
        ForEach(1..<121, id: \.self) { value in
          Text("\(value) min").tag(TimeInterval(value * 60))
        }
      }
      .labelsHidden()
      .pickerStyle(.wheel)
      .onChange(of: pickerValue) { newValue in
        if !isRunning {
          timeRemaining = newValue
        }
      }

      // Start/Pause Button
      Button(action: {
        if isRunning {
          pauseTimer()
        } else {
          startTimer()
        }
      }) {
        Text(isRunning ? "Pause" : "Start")
          .font(.system(size: 24, weight: .bold))
          .foregroundColor(.white)
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color(hue: 1.0, saturation: 0.154, brightness: 0.168))
          .cornerRadius(12)
      }
    }
    .padding()
    .background(Color.white.edgesIgnoringSafeArea(.all))
    .onDisappear {
      pauseTimer()
    }
  }

  private func startTimer() {
    // Calculate the end date
    endDate = Date().addingTimeInterval(pickerValue)
    isRunning = true

    // Schedule local notification
    scheduleNotification()

    // Start UI update timer
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      updateRemainingTime()
    }
  }

  private func pauseTimer() {
    timer?.invalidate()
    timer = nil
    isRunning = false
    endDate = nil

    // Cancel pending notifications
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
  }

  private func updateRemainingTime() {
    guard let endDate = endDate else { return }

    let now = Date()
    if now >= endDate {
      timeRemaining = 0
      timer?.invalidate()
      timer = nil
      isRunning = false
    } else {
      timeRemaining = endDate.timeIntervalSince(now)
    }
  }

  private func scheduleNotification() {
      guard let endDate = endDate else { return }

      let content = UNMutableNotificationContent()
      content.title = "Timer Finished"
      content.body = "Your timer has ended."
      
      // Custom sound
      if let soundURL = Bundle.main.url(forResource: "handpan-converted", withExtension: "wav") {
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: soundURL.lastPathComponent))
      } else {
        content.sound = UNNotificationSound.default
      }

      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: endDate.timeIntervalSinceNow, repeats: false)
      let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

      UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
          print("Error scheduling notification: \(error.localizedDescription)")
        }
      }
  }

  private func formatTime(_ seconds: TimeInterval) -> String {
    let minutes = Int(seconds) / 60
    let seconds = Int(seconds) % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
