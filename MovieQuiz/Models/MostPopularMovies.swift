//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Капитонов Константин on 30.06.2026.
//
import Foundation

struct MostPopularMovies: Codable {
	let errorMessage: String
	let items: [MostPopularMovie]
}
