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
	@State private var task: DispatchWorkItem = DispatchWorkItem { }

	@Binding var displayAlert: Bool
	@Binding var alertText: String

	@EnvironmentObject var grid: Grid
	@EnvironmentObject var settings: Settings
	@EnvironmentObject var pauseHolder: PauseHolder
	
	var body: some View {
		VStack {
			optionsRow
			numbersRow
		}
			.blur(radius: self.blurRadius())
			.opacity(self.opacity())
			.disabled(self.disabled())
			.animation(.spring())
	}

	let buttonSize: CGFloat = Screen.cellWidth / 2

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
							.frame(width: buttonSize,
								   height: buttonSize)
						Text("keyboard.undo")
							.font(.custom("CaviarDreams-Bold",
										  size: buttonSize))
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
							.frame(width: buttonSize,
								   height: buttonSize)
							.foregroundColor(Colors.EraserPink)
						Text("keyboard.delete")
							.foregroundColor(Colors.MatteBlack)
							.font(.custom("CaviarDreams-Bold",
										  size: buttonSize))
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
			ForEach(1 ..< 10) { number in
				if self.displayNumber(number: number) {
					Spacer()
					Button(
						action: {
							self.execute(value: number,
										 alertText: "alert.default.overwrite")
						},
						label: {
							Text("\(number)")
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
		guard let active: [Int] = self.grid.getActive()
			else {
				return
		}
		
		if self.grid.setValue(row: active[0],
							  col: active[1],
							  value: value) == false {
			displayError(alertText: alertText)
		} else {
			self.grid.objectWillChange.send()
		}
	}

	func displayError(alertText: String) {
		// setup delayed action
		self.task.cancel()
		self.task = DispatchWorkItem {
			self.displayAlert = false
		}

		// display error message
		self.alertText = alertText
		self.displayAlert = true
		DispatchQueue.main.asyncAfter(
			deadline: DispatchTime.now() + 2,
			execute: self.task
		)

		// haptic feedback
		let generator: UINotificationFeedbackGenerator
			= UINotificationFeedbackGenerator()
		generator.notificationOccurred(.error)
	}

	func displayNumber(number: Int) -> Bool {
		return !self.settings.hideUsed
				|| (self.grid.getNumberFrequency()[number - 1] < 9
					&& self.settings.hideUsed)
	}
	
	func isPaused() -> Bool {
		return self.pauseHolder.isPaused()
	}
	
	func blurRadius() -> CGFloat {
		return self.isPaused() || self.grid.full() ? 5 : 0
	}
	
	func opacity() -> Double {
		return self.isPaused() || self.grid.full() ? 0.7 : 1
	}
	
	func disabled() -> Bool {
		return self.isPaused() || self.grid.full()
	}
}
