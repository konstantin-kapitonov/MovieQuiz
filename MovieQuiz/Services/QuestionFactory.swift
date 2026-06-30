//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Капитонов Константин on 14.06.2026.
//
import Foundation

class QuestionFactory: QuestionFactoryProtocol {
	weak var delegate: QuestionFactoryDelegate?
	
	private var movies: [MostPopularMovie] = []
	
//	private let questions: [QuizQuestion] = [
//		.init(
//			image: "The Godfather",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: true),
//		.init(
//			image: "The Dark Knight",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: true),
//		.init(
//			image: "Kill Bill",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: true),
//		.init(
//			image: "The Avengers",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: true),
//		.init(
//			image: "Deadpool",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: true),
//		.init(
//			image: "The Green Knight",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: true),
//		.init(
//			image: "Old",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: false),
//		.init(
//			image: "The Ice Age Adventures of Buck Wild",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: false),
//		.init(
//			image: "Tesla",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: false),
//		.init(
//			image: "Vivarium",
//			text: "Рейтинг этого фильма больше чем 6?",
//			correctAnswer: false)
//	]
	
	/* Реализация расширена относительно той, что была представлена в курсе
	 Мне надаело, что все время выпадают одни и те же вопросы и я сделал механизм,
	 который проверяет что следующий вопрос в раунде, не будет повторять один из прошлых.
	 */
	private var availableQuestionsIndexes = Set<Int>()
	private let moviesLoader: MoviesLoading
	
	init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
		self.moviesLoader = moviesLoader
		self.delegate = delegate
	}
	
	func requestNextQuestion() {
		DispatchQueue.global().async { [weak self] in
			guard let self else { return }
			guard let index = availableQuestionsIndexes.randomElement() else {
				delegate?.didReceiveNextQuestion(question: nil)
				return
			}
			availableQuestionsIndexes.remove(index)
			guard let movie = self.movies[safe: index] else { return }
			let question = self.convert(movie: movie)
			DispatchQueue.main.async { [weak self] in
				guard let self else { return }
				self.delegate?.didReceiveNextQuestion(question: question)
			}
		}
	}
	
	func resetViewedQuestions() {
		self.availableQuestionsIndexes = Set(0..<movies.count)
	}
	
	func loadData() {
		moviesLoader.loadMovies { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let mostPopularMovies):
				self.movies = mostPopularMovies.items // сохраняем фильм в нашу новую переменную
				self.availableQuestionsIndexes = Set(0..<self.movies.count)
				self.delegate?.didLoadDataFromServer() // сообщаем, что данные загрузились
			case .failure(let error):
				self.delegate?.didFailToLoadData(with: error) // сообщаем об ошибке нашему MovieQuizViewController
			}
		}
	}
	
	private func convert(movie: MostPopularMovie) -> QuizQuestion {
		var imageData = Data()
		do {
			imageData = try Data(contentsOf: movie.resizedImageURL)
		} catch {
			delegate?.didFailToLoadData(with: error)
		}
		let rating = Double(movie.rating) ?? 0
		
		var candidates: [Double] = []
		for offset in [0.5, 1.0, 1.5] {
			if rating + offset < 10 {
				candidates.append(rating + offset)
			}
			if rating - offset > 0 {
				candidates.append(rating - offset)
			}
		}
		let threshold = candidates.randomElement() ?? 7
		let formattedThreshold = threshold.formatted(
			.number
				.locale(Locale(identifier: "en_US_POSIX"))
				.precision(.fractionLength(0...1))
		)

		let text = "Рейтинг этого фильма больше чем \(formattedThreshold)?"

		let correctAnswer = rating > threshold
		
		return QuizQuestion(
			image: imageData,
			text: text,
			correctAnswer: correctAnswer
		)
	}
}
