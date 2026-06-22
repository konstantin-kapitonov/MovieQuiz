//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Капитонов Константин on 14.06.2026.
//

class QuestionFactory: QuestionFactoryProtocol {
	weak var delegate: QuestionFactoryDelegate?
	
	private let questions: [QuizQuestion] = [
		.init(
			image: "The Godfather",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: true),
		.init(
			image: "The Dark Knight",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: true),
		.init(
			image: "Kill Bill",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: true),
		.init(
			image: "The Avengers",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: true),
		.init(
			image: "Deadpool",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: true),
		.init(
			image: "The Green Knight",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: true),
		.init(
			image: "Old",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: false),
		.init(
			image: "The Ice Age Adventures of Buck Wild",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: false),
		.init(
			image: "Tesla",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: false),
		.init(
			image: "Vivarium",
			text: "Рейтинг этого фильма больше чем 6?",
			correctAnswer: false)
	]
	
	/* Реализация расширена относительно той, что была представлена в курсе
	 Мне надаело, что все время выпадают одни и те же вопросы и я сделал механизм,
	 который проверяет что следующий вопрос в раунде, не будет повторять один из прошлых.
	 */
	private var availableQuestionsIndexes: Set<Int>
	
	init() {
		self.availableQuestionsIndexes = Set(0..<questions.count)
	}
	
	func requestNextQuestion() {
		guard let index = availableQuestionsIndexes.randomElement() else {
			delegate?.didReceiveNextQuestion(question: nil)
			return
		}
		availableQuestionsIndexes.remove(index)
		let question = questions[safe: index]
		delegate?.didReceiveNextQuestion(question: question)
	}
	
	func resetViewedQuestions() {
		self.availableQuestionsIndexes = Set(0..<questions.count)
	}
}
