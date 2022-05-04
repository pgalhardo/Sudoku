//
//  TimerView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 31/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import SwiftUI

struct TimerView : View {
	
	@EnvironmentObject var grid: Grid
	@EnvironmentObject var pauseHolder: PauseHolder
	@EnvironmentObject var timerHolder: TimerHolder
	
	private let labelSize: CGFloat = Screen.cellWidth / 2
	
    var body: some View {
		Text(String(format: "%@%02d:%02d", arguments: [
                        self.hours(), self.minutes(),  self.sec()
        ]))
			.font(.custom("CaviarDreams-Bold", size: min(Screen.cellWidth / 3, 15)))
    }

	func sec() -> Int {
		return self.timerHolder.count % 60
	}

	func minutes () -> Int {
		return (self.timerHolder.count / 60) % 60
	}

	func hours() -> String {
		if self.timerHolder.count >= 3600 {
			return String(format: "%02d:", (self.timerHolder.count / 3600))
		}
		return String()
	}
}

class TimerHolder : ObservableObject {
	private var timer : Timer!
	
	@Published var count = 0
	
	init() {
		if UserDefaults.standard.object(forKey: "time") != nil {
			let value: Int = UserDefaults.standard.integer(forKey: "time")
			self.count = value
		}
        start()
	}
	
	func start() -> Void {
		self.timer?.invalidate()
		self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
			_ in
			self.count += 1
		}
	}
	
	func stop() -> Void {
		self.timer?.invalidate()
		self.storeCounterValue()
	}
	
	func reset() -> Void {
		self.count = 0
	}
	
	func storeCounterValue() -> Void {
		UserDefaults.standard.set(self.count, forKey: "time")
	}
}

class PauseHolder : ObservableObject {
	
	@Published var paused: Bool = false
	
	func toggle() -> Void {
		self.paused.toggle()
	}
	
	func isPaused() -> Bool {
		return paused
	}
}
