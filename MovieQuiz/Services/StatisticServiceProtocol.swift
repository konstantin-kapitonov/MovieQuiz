//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Капитонов Константин on 14.06.2026.
//

protocol StatisticServiceProtocol {
	var gamesCount: Int { get }
	var bestGame: GameResult { get }
	var totalAccuracy: Double { get }
	
	func store(result: GameResult)
}
