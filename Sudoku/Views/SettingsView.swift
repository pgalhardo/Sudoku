//
//  SettingsView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 02/11/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
	@EnvironmentObject var _settings: Settings
	@EnvironmentObject var _viewRouter: ViewRouter
	
    var body: some View {
		VStack(spacing: 0) {
			GenericTopBarView(title: NSLocalizedString("main.settings", comment: ""),
							  destination: Pages.home)
		
			Section {
				VStack(alignment: .leading) {
					Toggle(isOn: $_settings._highlightAreas) {
						Text(NSLocalizedString("settings.areas", comment: ""))
							.font(.custom("CaviarDreams-Bold", size: 20))
					}
					
					Text(NSLocalizedString("settings.areas.descript", comment: ""))
						.font(.custom("CaviarDreams-Bold", size: 12))
						.foregroundColor(Color.gray)
				}
				
				VStack(alignment: .leading) {
					Toggle(isOn: $_settings._highlightSimilar) {
						Text(NSLocalizedString("settings.twins", comment: ""))
							.font(.custom("CaviarDreams-Bold", size: 20))
					}
				
					Text(NSLocalizedString("settings.twins.descript", comment: ""))
						.font(.custom("CaviarDreams-Bold", size: 12))
						.foregroundColor(Color.gray)
				}
				
				VStack(alignment: .leading) {
					Toggle(isOn: $_settings._hideUsed) {
						Text(NSLocalizedString("settings.used", comment: ""))
							.font(.custom("CaviarDreams-Bold", size: 20))
					}
				
					Text(NSLocalizedString("settings.used.descript", comment: ""))
						.font(.custom("CaviarDreams-Bold", size: 12))
						.foregroundColor(Color.gray)
				}
			}
				.padding(.top)
				.padding(.leading)
				.padding(.trailing)
			
			VStack(alignment: .leading) {
				Toggle(isOn: $_settings._enableTimer) {
					Text(NSLocalizedString("settings.timer", comment: ""))
						.font(.custom("CaviarDreams-Bold", size: 20))
				}
			}
				.padding(.top, 60)
				.padding(.leading)
				.padding(.trailing)
			
			HStack {
				Text(NSLocalizedString("settings.text.size", comment: ""))
					.font(.custom("CaviarDreams-Bold", size: 20))
				
				Spacer()
				Button(
					action: {
						if self._settings._fontSize > Int(Screen.cellWidth * 0.5) {
							self._settings._fontSize -= 1
						}
					},
					label: {
						Text("-")
							.font(.custom("CaviarDreams-Bold", size: 20))
							.frame(width: Screen.cellWidth,
								   height: Screen.cellWidth / 2)
							.background(Colors.MatteBlack)
							.foregroundColor(.white)
							.cornerRadius(5)
					}
				)
				Spacer()
				Text(String(format: "%02d", Int(_settings._fontSize)))
					.font(.custom("CaviarDreams-Bold", size: 20))
				Spacer()
				Button(
					action: {
						if self._settings._fontSize < Int(Screen.cellWidth * 0.9) {
							self._settings._fontSize += 1
						}
					},
					label: {
						Text("+")
							.font(.custom("CaviarDreams-Bold", size: 20))
							.frame(width: Screen.cellWidth,
								   height: Screen.cellWidth / 2)
							.background(Colors.MatteBlack)
							.foregroundColor(.white)
							.cornerRadius(5)
					}
				)
			}
				.padding(.top, 60)
				.padding(.leading)
				.padding(.trailing)
			
			Spacer()
		}
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
