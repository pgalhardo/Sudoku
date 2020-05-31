//
//  KeyboardView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 30/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import SwiftUI

struct KeyboardView: View {
	@State var _task = DispatchWorkItem { }
	
	@Binding var _isPaused: Bool
	@Binding var _displayAlert: Bool
	@Binding var _alertText: String
	
	@EnvironmentObject var _grid: Grid
	@EnvironmentObject var _settings: Settings
	
	var body: some View {
		VStack {
			optionsRow
			numbersRow
		}
			.blur(radius: _isPaused || exit() ? 5 : 0)
			.opacity(_isPaused || exit() ? 0.7 : 1)
			.disabled(_isPaused || exit())
			.animation(.spring())
	}
	
	var optionsRow: some View {
		HStack {
			Spacer()
			Button(
				action: {
				},
				label: {
					VStack {
						Image(systemName: "gobackward")
							.resizable()
							.frame(width: Screen.cellWidth / 2,
								   height: Screen.cellWidth / 2)
						Text("keyboard.undo")
							.font(.custom("CaviarDreams-Bold",
										  size: Screen.cellWidth / 2))
					}
						.foregroundColor(Colors.MatteBlack)
				}
			)
			Spacer()
			Button(
				action: {
					self.execute(value: 0, alertText: "alert.default.remove")
				},
				label: {
					VStack {
						Image(systemName: "xmark.circle")
							.resizable()
							.frame(width: Screen.cellWidth / 2,
								   height: Screen.cellWidth / 2)
							.foregroundColor(Colors.EraserPink)
						Text("keyboard.delete")
							.foregroundColor(Colors.MatteBlack)
							.font(.custom("CaviarDreams-Bold",
										  size: Screen.cellWidth / 2))
					}
				}
			)
			Spacer()
		}
			.padding(.top)
			.padding(.bottom)
	}
	
	var numbersRow: some View {
		HStack {
			ForEach(1 ..< 10) { i in
				if (!self._settings._hideUsed
					|| (self._grid.getNumberFrequency()[i - 1] < 9
						&& self._settings._hideUsed)) {
					Spacer()
					Button(
						action: {
							self.execute(value: i, alertText: "alert.default.overwrite")
						},
						label: {
							Text("\(i)")
								.foregroundColor(Colors.MatteBlack)
								.font(.custom("CaviarDreams-Bold",
											  size: Screen.cellWidth))
						}
					)
				}
			}
			Spacer()
		}
			.padding(.top)
			.padding(.bottom)
	}
	
	func execute(value: Int, alertText: String) {
		guard let active = self._grid.getActive()
		else { return }
		
		if self._grid.setValue(row: active[0],
							   col: active[1],
							   value: value) == false {
			displayError(alertText: alertText)
		} else {
			self._grid.objectWillChange.send()
		}
	}
	
	func displayError(alertText: String) {
		// setup delayed action
		self._task.cancel()
		self._task = DispatchWorkItem {
			self._displayAlert = false
		}
		
		// display error message
		self._alertText = alertText
		self._displayAlert = true
		DispatchQueue.main.asyncAfter(
			deadline: DispatchTime.now() + 2,
			execute: self._task
		)
		
		// haptic feedback
		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(.error)
	}
	
	func exit() -> Bool {
		return _grid.completion() == 100
	}
}
