//
//  MenuView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 27/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import SwiftUI

struct MenuView: View {
	@State private var _displayWarning: Bool = false
	
	@EnvironmentObject var _grid: Grid
	@EnvironmentObject var _viewRouter: ViewRouter
		
	var body: some View {
		ZStack {
			VStack {
				Spacer()
				
				Text("Sudoku")
					.font(.custom("CaviarDreams-Bold", size: 80))
					.foregroundColor(Colors.MatteBlack)
					.shadow(radius: 10)
				
				Group {
					if (activeBoard()) {
						ContinueButtonView()
					}
					PlayButtonView(_displayWarning: $_displayWarning)
						.modifier(DefaultButton())
					HomeButtonView(label: "main.stats",
								   imageName: "chart.bar.fill",
								   imageColor: Color.white,
								   page: Pages.statistics)
						.modifier(DefaultButton())
					HomeButtonView(label: "main.strategies",
								   imageName: "lightbulb.fill",
								   imageColor: Color.white,
								   page: Pages.strategies)
						.modifier(DefaultButton())
					HomeButtonView(label: "main.settings",
								   imageName: "gear",
								   imageColor: Color.white,
								   page: Pages.settings)
						.modifier(DefaultButton())
				}
					.opacity(_displayWarning ? 0 : 1)
				
				Spacer()
			}
				.shadow(radius: 5)
			
			VStack {
				Spacer()
				
				VStack {
					Spacer()
					
					Text("alert.progress.title")
						.font(.custom("CaviarDreams-Bold", size: 15))
						.lineLimit(nil)
						.padding(.leading)
						.padding(.trailing)
				
					Spacer()
					
					Text("alert.progress.continue")
						.font(.custom("CaviarDreams-Bold", size: 15))
						.padding(.leading)
						.padding(.trailing)
					
					HStack {
						Spacer()
						Button(
							action: {
								withAnimation {
									self._displayWarning = false
								}
							},
							label: {
								Image(systemName: "xmark.circle.fill")
									.foregroundColor(Color.red)
								Text("alert.progress.no")
									.font(.custom("CaviarDreams-Bold", size: 20))
							}
						)
						
						Spacer()
						Button(
							action: {
								withAnimation {
									UserDefaults.standard.set(nil,
															  forKey: "savedBoard")
									UserDefaults.standard.set(nil,
															  forKey: "time")
									self._grid.reset()
									self._grid.generate()
									self._viewRouter.setCurrentPage(page: Pages.game)
								}
							},
							label: {
								Image(systemName: "checkmark.circle.fill")
									.foregroundColor(Color.green)
								Text("alert.progress.yes")
									.font(.custom("CaviarDreams-Bold", size: 20))
							}
						)
						
						Spacer()
					}
					
					Spacer()
				}
					.frame(
						width: Screen.width * 0.65,
						height: Screen.height * 0.35
					)
					.background(Colors.MatteBlack)
					.foregroundColor(Color.white)
					.cornerRadius(40)
					.shadow(radius: 10)
					.blur(radius: _displayWarning ? 0 : 50)
					.opacity(_displayWarning ? 1 : 0)
					.animation(.spring())
					
				Spacer()
			}
				.padding(.top, Screen.height * 0.10)
		}
	}
	
	func activeBoard() -> Bool {
		let board = UserDefaults.standard.string(forKey: "savedBoard")
		return board != nil
	}
}

struct HomeButtonView: View {
	private var _label: String!
	private var _imageName: String!
	private var _imageColor: Color!
	private var _page: Int!
	
	@EnvironmentObject var _viewRouter: ViewRouter
	
	init (label: String, imageName: String, imageColor: Color, page: Int) {
		_label = label
		_imageName = imageName
		_imageColor = imageColor
		_page = page
	}
	
	var body: some View {
		Button(
			action: {
				withAnimation {
					self._viewRouter.setCurrentPage(page: self._page)
				}
			},
			label: {
				ZStack(alignment: .leading) {
					Image(systemName: _imageName)
						.position(x: Screen.width * 0.55 * 0.2, y: 25)
						.foregroundColor(_imageColor)
					Text(LocalizedStringKey(_label))
						.font(.custom("CaviarDreams-Bold", size: 20))
						.offset(x: Screen.width * 0.55 * 0.35)
				}
			}
		)
	}
}

struct ContinueButtonView: View {
	@EnvironmentObject var _grid: Grid
	@EnvironmentObject var _viewRouter: ViewRouter
		
	var body: some View {
		Button(
			action: {
				withAnimation {
					if let board = UserDefaults.standard.string(forKey: "savedBoard") {
						self._grid.load(puzzle: board)
					}
					self._viewRouter.setCurrentPage(page: Pages.game)
				}
			},
			label: {
				ZStack(alignment: .leading) {
					Image(systemName: "hourglass.bottomhalf.fill")
						.position(x: Screen.width * 0.55 * 0.2, y: 25)
					Text("main.resume")
						.font(.custom("CaviarDreams-Bold", size: 20))
						.offset(x: Screen.width * 0.55 * 0.35)
				}
			}
		)
			.frame(width: Screen.width * 0.55,
				   height: 50,
				   alignment: .leading)
			.background(Colors.LightBlue)
			.cornerRadius(40)
			.padding(.all, 7)
			.foregroundColor(Colors.MatteBlack)
			.shadow(radius: 20)
	}
}

struct PlayButtonView: View {
	@Binding var _displayWarning: Bool
	
	@EnvironmentObject var _grid: Grid
	@EnvironmentObject var _viewRouter: ViewRouter
		
	var body: some View {
		Button(
			action: {
				withAnimation {
					if (self.activeBoard()) {
						self._displayWarning = true
					}
					else {
						UserDefaults.standard.set(nil,
												  forKey: "savedBoard")
						UserDefaults.standard.set(nil,
												  forKey: "time")
						self._grid.reset()
						self._grid.generate()
						self._viewRouter.setCurrentPage(page: Pages.game)
					}
				}
			},
			label: {
				ZStack(alignment: .leading) {
					Image(systemName: "gamecontroller.fill")
						.position(x: Screen.width * 0.55 * 0.2, y: 25)
					Text("main.new")
						.font(.custom("CaviarDreams-Bold", size: 20))
						.offset(x: Screen.width * 0.55 * 0.35)
				}
			}
		)
	}
	
	func activeBoard() -> Bool {
		let board = UserDefaults.standard.string(forKey: "savedBoard")
		return board != nil
	}
}

struct DefaultButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: Screen.width * 0.55,
				   height: 50,
				   alignment: .leading)
			.background(Colors.MatteBlack)
			.cornerRadius(40)
			.padding(.all, 7)
			.foregroundColor(.white)
			.shadow(radius: 20)
    }
}
