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
		NavigationView {
			ScrollView {
				VStack(spacing: 0) {
					self.general
					self.timer
					self.fontSize
					//self.eraseBoard
					
					Spacer()
				}
			}
			.navigationBarTitle(Text("main.settings"))
			.navigationBarItems(leading:
				Button(
					action: {
						withAnimation(.easeIn) {
							self.viewRouter.setCurrentPage(page: Pages.home)
						}
					},
					label: {
						Image(systemName: "arrow.left")
							.resizable()
							.frame(width: Screen.cellWidth / 2,
								   height: Screen.cellWidth / 2)
						Text("main.back")
							.font(.custom("CaviarDreams-Bold", size: 15))
						
					}
				)
					.foregroundColor(Color(.label))
			)
		}
	}
	
	var general: some View {
		Section {
			VStack(alignment: .leading) {
				Toggle(isOn: $settings.highlightAreas) {
					Text("settings.areas")
						.font(.custom("CaviarDreams-Bold", size: 20))
				}
				
				Text("settings.areas.descript")
					.font(.custom("CaviarDreams-Bold", size: 12))
					.foregroundColor(Color(.systemGray))
			}
			
			VStack(alignment: .leading) {
				Toggle(isOn: $settings.highlightSimilar) {
					Text("settings.twins")
						.font(.custom("CaviarDreams-Bold", size: 20))
				}
				
				Text("settings.twins.descript")
					.font(.custom("CaviarDreams-Bold", size: 12))
					.foregroundColor(Color(.systemGray))
			}
			
			VStack(alignment: .leading) {
				Toggle(isOn: $settings.hideUsed) {
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
						.frame(width: Screen.cellWidth,
							   height: self.incrButtonHeight)
						.background(Colors.MatteBlack)
						.foregroundColor(.white)
						.cornerRadius(5)
				}
			)
			Spacer()
			Text(String(format: "%02.0f", self.settings.fontSize))
				.font(.custom("CaviarDreams-Bold", size: 20))
			Spacer()
			Button(
				action: {
					if self.canIncrement() {
						self.settings.fontSize += 1
					}
				},
				label: {
					Text("+")
						.font(.custom("CaviarDreams-Bold", size: 20))
						.frame(width: Screen.cellWidth,
							   height: self.incrButtonHeight)
						.background(Colors.MatteBlack)
						.foregroundColor(.white)
						.cornerRadius(5)
				}
			)
		}
		.padding(.top, 60)
		.padding(.leading)
		.padding(.trailing)
	}
	
	var eraseBoard: some View {
		HStack {
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
						.background(Colors.MatteBlack)
						.foregroundColor(.white)
						.cornerRadius(40)
				}
			)
		}
		.padding(.top, 60)
		.padding(.leading)
		.padding(.trailing)
	}
	
	func canIncrement() -> Bool {
		let factor: Float = 0.9
		let size: Float = self.settings.fontSize
		let max: Float = Float(Screen.cellWidth) * factor
		return size < max
	}
	
	func canDecrement() -> Bool {
		let factor: Float = 0.5
		let size: Float = self.settings.fontSize
		let min: Float = Float(Screen.cellWidth) * factor
		return size > min
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
	}
}
