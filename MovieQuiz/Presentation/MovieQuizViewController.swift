import UIKit

final class MovieQuizViewController: UIViewController {
	
	// MARK: - IBOutlets
	@IBOutlet private var imageView: UIImageView!
	@IBOutlet private var textLabel: UILabel!
	@IBOutlet private var counterLabel: UILabel!
	@IBOutlet private var yesButton: UIButton!
	@IBOutlet private var noButton: UIButton!
	@IBOutlet private var activityIndicator: UIActivityIndicatorView!
	
	// MARK: - State
	// переменная с номером текущего вопроса
	private var currentQuestionNumber = 0
	
	// общее число вопросов
	private let questionsAmount = 10
	
	// переменная со счётчиком правильных ответов
	private var correctAnswers = 0
	
	// текущий вопрос, на него завязана логика обновления интерфеса
	private var currentQuestion: QuizQuestion? {
		didSet {
			guard let currentQuestion else { return }
			self.currentQuestionNumber += 1
			let viewModel = convert(model: currentQuestion)
			show(quiz: viewModel)
		}
	}
	
	//MARK: - Data source
	
	private var questionFactory: QuestionFactoryProtocol?
	private var statisticService: StatisticServiceProtocol = StatisticService()
	
	
	//MARK: - Alert Presenter
	
	private var alertPresenter = AlertPresenter()
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
				
		questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
		showLoadingIndicator()
		questionFactory?.loadData()
	}
	
	// MARK: - IBActions
	@IBAction private func yesButtonClicked(_ sender: UIButton) {
		check(answer: true)
	}
	
	@IBAction private func noButtonClicked(_ sender: UIButton) {
		check(answer: false)
	}
	
	// MARK: - Private Methods
	private func convert(model: QuizQuestion) -> QuizStepViewModel {
		QuizStepViewModel(
			image: UIImage(data: model.image) ?? UIImage(),
			question: model.text,
			questionNumber: "\(currentQuestionNumber)/\(questionsAmount)"
		)
	}
	
	// метод вывода на экран вопроса
	private func show(quiz step: QuizStepViewModel) {
		self.imageView.image = step.image
		self.textLabel.text = step.question
		self.counterLabel.text = step.questionNumber
	}

	// метод вывода на экран результатов
	private func show(quiz result: QuizResultsViewModel) {
		let alertModel = AlertModel(
			title: result.title,
			message: result.text,
			buttonText: result.buttonText,
			completion: { [weak self] in
				guard let self else { return }
				self.restartGame()
			})
		alertPresenter.showAlert(vc: self, model: alertModel)
	}

	private func restartGame() {
		currentQuestionNumber = 0
		correctAnswers = 0
		questionFactory?.resetViewedQuestions()
		questionFactory?.requestNextQuestion()
	}
	
	// метод, который проверет правильность ответа
	private func check(answer: Bool) {
		// выключаем интерактивность кнопок
		yesButton.isEnabled = false
		noButton.isEnabled = false
		
		guard let currentQuestion else { return }
		let isCorrect = answer == currentQuestion.correctAnswer
		if isCorrect {
			correctAnswers += 1
		}
		showAnswerResult(isCorrect: isCorrect)
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
			guard let self else { return }
			// включаем интерактивность кнопок
			self.yesButton.isEnabled = true
			self.noButton.isEnabled = true
			// прячем рамку с результатом ответа на предыдущий вопрос
			self.imageView.layer.borderWidth = 0
			// показываем следующий вопрос или результаты
			self.showNextQuestionOrResults()
		}
	}
	
	// метод, который меняет цвет рамки
	private func showAnswerResult(isCorrect: Bool) {
		imageView.layer.masksToBounds = true
		imageView.layer.borderWidth = 8
		imageView.layer.cornerRadius = 20
		imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
	}
	
	// метод, который содержит логику перехода в один из сценариев
	private func showNextQuestionOrResults() {
	  if currentQuestionNumber == questionsAmount {
		  statisticService.store(result: .init(correct: correctAnswers, total: questionsAmount, date: Date()))
		  let bestGame = statisticService.bestGame
		  let resultsText = """
Ваш результат: \(correctAnswers)/\(questionsAmount)
Количество сыгранных квизов: \(statisticService.gamesCount)
Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
Средняя точность: \(statisticService.totalAccuracy.formatted(.number.precision(.fractionLength(2))))%
"""
		  show(quiz: QuizResultsViewModel(
			title: "Этот раунд окончен!",
			text: resultsText,
			buttonText: "Сыграть еще раз"
		  ))
	  } else {
		  questionFactory?.requestNextQuestion()
	  }
	}
	
	private func showLoadingIndicator() {
		DispatchQueue.main.async { [weak self] in
			self?.activityIndicator.isHidden = false
			self?.activityIndicator.startAnimating()
		}
	}
	
	private func hideLoadingIndicator() {
		DispatchQueue.main.async { [weak self] in
			self?.activityIndicator.stopAnimating()
			self?.activityIndicator.isHidden = true
		}
	}
	
	private func showNetworkError(message: String) {
		hideLoadingIndicator()
		DispatchQueue.main.async { [weak self] in
			guard let self else { return }
			let alertModel = AlertModel(
				title: "Ошибка",
				message: message,
				buttonText: "Попробовать ещё раз",
				completion: { [weak self] in
					guard let self else { return }
					self.restartGame()
				})
			alertPresenter.showAlert(vc: self, model: alertModel)
		}
	}
}

extension MovieQuizViewController: QuestionFactoryDelegate {
	func didReceiveNextQuestion(question: QuizQuestion?) {
		self.currentQuestion = question
	}
	
	func didLoadDataFromServer() {
		hideLoadingIndicator()
		questionFactory?.requestNextQuestion()
	}

	func didFailToLoadData(with error: Error) {
		showNetworkError(message: error.localizedDescription)
	}
}
