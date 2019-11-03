//
//  SettingsView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 02/11/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
	@State private var _highlightAreas = true // change to EnvironmentObject
	@State private var _highlightSimilar = true // change to EnvironmentObject
	@EnvironmentObject var _viewRouter: ViewRouter
	
    var body: some View {
		VStack {
			ScrollView {
				VStack(spacing: 0) {
					GenericTopBarView(title: "Definições", destination: Pages.home)
				
					Section {
						VStack(alignment: .leading) {
							Toggle(isOn: $_highlightAreas) {
								Text("Destacar áreas")
									.font(.custom("CaviarDreams-Bold", size: 20))
							}
							
							Text("Destacar a coluna e fila da célula selecionada")
								.font(.custom("CaviarDreams-Bold", size: 12))
								.foregroundColor(Color.gray)
						}
						
						VStack(alignment: .leading) {
							Toggle(isOn: $_highlightSimilar) {
								Text("Destacar números idênticos")
									.font(.custom("CaviarDreams-Bold", size: 20))
							}
						
							Text("Destacar os números iguais aos da célula selecionada")
								.font(.custom("CaviarDreams-Bold", size: 12))
								.foregroundColor(Color.gray)
						}
					}
						.padding(.top)
						.padding(.leading)
						.padding(.trailing)
					
					Spacer()
				}
			}
			
			Text("Made with ❤️ by Pedro Galhardo")
				.font(.custom("CaviarDreams-Bold", size: 8))
				.foregroundColor(Color.gray)
				.padding(.bottom, 5)
		}
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
