//
//  MenuView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 27/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import SwiftUI

struct MenuView: View {
	@State private var displayWarning: Bool = false
	@State private var generating: Bool = false
	
	@EnvironmentObject var grid: Grid
	@EnvironmentObject var viewRouter: ViewRouter
	
	private let popupWidth: CGFloat = Screen.width * 0.65
	private let popupHeight: CGFloat = Screen.height * 0.35
	private let popupPadding: CGFloat = Screen.height * 0.10
	
	var body: some View {
		ZStack {
			VStack {
				Spacer()
				
				Text("Sudoku")
					.font(.custom("CaviarDreams-Bold", size: 80))
					.foregroundColor(Colors.MatteBlack)
					.shadow(radius: 10)
				
				Group {
					if activeBoard() {
						ContinueButtonView()
					}
					PlayButtonView(displayWarning: $displayWarning,
								   generating: $generating)
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
				.opacity(self.groupOpacity())
				
				Spacer()
			}
			.shadow(radius: 5)
			
			VStack {
				Spacer()
				
				ZStack {
					VStack {
						Spacer()
						
						Group {
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
											self.displayWarning = false
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
											self.generating = true
											self.execute()
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
						}
						.opacity(controlsOpacity())
						.animation(.spring())
						
						Spacer()
					}
					.frame(
						width: popupWidth,
						height: popupHeight
					)
						.background(Colors.MatteBlack)
						.foregroundColor(Color.white)
						.cornerRadius(40)
						.shadow(radius: 10)
						.blur(radius: popupBlur())
						.opacity(popupOpacity())
						.animation(.spring())
					
					
					ActivityIndicator()
						.frame(width: 200, height: 200)
						.foregroundColor(spinnerColor())
						.opacity(spinnerOpacity())
				}
				Spacer()
			}
			.padding(.top, popupPadding)
		}
	}
	
	func activeBoard() -> Bool {
		return UserDefaults.standard.string(forKey: "savedBoard") != nil
	}
	
	func groupOpacity() -> Double {
		return self.displayWarning || self.generating ? 0 : 1
	}
	
	func popupOpacity() -> Double {
		return self.displayWarning ? 1 : 0
	}
	
	func popupBlur() -> CGFloat {
		return self.displayWarning ? 0 : 50
	}
	
	func controlsOpacity() -> Double {
		return self.generating ? 0 : 1
	}
	
	func spinnerOpacity() -> Double {
		return self.generating ? 1 : 0
	}
	
	func spinnerColor() -> Color {
		return self.displayWarning ? Colors.LightBlue : Colors.MatteBlack
	}
	
	func execute() -> Void {
		// setup async action
		let task: DispatchWorkItem = DispatchWorkItem {
			self.grid.reset()
			self.grid.generate()
			self.generating = false
			self.viewRouter.setCurrentPage(page: Pages.game)
		}
		
		// execute
		DispatchQueue.main.asyncAfter(
			deadline: DispatchTime.now() + 2,
			execute: task
		)
	}
}

struct HomeButtonView: View {
	private let label: String!
	private let imageName: String!
	private let imageColor: Color!
	private let page: Int!
	
	@EnvironmentObject var viewRouter: ViewRouter
	
	init (label: String, imageName: String, imageColor: Color, page: Int) {
		self.label = label
		self.imageName = imageName
		self.imageColor = imageColor
		self.page = page
	}
	
	private let labelOffset: CGFloat = Screen.width * 0.55 * 0.35
	private let iconPosition: [CGFloat] = [Screen.width * 0.55 * 0.2, 25]
	
	var body: some View {
		Button(
			action: {
				withAnimation {
					self.viewRouter.setCurrentPage(page: self.page)
				}
		},
			label: {
				ZStack(alignment: .leading) {
					Image(systemName: self.imageName)
						.position(x: self.iconPosition[0],
								  y: self.iconPosition[1])
						.foregroundColor(self.imageColor)
					Text(LocalizedStringKey(self.label))
						.font(.custom("CaviarDreams-Bold", size: 20))
						.offset(x: self.labelOffset)
				}
		}
		)
	}
}

struct ContinueButtonView: View {
	@EnvironmentObject var grid: Grid
	@EnvironmentObject var viewRouter: ViewRouter
	
	private let labelOffset: CGFloat = Screen.width * 0.55 * 0.35
	private let iconPosition: [CGFloat] = [Screen.width * 0.55 * 0.2, 25]
	private let frameSize: [CGFloat] = [Screen.width * 0.55, 50]
	
	var body: some View {
		Button(
			action: {
				withAnimation {
					if let board: String = UserDefaults.standard.string(forKey: "savedBoard") {
						self.grid.reset()
						self.grid.load(puzzle: board)
						self.viewRouter.setCurrentPage(page: Pages.game)
					}
				}
		},
			label: {
				ZStack(alignment: .leading) {
					Image(systemName: "hourglass.bottomhalf.fill")
						.position(x: self.iconPosition[0],
								  y: self.iconPosition[1])
					Text("main.resume")
						.font(.custom("CaviarDreams-Bold", size: 20))
						.offset(x: self.labelOffset)
				}
		}
		)
			.frame(width: self.frameSize[0],
				   height: self.frameSize[1],
				   alignment: .leading)
			.background(Colors.LightBlue)
			.cornerRadius(40)
			.padding(.all, 7)
			.foregroundColor(Colors.MatteBlack)
			.shadow(radius: 20)
	}
}

struct PlayButtonView: View {
	@Binding var displayWarning: Bool
	@Binding var generating: Bool
	
	@EnvironmentObject var grid: Grid
	@EnvironmentObject var viewRouter: ViewRouter
	
	private let labelOffset: CGFloat = Screen.width * 0.55 * 0.35
	private let iconPosition: [CGFloat] = [Screen.width * 0.55 * 0.2, 25]
	
	var body: some View {
		Button(
			action: {
				withAnimation {
					if self.activeBoard() {
						self.displayWarning = true
					} else {
						UserDefaults.standard.set(nil,
												  forKey: "savedBoard")
						UserDefaults.standard.set(nil,
												  forKey: "time")
						self.generating = true
						self.execute()
					}
				}
		},
			label: {
				ZStack(alignment: .leading) {
					Image(systemName: "gamecontroller.fill")
						.position(x: self.iconPosition[0],
								  y: self.iconPosition[1])
					Text("main.new")
						.font(.custom("CaviarDreams-Bold", size: 20))
						.offset(x: self.labelOffset)
				}
		}
		)
	}
	
	func activeBoard() -> Bool {
		return UserDefaults.standard.string(forKey: "savedBoard") != nil
	}
	
	func execute() -> Void {
		// setup async action
		let task: DispatchWorkItem = DispatchWorkItem {
			self.grid.reset()
			self.grid.generate()
			self.generating = false
			self.viewRouter.setCurrentPage(page: Pages.game)
		}
		
		// execute
		DispatchQueue.main.asyncAfter(
			deadline: DispatchTime.now() + 2,
			execute: task
		)
	}
}

struct DefaultButton: ViewModifier {
	private let buttonWidth: CGFloat = Screen.width * 0.55
	
	func body(content: Content) -> some View {
		content
			.frame(width: buttonWidth,
				   height: 50,
				   alignment: .leading)
			.background(Colors.MatteBlack)
			.cornerRadius(40)
			.padding(.all, 7)
			.foregroundColor(.white)
			.shadow(radius: 20)
	}
}

struct ActivityIndicator: View {
	
	@State private var isAnimating: Bool = false
	
	var body: some View {
		GeometryReader { (geometry: GeometryProxy) in
			ForEach(0 ..< 5) { index in
				Group {
					Circle()
						.frame(width: geometry.size.width / 5,
							   height: geometry.size.height / 5)
						.scaleEffect(self.scaleEffect(index: index))
						.offset(y: self.offset(geometry: geometry))
				}
				.frame(width: geometry.size.width,
					   height: geometry.size.height)
					.rotationEffect(self.rotation())
				.animation(Animation
					.timingCurve(0.5,
								 0.15 + Double(index) / 5,
								 0.25,
								 1,
								 duration: 1.5)
					.repeatForever(autoreverses: false)
				)
			}
		}
		.aspectRatio(1, contentMode: .fit)
		.onAppear {
			self.isAnimating = true
		}
	}
	
	func scaleEffect(index: Int) -> CGFloat {
		let animatedEffect: CGFloat = 1 - CGFloat(index) / 5
		let frozenEffect: CGFloat = 0.2 + CGFloat(index) / 5
		return !self.isAnimating ? animatedEffect : frozenEffect
	}
	
	func offset(geometry: GeometryProxy) -> CGFloat {
		return geometry.size.width / 10 - geometry.size.height / 2
	}
	
	func rotation() -> Angle {
		return !self.isAnimating ? .degrees(0) : .degrees(360)
	}
}
