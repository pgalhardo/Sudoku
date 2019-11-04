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
			
			HomeButtonView(label: "Novo jogo", imageName: "gamecontroller.fill", page: Pages.game)
			HomeButtonView(label: "Estatísticas", imageName: "chart.bar.fill", page: Pages.statistics)
			HomeButtonView(label: "Estratégias", imageName: "lightbulb.fill", page: Pages.strategies)
			HomeButtonView(label: "Definições", imageName: "gear", page: Pages.settings)
			
			Spacer()
		}
			.shadow(radius: 5)
	}
}

struct HomeButtonView: View {
	private var _label: String!
	private var _imageName: String!
	private var _page: Int!
	
	@EnvironmentObject var _viewRouter: ViewRouter
	
	init (label: String, imageName: String, page: Int) {
		_label = label
		_imageName = imageName
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
					Text(_label)
						.font(.custom("CaviarDreams-Bold", size: 20))
						.offset(x: Screen.width * 0.55 * 0.35)
				}
					.frame(width: Screen.width * 0.55,
						   height: 50,
						   alignment: .leading)
					.background(Colors.MatteBlack)
					.cornerRadius(40)
					.padding(.all, 7)
					.foregroundColor(.white)
					.shadow(radius: 20)
			}
		)
	}
}

struct Menu_Previews: PreviewProvider {
	static var previews: some View {
		MenuView()
	}
}
