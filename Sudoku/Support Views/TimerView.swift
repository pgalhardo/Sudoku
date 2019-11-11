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
	@State private var _time: Int = 0

	@EnvironmentObject var _grid: Grid
	
	init() {
		_isPaused = false
	}
	
    let _timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
		Text(String(format: "%@%02d:%02d", arguments: [self.hours(),
													   self.min(),
													   self.sec()]))
			.font(.custom("CaviarDreams-Bold", size: Screen.cellWidth / 2))
            .onReceive(_timer) { _ in
				if (!_isPaused && !self.exit()) {
					self._time += 1
				}
            }
    }
	
	func sec() -> Int {
		return self._time % 60
	}
	
	func min () -> Int {
		return (self._time / 60) % 60
	}
	
	func hours() -> String {
		if self._time >= 3600 {
			return String(format: "%02d:", (self._time / 3600))
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
