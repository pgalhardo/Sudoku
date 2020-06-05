//
//  StatisticsView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 02/11/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import SwiftUI

struct StatisticsView: View {
	@EnvironmentObject var viewRouter: ViewRouter
	
	var body: some View {
		NavigationView {
			ScrollView {
				VStack(spacing: 0) {
					Text("Soon...")
						.font(.custom("CaviarDreams-Bold", size: 15))
					
					Spacer()
				}
			}
			.navigationBarTitle(Text("main.stats")) // TODO custom font
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
}

struct StatisticsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
	}
}
