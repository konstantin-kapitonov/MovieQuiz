import UIKit

final class MovieQuizViewController: UIViewController {
	
	// MARK: - IBOutlets
	@IBOutlet private var imageView: UIImageView!
	@IBOutlet private var textLabel: UILabel!
	@IBOutlet private var counterLabel: UILabel!
	@IBOutlet private var yesButton: UIButton!
	@IBOutlet private var noButton: UIButton!
	
	// MARK: - State
	// переменная с индексом текущего вопроса
	private var currentQuestionIndex = 0 {
		didSet {
			guard currentQuestionIndex < questions.count else { return }
			show(quiz: convert(model: questions[currentQuestionIndex]))
		}
	}
	
	// переменная со счётчиком правильных ответов
	private var correctAnswers = 0
	
	// MARK: - Data Source
	// массив вопросов
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

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		currentQuestionIndex = 0
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
			image: UIImage(named: model.image) ?? UIImage(),
			question: model.text,
			questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
		)
	}
	
	// метод вывода на экран вопроса
	private func show(quiz step: QuizStepViewModel) {
		imageView.image = step.image
		textLabel.text = step.question
		counterLabel.text = step.questionNumber
	}
	
	// метод вывода на экран результатов
	private func show(quiz result: QuizResultsViewModel) {
		let alert = UIAlertController(
			title: result.title,
			message: result.text,
			preferredStyle: .alert
		)
		let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
			self.currentQuestionIndex = 0
			self.correctAnswers = 0
		}
		alert.addAction(action)
		self.present(alert, animated: true, completion: nil)
	}
	
	// метод, который проверет правильность ответа
	private func check(answer: Bool) {
		// выключаем интерактивность кнопок
		yesButton.isEnabled = false
		noButton.isEnabled = false
		
		let isCorrect = answer == questions[currentQuestionIndex].correctAnswer
		if isCorrect {
			correctAnswers += 1
		}
		showAnswerResult(isCorrect: isCorrect)
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
			// включаем интерактивность кнопок
			self?.yesButton.isEnabled = true
			self?.noButton.isEnabled = true
			// прячем рамку с результатом ответа на предыдущий вопрос
			self?.imageView.layer.borderWidth = 0
			// показываем следующий вопрос или результаты
			self?.showNextQuestionOrResults()
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
	  if currentQuestionIndex == questions.count - 1 {
		  show(quiz: QuizResultsViewModel(
			title: "Этот раунд окончен!",
			text: "Ваш результат: \(correctAnswers)/\(questions.count)",
			buttonText: "Сыграть еще раз"
		  ))
	  } else {
		currentQuestionIndex += 1
	  }
	}
}

fileprivate struct QuizResultsViewModel {
  // строка с заголовком алерта
  let title: String
  // строка с текстом о количестве набранных очков
  let text: String
  // текст для кнопки алерта
  let buttonText: String
}

fileprivate struct QuizQuestion {
  // строка с названием фильма,
  // совпадает с названием картинки афиши фильма в Assets
  let image: String
  // строка с вопросом о рейтинге фильма
  let text: String
  // булевое значение (true, false), правильный ответ на вопрос
  let correctAnswer: Bool
}

// вью модель для состояния "Вопрос показан"
fileprivate struct QuizStepViewModel {
  // картинка с афишей фильма с типом UIImage
  let image: UIImage
  // вопрос о рейтинге квиза
  let question: String
  // строка с порядковым номером этого вопроса (ex. "1/10")
  let questionNumber: String
}
