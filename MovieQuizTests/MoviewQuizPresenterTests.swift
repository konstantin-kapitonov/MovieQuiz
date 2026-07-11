//
//  MoviewQuizPresenterTests.swift
//  MovieQuiz
//
//  Created by Капитонов Константин on 12.07.2026.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
	func show(quiz step: MovieQuiz.QuizStepViewModel) {	}
	
	func show(quiz result: MovieQuiz.QuizResultsViewModel) { }
	
	func showAnswerResult(isCorrect: Bool) { }
	
	func showLoadingIndicator() { }
	
	func hideLoadingIndicator() { }
	
	func enableAnswerButtons() { }
	
	func disableAnswerButtons() { }
	
	func showNetworkError(message: String) { }
}
	

final class MovieQuizPresenterTests: XCTestCase {
	func testPresenterConvertModel() throws {
		let viewControllerMock = MovieQuizViewControllerMock()
		let sut = MovieQuizPresenter(viewController: viewControllerMock)
		
		let emptyData = Data()
		let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
		let viewModel = sut.convert(model: question)
		
		XCTAssertEqual(viewModel.image, emptyData)
		XCTAssertEqual(viewModel.question, "Question Text")
		XCTAssertEqual(viewModel.questionNumber, "0/10")
	}
}
