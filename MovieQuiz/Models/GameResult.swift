//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Капитонов Константин on 14.06.2026.
//
import Foundation

struct GameResult {
	let correct: Int
	let total: Int
	let date: Date
	
	func isBetter(than other: GameResult) -> Bool {
		correct > other.correct
	}
}
