//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Капитонов Константин on 14.06.2026.
//

protocol QuestionFactoryProtocol {
	func requestNextQuestion()
	// добавлена функция сброса просмотренных вопросов
	func resetViewedQuestions()
}
