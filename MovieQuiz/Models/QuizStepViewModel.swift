//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Капитонов Константин on 14.06.2026.
//
import Foundation

struct QuizStepViewModel {
  // картинка с афишей фильма с типом UIImage
  let image: Data
  // вопрос о рейтинге квиза
  let question: String
  // строка с порядковым номером этого вопроса (ex. "1/10")
  let questionNumber: String
}
