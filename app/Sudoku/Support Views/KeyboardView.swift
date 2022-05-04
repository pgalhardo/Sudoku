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
	
	@Binding var alertText: String
	@Binding var displayAlert: Bool

	@EnvironmentObject var grid: Grid
	@EnvironmentObject var settings: Settings
	@EnvironmentObject var pauseHolder: PauseHolder
	
	@State private var task: DispatchWorkItem = DispatchWorkItem { }
	
	var body: some View {
		VStack {
			optionsRow
			numbersRow
		}
			.blur(radius: self.blurRadius())
			.opacity(self.opacity())
			.disabled(self.disabled())
			.animation(.spring())
			.frame(maxWidth: 500.0)
	}

	let buttonSize: CGFloat = min(Screen.cellWidth / 2, 22.5)

	var optionsRow: some View {
		HStack {
			Spacer()
			
			// Undo Button
			Button(
				action: {
					// TODO
				},
				label: {
					VStack {
						Image(systemName: "gobackward")
							.frame(width: buttonSize)
							//.foregroundColor(Color(.systemGray))
							.foregroundColor(Colors.Golden)
						Text("keyboard.undo")
							.foregroundColor(Color(.label))
							.font(.custom("CaviarDreams-Bold",
										  size: buttonSize))
					}
				}
			)
			Spacer()
			
			// Delete Button
			Button(
				action: {
					self.insert(value: 0, alertText: "alert.default.remove")
				},
				label: {
					VStack {
						Image(systemName: "xmark.circle")
							.frame(width: buttonSize)
							//.foregroundColor(Color(.systemGray))
							.foregroundColor(Colors.Golden)
						Text("keyboard.delete")
							.foregroundColor(Color(.label))
							.font(.custom("CaviarDreams-Bold",
										  size: buttonSize))
					}
				}
			)
			Spacer()
			
			// Notes Button
			Button(
				action: {
					// TODO
				},
				label: {
					VStack {
						Image(systemName: "square.and.pencil")
							.frame(width: buttonSize)
							.foregroundColor(Colors.Golden)
							//.foregroundColor(Color(.systemGray))
						Text("keyboard.notes")
							.foregroundColor(Color(.label))
							.font(.custom("CaviarDreams-Bold",
										  size: buttonSize))
					}
				}
			)
			Spacer()
			
			// Sugestion Button
			Button(
				action: {
					// TODO
				},
				label: {
					VStack {
						Image(systemName: "lightbulb")
							.frame(width: buttonSize)
							.foregroundColor(Colors.Golden)
							//.foregroundColor(Color(.systemGray))
						Text("keyboard.sugestion")
							.foregroundColor(Color(.label))
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
							self.insert(value: number,
										 alertText: "alert.default.overwrite")
						},
						label: {
							Text("\(number)")
								.foregroundColor(Color(.label))
								.font(.custom("CaviarDreams-Bold",
											  size: min(Screen.cellWidth, 45)))
						}
					)
				}
			}
			Spacer()
		}
			.padding(.top)
			.padding(.bottom)
	}

	func insert(value: Int, alertText: String) -> Void {
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

	func displayError(alertText: String) -> Void {
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
