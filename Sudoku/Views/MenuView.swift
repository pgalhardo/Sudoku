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
		VStack(alignment: .center) {
			Text("Sudoku")
				.font(.custom("CaviarDreams-Bold", size: 80))
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
							.padding(.leading, -6)
							.padding(.trailing, 7)
						Text("Novo jogo")
							.fontWeight(.bold)
							.font(.custom("CaviarDreams-Bold", size: 20))
					}
						.frame(width: Screen.width * 0.6,
							   height: 50)
						.background(Colors.MatteBlack)
						.cornerRadius(40)
						.foregroundColor(.white)
						.shadow(radius: 20)
				}
			)
			
			Button(
				action: {
					withAnimation(.easeIn) {
						self._viewRouter.setCurrentPage(page: Pages.statistics)
					}
				},
				label: {
					HStack {
						Image(systemName: "chart.bar.fill")
							.padding(.leading, 4)
						Text("Estatísticas")
							.fontWeight(.bold)
							.font(.custom("CaviarDreams-Bold", size: 20))
							.padding(.leading, 5)
					}
						.frame(width: Screen.width * 0.6,
							   height: 50)
						.background(Colors.MatteBlack)
						.cornerRadius(40)
						.foregroundColor(.white)
						.shadow(radius: 20)
				}
			)
			
			Button(
				action: {
					withAnimation {
						self._viewRouter.setCurrentPage(page: Pages.settings)
					}
				},
				label: {
					HStack {
						Image(systemName: "gear")
							.padding(.leading, -1)
						Text("Definições")
							.fontWeight(.bold)
							.font(.custom("CaviarDreams-Bold", size: 20))
							.padding(.leading, 5)
							.padding(.trailing, 5)
					}
						.frame(width: Screen.width * 0.6,
							   height: 50)
						.background(Colors.MatteBlack)
						.cornerRadius(40)
						.foregroundColor(.white)
						.shadow(radius: 20)
					
				}
			)
		}
			.shadow(radius: 5)
			.animation(Animation.easeOut(duration: 0.6).delay(0.1))
	}
}

struct Menu_Previews: PreviewProvider {
	static var previews: some View {
		MenuView().environmentObject(ViewRouter())
	}
}
