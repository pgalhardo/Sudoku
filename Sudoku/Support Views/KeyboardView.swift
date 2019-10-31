//
//  KeyboardView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 30/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import SwiftUI

struct KeyboardView: View {
	var body: some View {
		VStack {
			KeyboardRowView(min: 1, max: 3)
			KeyboardRowView(min: 4, max: 6)
			KeyboardRowView(min: 7, max: 9)
		}
	}
}

struct KeyboardRowView: View {
	private var _min: Int!
	private var _max: Int!
	
	init(min: Int, max: Int) {
		_min = min
		_max = max
	}
	
	var body: some View {
		HStack {
			ForEach(self._min ..< self._max + 1) { i in
				Spacer()
				KeyboardButtonView(number: i)
			}
			Spacer()
		}
			.padding(.bottom)
			.padding(.top)
	}
}

struct KeyboardButtonView: View {
	private var _number: Int!
	
	init(number: Int) {
		_number = number
	}
	
	var body: some View {
		Button(
			action: { print("clicked") },
			label: {
				Text("\(_number)")
					.frame(width: Screen.cellWidth * 2, height: Screen.cellWidth)
					.background(Color(red: 31 / 255, green: 31 / 255, blue: 36 / 255))
					.foregroundColor(.white)
					.cornerRadius(10)
					.font(.custom("CaviarDreams-Bold", size: Screen.cellWidth / 2))
			}
		)
	}
}
