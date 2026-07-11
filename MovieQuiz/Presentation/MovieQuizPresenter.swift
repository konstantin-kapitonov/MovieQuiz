//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Капитонов Константин on 11.07.2026.
//
import Foundation

final class MovieQuizPresenter {
	private weak var viewController: MovieQuizViewControllerProtocol?

	// MARK: - State
	private let questionsAmount = 10
	private var currentQuestionNumber = 0
	private var correctAnswers = 0
	
	// текущий вопрос, на него завязана логика обновления интерфеса
	private var currentQuestion: QuizQuestion? {
		didSet {
			guard let currentQuestion else { return }
			currentQuestionNumber += 1
			let viewModel = convert(model: currentQuestion)
			viewController?.show(quiz: viewModel)
			viewController?.enableAnswerButtons()
		}
	}
	
	//MARK: - Data source
	private lazy var questionFactory: QuestionFactoryProtocol = QuestionFactory(
		moviesLoader: MoviesLoader(),
		delegate: self
	)
	private var statisticService: StatisticServiceProtocol = StatisticService()
	
	//MARK: - Init()
	init(viewController: MovieQuizViewControllerProtocol) {
		self.viewController = viewController
	}
	
	func viewDidLoad() {
		questionFactory.loadData()
		self.viewController?.showLoadingIndicator()
		self.viewController?.disableAnswerButtons()
	}
	
	//MARK: - Public Methods
	// метод, который проверет правильность ответа
	func checkAnswer(_ answer: Bool) {
		viewController?.disableAnswerButtons()
		guard let currentQuestion else { return }
		let isCorrect = answer == currentQuestion.correctAnswer
		if isCorrect {
			correctAnswers += 1
		}
		viewController?.showAnswerResult(isCorrect: isCorrect)
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
			self?.showNextQuestionOrResults()
		}
	}
	
	func restartGame() {
		currentQuestionNumber = 0
		correctAnswers = 0
		questionFactory.resetViewedQuestions()
		questionFactory.requestNextQuestion()
	}
	
	func convert(model: QuizQuestion) -> QuizStepViewModel {
		QuizStepViewModel(
			image: model.image,
			question: model.text,
			questionNumber: "\(currentQuestionNumber)/\(questionsAmount)"
		)
	}
	
	// метод, который содержит логику перехода в один из сценариев
	private func showNextQuestionOrResults() {
		// показываем следующий вопрос или результаты
		if currentQuestionNumber == questionsAmount {
			statisticService.store(result: .init(correct: correctAnswers, total: questionsAmount, date: Date()))
		  let bestGame = statisticService.bestGame
		  let resultsText = """
Ваш результат: \(correctAnswers)/\(questionsAmount)
Количество сыгранных квизов: \(statisticService.gamesCount)
Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
Средняя точность: \(statisticService.totalAccuracy.formatted(.number.precision(.fractionLength(2))))%
"""
			viewController?.show(quiz: QuizResultsViewModel(
			title: "Этот раунд окончен!",
			text: resultsText,
			buttonText: "Сыграть еще раз"
		  ))
	  } else {
		  questionFactory.requestNextQuestion()
	  }
	}
}

//MARK: - Delegate
extension MovieQuizPresenter: QuestionFactoryDelegate {
	func didReceiveNextQuestion(question: QuizQuestion?) {
		currentQuestion = question
	}
	
	func didLoadDataFromServer() {
		DispatchQueue.main.async { [weak viewController] in
			viewController?.hideLoadingIndicator()
		}
		questionFactory.requestNextQuestion()
	}

	func didFailToLoadData(with error: Error) {
		DispatchQueue.main.async { [weak viewController] in
			viewController?.showNetworkError(message: error.localizedDescription)
		}
	}
}
