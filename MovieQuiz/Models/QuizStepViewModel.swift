//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Капитонов Константин on 14.06.2026.
//
import UIKit.UIImage

struct QuizStepViewModel {
  // картинка с афишей фильма с типом UIImage
  let image: UIImage
  // вопрос о рейтинге квиза
  let question: String
  // строка с порядковым номером этого вопроса (ex. "1/10")
  let questionNumber: String
}
