//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Капитонов Константин on 14.06.2026.
//
import Foundation

final class StatisticService: StatisticServiceProtocol {
	private enum Keys: String {
		case gamesCount          // Для счётчика сыгранных игр
		case bestGameCorrect     // Для количества правильных ответов в лучшей игре
		case bestGameTotal       // Для общего количества вопросов в лучшей игре
		case bestGameDate        // Для даты лучшей игры
		case totalCorrectAnswers // Для общего количества правильных ответов за все игры
		case totalQuestionsAsked // Для общего количества вопросов, заданных за все игры
	}
	
	private let storage: UserDefaults = .standard
	
	private(set) var gamesCount: Int {
		get {
			storage.integer(forKey: Keys.gamesCount.rawValue)
		}
		
		set {
			storage.set(newValue, forKey: Keys.gamesCount.rawValue)
		}
	}
	
	private(set) var bestGame: GameResult {
		get {
			.init(
				correct: storage.integer(forKey: Keys.bestGameCorrect.rawValue),
				total: storage.integer(forKey: Keys.bestGameTotal.rawValue),
				date: storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
			)
		}
		
		set {
			storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
			storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
			storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
		}
	}
	
	var totalAccuracy: Double {
		get {
			totalQuestionsAsked == 0 ? 0 : (Double(totalCorrectAnswers) / Double(totalQuestionsAsked)) * 100
		}
	}
	
	private var totalCorrectAnswers: Int {
		get {
			storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
		}
		set {
			storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
		}
	}
	
	private var totalQuestionsAsked: Int {
		get {
			storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
		}
		set {
			storage.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue)
		}
	}
	
	func store(result: GameResult) {
		gamesCount += 1
		bestGame = result.isBetter(than: bestGame) ? result : bestGame
		totalCorrectAnswers += result.correct
		totalQuestionsAsked += result.total
	}
}
