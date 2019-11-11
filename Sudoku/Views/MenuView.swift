//
//  MenuView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 27/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import SwiftUI

struct MenuView: View {
	@EnvironmentObject var _viewRouter: ViewRouter
		
	var body: some View {
		VStack {
			Spacer()
			
			Text("Sudoku")
				.font(.custom("CaviarDreams-Bold", size: 80))
				.foregroundColor(Colors.MatteBlack)
				.shadow(radius: 10)
			
			if (enableContinue()) {
				ContinueButtonView()
					.modifier(ContinueButton())
			}
			PlayButtonView()
				.modifier(DefaultButton())
			HomeButtonView(label: "Estatísticas",
						   imageName: "chart.bar.fill",
						   imageColor: Color.white,
						   page: Pages.statistics)
				.modifier(DefaultButton())
			HomeButtonView(label: "Estratégias",
						   imageName: "lightbulb.fill",
						   imageColor: Color.white,
						   page: Pages.strategies)
				.modifier(DefaultButton())
			HomeButtonView(label: "Definições",
						   imageName: "gear",
						   imageColor: Color.white,
						   page: Pages.settings)
				.modifier(DefaultButton())
			
			Spacer()
		}
			.shadow(radius: 5)
	}
	
	func enableContinue() -> Bool {
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
					Text(_label)
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
					Text("Continuar")
						.font(.custom("CaviarDreams-Bold", size: 20))
						.offset(x: Screen.width * 0.55 * 0.35)
				}
			}
		)
	}
}

struct PlayButtonView: View {
	@EnvironmentObject var _grid: Grid
	@EnvironmentObject var _viewRouter: ViewRouter
		
	var body: some View {
		Button(
			action: {
				withAnimation {
					self._grid.load(puzzle: Puzzles.hard)
					self._viewRouter.setCurrentPage(page: Pages.game)
				}
			},
			label: {
				ZStack(alignment: .leading) {
					Image(systemName: "gamecontroller.fill")
						.position(x: Screen.width * 0.55 * 0.2, y: 25)
					Text("Novo jogo")
						.font(.custom("CaviarDreams-Bold", size: 20))
						.offset(x: Screen.width * 0.55 * 0.35)
				}
			}
		)
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

struct ContinueButton: ViewModifier {
    func body(content: Content) -> some View {
        content
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
