//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Капитонов Константин on 14.06.2026.
//
import CoreData

struct QuizQuestion {
  // Данные с афишей фильма
  let image: Data
  // строка с вопросом о рейтинге фильма
  let text: String
  // булевое значение (true, false), правильный ответ на вопрос
  let correctAnswer: Bool
}
