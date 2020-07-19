//
//  SettingsView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 02/11/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
	
	@EnvironmentObject var settings: Settings
	@EnvironmentObject var viewRouter: ViewRouter
	
	private let incrButtonHeight: CGFloat = Screen.cellWidth / 2
	
	var body: some View {
		ScrollView {
			VStack(spacing: 0) {
				GenericTopBarView(title: "main.settings",
								  destination: Pages.home)
				
				self.general
				self.timer
				self.fontSize
				self.eraseBoard
				
				Spacer()
			}
		}
	}
		
	var general: some View {
		Section {
			VStack(alignment: .leading) {
				Toggle(isOn: $settings.highlightAreas) {
					Image(systemName: "square.stack.fill")
					Text("settings.areas")
						.font(.custom("CaviarDreams-Bold", size: 20))
				}
				
				Text("settings.areas.descript")
					.font(.custom("CaviarDreams-Bold", size: 12))
					.foregroundColor(Color(.systemGray))
			}
			
			VStack(alignment: .leading) {
				Toggle(isOn: $settings.highlightSimilar) {
					Image(systemName: "square.fill.on.square.fill")
					Text("settings.twins")
						.font(.custom("CaviarDreams-Bold", size: 20))
				}
				
				Text("settings.twins.descript")
					.font(.custom("CaviarDreams-Bold", size: 12))
					.foregroundColor(Color(.systemGray))
			}
			
			VStack(alignment: .leading) {
				Toggle(isOn: $settings.hideUsed) {
					Image(systemName: "eye.slash.fill")
					Text("settings.used")
						.font(.custom("CaviarDreams-Bold", size: 20))
				}
				
				Text("settings.used.descript")
					.font(.custom("CaviarDreams-Bold", size: 12))
					.foregroundColor(Color(.systemGray))
			}
		}
		.padding(.top)
		.padding(.leading)
		.padding(.trailing)
	}
	
	var timer: some View {
		VStack(alignment: .leading) {
			Toggle(isOn: $settings.enableTimer) {
				Image(systemName: "timer")
				Text("settings.timer")
					.font(.custom("CaviarDreams-Bold", size: 20))
			}
		}
		.padding(.top, 60)
		.padding(.leading)
		.padding(.trailing)
	}
	
	var fontSize: some View {
		HStack {
			Image(systemName: "textformat.size")
			Text("settings.text.size")
				.font(.custom("CaviarDreams-Bold", size: 20))
			
			Spacer()
			Button(
				action: {
					if self.canDecrement() {
						self.settings.fontSize -= 1
					}
				},
				label: {
					Text("-")
						.font(.custom("CaviarDreams-Bold", size: 20))
				}
			)
			.frame(width: 40,
				   height: 40)
			.background(Color(UIColor.label))
			.foregroundColor(Color(UIColor.systemBackground))
			.cornerRadius(40)
			.padding(.all, 7)
			.shadow(radius: 20)
			
			Text(String(format: "%02.0f", self.settings.fontSize))
				.font(.custom("CaviarDreams-Bold", size: 20))
				.padding(.trailing)
				.padding(.leading)
			Button(
				action: {
					if self.canIncrement() {
						self.settings.fontSize += 1
					}
				},
				label: {
					Text("+")
						.font(.custom("CaviarDreams-Bold", size: 20))
				}
			)
			.frame(width: 40,
				   height: 40)
			.background(Color(UIColor.label))
			.foregroundColor(Color(UIColor.systemBackground))
			.cornerRadius(40)
			.padding(.all, 7)
			.shadow(radius: 20)
		}
		.padding(.top, 60)
		.padding(.leading)
		.padding(.trailing)
	}
	
	var eraseBoard: some View {
		HStack {
			Image(systemName: "trash.circle.fill")
			Text("Erase current board")
				.font(.custom("CaviarDreams-Bold", size: 20))
			
			Spacer()
			Button(
				action: {
					UserDefaults.standard.set(nil,
											  forKey: "savedBoard")
					UserDefaults.standard.set(nil,
											  forKey: "time")
				},
				label: {
					Text("Erase")
						.frame(width: 100,
							   height: 50)
						.font(.custom("CaviarDreams-Bold", size: 20))
						.background(Color(UIColor.label))
						.foregroundColor(Color(UIColor.systemBackground))
						.cornerRadius(40)
				}
			)
			.shadow(radius: 20)
		}
		.padding(.top, 60)
		.padding(.leading)
		.padding(.trailing)
	}
	
	func canIncrement() -> Bool {
		let factor: Float = 0.9
		let size: Float = self.settings.fontSize
		let fontmax: Float = min(Float(Screen.cellWidth), 45) * factor
		return size < fontmax
	}
	
	func canDecrement() -> Bool {
		let factor: Float = 0.5
		let size: Float = self.settings.fontSize
		let fontmin: Float = min(Float(Screen.cellWidth), 45) * factor
		return size > fontmin
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
	}
}
