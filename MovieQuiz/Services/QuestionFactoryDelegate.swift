//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Капитонов Константин on 14.06.2026.
//

protocol QuestionFactoryDelegate: AnyObject {
	func didReceiveNextQuestion(question: QuizQuestion?)
	func didLoadDataFromServer() // сообщение об успешной загрузке
	func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
