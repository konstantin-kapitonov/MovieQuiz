//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Капитонов Константин on 30.06.2026.
//
import Foundation

protocol MoviesLoaderProtocol {
	func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoaderProtocol {
	private enum Constants {
		static let apiKey = "k_zcuw1ytf"
		static let baseUrl = "https://tv-api.com/en/API/Top250Movies/"
	}
	private let networkClient = NetworkClient()
	
	private var mostPopularMoviesUrl: URL {
		guard let url = URL(string: Constants.baseUrl + Constants.apiKey) else {
			preconditionFailure("Unable to construct mostPopularMoviesUrl")
		}
		return url
	}
	
	func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
		networkClient.fetch(url: mostPopularMoviesUrl) { result in
			switch result {
			case .success(let data):
				do {
					let movies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
					handler(.success(movies))
				} catch {
					handler(.failure(error))
				}
			case .failure(let error):
				handler(.failure(error))
			}
		}
	}
}
