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
					.background(Colors.MatteBlack)
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
		MenuView().environmentObject(ViewRouter())
	}
}
