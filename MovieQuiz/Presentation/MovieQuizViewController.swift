import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
	
	// MARK: - IBOutlets
	@IBOutlet private weak var imageView: UIImageView!
	@IBOutlet private weak var textLabel: UILabel!
	@IBOutlet private weak var counterLabel: UILabel!
	@IBOutlet private weak var yesButton: UIButton!
	@IBOutlet private weak var noButton: UIButton!
	@IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
	
	//MARK: - Presenters
	private var alertPresenter = AlertPresenter()
	private lazy var presenter = MovieQuizPresenter(viewController: self)
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		presenter.viewDidLoad()
	}
	
	// MARK: - IBActions
	@IBAction private func yesButtonClicked(_ sender: UIButton) {
		presenter.checkAnswer(true)
	}
	
	@IBAction private func noButtonClicked(_ sender: UIButton) {
		presenter.checkAnswer(false)
	}
	
	// MARK: - Public Methods
	// метод вывода на экран вопроса
	func show(quiz step: QuizStepViewModel) {
		self.imageView.image = UIImage(data: step.image) ?? UIImage()
		self.textLabel.text = step.question
		self.counterLabel.text = step.questionNumber
	}

	// метод вывода на экран результатов
	func show(quiz result: QuizResultsViewModel) {
		let alertModel = AlertModel(
			title: result.title,
			message: result.text,
			buttonText: result.buttonText,
			completion: { [weak self] in
				self?.presenter.restartGame()
			})
		alertPresenter.showAlert(vc: self, model: alertModel)
	}
	
	// метод, который меняет цвет рамки
	func showAnswerResult(isCorrect: Bool) {
		imageView.layer.masksToBounds = true
		imageView.layer.borderWidth = 8
		imageView.layer.cornerRadius = 20
		imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
	}
	
	func enableAnswerButtons() {
		yesButton.isEnabled = true
		noButton.isEnabled = true
		// прячем рамку с результатом ответа на предыдущий вопрос
		imageView.layer.borderWidth = 0
	}
	
	func disableAnswerButtons() {
		yesButton.isEnabled = false
		noButton.isEnabled = false
	}
	
	func hideLoadingIndicator() {
		self.activityIndicator.stopAnimating()
		self.activityIndicator.isHidden = true
	}
	
	func showNetworkError(message: String) {
		hideLoadingIndicator()
		let alertModel = AlertModel(
			title: "Ошибка",
			message: message,
			buttonText: "Попробовать ещё раз",
			completion: { [weak self] in
				self?.presenter.restartGame()
			})
		alertPresenter.showAlert(vc: self, model: alertModel)
	}
	
	func showLoadingIndicator() {
		self.activityIndicator.isHidden = false
		self.activityIndicator.startAnimating()
	}
}
