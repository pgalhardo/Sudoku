//
//  TimerView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 31/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import SwiftUI

private var _isPaused: Bool = false

struct TimerView : View {
	@State private var _hour: Int = 0
	@State private var _min: Int = 0
	@State private var _sec: Int = 0

	@EnvironmentObject var _grid: Grid
	
	init() {
		_isPaused = false
	}
	
    let _timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
		Text(String(format: "%@%02d:%02d", arguments: [self.hours(),
													   self._min,
													   self._sec]))
			.font(.custom("CaviarDreams-Bold", size: Screen.cellWidth / 2))
            .onReceive(_timer) { _ in
				if (!_isPaused && !self.exit()) {
					self._sec += 1
					if self._sec == 60 {
						self._min += 1
						self._sec = 0
					}
					
					if self._min == 60 {
						self._hour += 1
						self._min = 0
					}
				}
            }
    }
	
	func hours() -> String {
		if self._hour != 0 {
			return String(format: "%02d:", arguments: [self._hour])
		}
		return String("")
	}
	
	func toggleTimer() {
		_isPaused.toggle()
	}
	
	func exit() -> Bool {
		return _grid.completion() == 100
	}
}


