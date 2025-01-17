//
//  ContentView.swift
//  TimerApp
//
//  Created by Artem Kyselov on 17.01.2025.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
  @State private var audioPlayer: AVAudioPlayer?
  @State private var timeRemaining: TimeInterval = 30 * 60 // Default to 30 minutes
  @State private var isRunning: Bool = false
  @State private var timer: Timer? = nil
  @State private var pickerValue: TimeInterval = 30 * 60 // Sync with default time

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
  }

  private func startTimer() {
    if timeRemaining <= 0 {
      timeRemaining = pickerValue
    }
    isRunning = true
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      if timeRemaining > 0 {
        timeRemaining -= 1
      } else {
        timer?.invalidate()
        timer = nil
        isRunning = false
        playAlertSound()
      }
    }
  }

  private func pauseTimer() {
    timer?.invalidate()
    timer = nil
    isRunning = false
  }

    private func playAlertSound() {
      guard let soundURL = Bundle.main.url(forResource: "alertSound", withExtension: "wav") else {
        print("Sound file not found")
        return
      }

      do {
        audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
        audioPlayer?.play()
      } catch {
        print("Error playing sound: \(error.localizedDescription)")
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
