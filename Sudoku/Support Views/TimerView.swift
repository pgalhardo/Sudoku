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
	@State var time: Int
	@Binding var isPaused: Bool

	@EnvironmentObject var grid: Grid

    private let timer = Timer.publish(every: 1,
									  on: .main,
									  in: .common).autoconnect()
	
	private let labelSize: CGFloat = Screen.cellWidth / 2

	init(isPaused: Binding<Bool>) {
		_isPaused = isPaused

		if UserDefaults.standard.object(forKey: "time") != nil {
			_time = State(initialValue: UserDefaults.standard.integer(forKey: "time"))
		} else {
			_time = State(initialValue: 0)
		}
	}

    var body: some View {
		Text(String(format: "%@%02d:%02d", arguments: [self.hours(),
													   self.min(),
													   self.sec()]))
			.font(.custom("CaviarDreams-Bold", size: self.labelSize))
			.onReceive(self.timer) { _ in
				if !self.isPaused && !self.exit() {
					self.time += 1
					UserDefaults.standard.set(self.time, forKey: "time")
				}
            }
    }

	func sec() -> Int {
		return self.time % 60
	}

	func min () -> Int {
		return (self.time / 60) % 60
	}

	func hours() -> String {
		if self.time >= 3600 {
			return String(format: "%02d:", (self.time / 3600))
		}
		return String("")
	}

	func exit() -> Bool {
		return grid.full()
	}
}
