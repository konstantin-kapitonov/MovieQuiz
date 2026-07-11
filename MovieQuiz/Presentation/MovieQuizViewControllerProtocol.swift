//
//  Untitled.swift
//  MovieQuiz
//
//  Created by Капитонов Константин on 12.07.2026.
//

protocol MovieQuizViewControllerProtocol: AnyObject {
	func show(quiz step: QuizStepViewModel)
	func show(quiz result: QuizResultsViewModel)
		
	func showAnswerResult(isCorrect: Bool)

	func showLoadingIndicator()
	func hideLoadingIndicator()
	
	func enableAnswerButtons()
	func disableAnswerButtons()
	
	func showNetworkError(message: String)
}
