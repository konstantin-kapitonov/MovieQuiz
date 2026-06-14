//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Капитонов Константин on 14.06.2026.
//

protocol QuestionFactoryDelegate: AnyObject {
	func didReceiveNextQuestion(question: QuizQuestion?)
}
