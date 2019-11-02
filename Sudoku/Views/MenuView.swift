//
//  MenuView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 27/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import SwiftUI

struct MenuView: View {
	let _gameView: GameView!
	
	@EnvironmentObject var _viewRouter: ViewRouter
	
	init(gameView: GameView) {
		_gameView = gameView
	}
	
	var body: some View {
		VStack(alignment: .center) {
			Text("Sudoku")
				.font(.custom("Shevana", size: 120))
				.foregroundColor(.black)
				.shadow(radius: 10)

			Button(
				action: {
					withAnimation(.easeIn) {
						self._viewRouter.setCurrentPage(page: Pages.game)
					}
				},
				label: {
					HStack {
						Image(systemName: "gamecontroller.fill")
						Text("Jogar")
							.fontWeight(.bold)
							.font(.title)
					}
					.padding()
					.background(Color(red: 31 / 255, green: 31 / 255, blue: 36 / 255))
					.cornerRadius(40)
					.foregroundColor(.white)
					.shadow(radius: 20)
				}
			)
		}
		.shadow(radius: 5)
	}
}

struct Menu_Previews: PreviewProvider {
	static var previews: some View {
		MenuView(gameView: GameView(grid: Grid())).environmentObject(ViewRouter())
	}
}
