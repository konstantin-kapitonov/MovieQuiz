//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Капитонов Константин on 14.06.2026.
//
import UIKit

class AlertPresenter {
	func showAlert(vc: UIViewController, model: AlertModel) {
		let alert = UIAlertController(
			title: model.title,
			message: model.message,
			preferredStyle: .alert
		)
		let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
			model.completion()
		}
		alert.addAction(action)
		alert.view.accessibilityIdentifier = "Game results"

		vc.present(alert, animated: true, completion: nil)
	}
}
