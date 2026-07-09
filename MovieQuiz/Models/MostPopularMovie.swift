//
//  MostPopularMovie.swift
//  MovieQuiz
//
//  Created by Капитонов Константин on 09.07.2026.
//
import Foundation

struct MostPopularMovie: Codable {
	let title: String
	let rating: String
	let imageURL: URL
	
	var resizedImageURL: URL {
		// создаем строку из адреса
		let urlString = imageURL.absoluteString
		//  обрезаем лишнюю часть и добавляем модификатор желаемого качества
		let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
		
		// пытаемся создать новый адрес, если не получается возвращаем старый
		guard let newURL = URL(string: imageUrlString) else {
			return imageURL
		}
		
		return newURL
	}
	
	private enum CodingKeys: String, CodingKey {
		case title = "fullTitle"
		case rating = "imDbRating"
		case imageURL = "image"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		title = try values.decode(String.self, forKey: .title)
		rating = try values.decode(String.self, forKey: .rating)
		imageURL = try values.decode(URL.self, forKey: .imageURL)
	}
}
