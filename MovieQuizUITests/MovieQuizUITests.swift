//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Капитонов Константин on 09.07.2026.
//

import XCTest

class MovieQuizUITests: XCTestCase {
	// swiftlint:disable:next implicitly_unwrapped_optional
	var app: XCUIApplication!
	
	override func setUpWithError() throws {
		try super.setUpWithError()
		
		app = XCUIApplication()
		app.launch()
		
		// это специальная настройка для тестов: если один тест не прошёл,
		// то следующие тесты запускаться не будут; и правда, зачем ждать?
		continueAfterFailure = false
	}
	override func tearDownWithError() throws {
		try super.tearDownWithError()
		
		app.terminate()
		app = nil
	}
	
	func testYesButton() {
		let indexLabel = app.staticTexts["Index"]
		
		sleep(3)
		
		XCTAssertEqual(indexLabel.label, "1/10")
		let firstPoster = app.images["Poster"] // находим первоначальный постер
		let firstPosterData = firstPoster.screenshot().pngRepresentation
		app.buttons["Yes"].tap() // находим кнопку `Да` и нажимаем её
		
		sleep(3)
		
		let secondPoster = app.images["Poster"] // ещё раз находим постер
		let secondPosterData = secondPoster.screenshot().pngRepresentation
		
		XCTAssertEqual(indexLabel.label, "2/10")
		
		XCTAssertNotEqual(firstPosterData, secondPosterData) // проверяем, что постеры разные
	}
	
	func testNoButton() {
		let indexLabel = app.staticTexts["Index"]
		
		sleep(3)
		
		XCTAssertEqual(indexLabel.label, "1/10")
		let firstPoster = app.images["Poster"] // находим первоначальный постер
		let firstPosterData = firstPoster.screenshot().pngRepresentation
		app.buttons["No"].tap() // находим кнопку `Да` и нажимаем её
		
		sleep(3)
		
		let secondPoster = app.images["Poster"] // ещё раз находим постер
		let secondPosterData = secondPoster.screenshot().pngRepresentation
		
		XCTAssertEqual(indexLabel.label, "2/10")
		
		XCTAssertNotEqual(firstPosterData, secondPosterData) // проверяем, что постеры разные
	}
	
	func testGameFinish() {
		for _ in 0..<10 {
			sleep(1)
			app.buttons["Yes"].tap()
		}
		
		sleep(1)
		
		let alert = app.alerts["Game results"]
		XCTAssertTrue(alert.exists)
		XCTAssertTrue(alert.label == "Этот раунд окончен!")
		XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
	}
	
	func testGameRestart() {
		for _ in 0..<10 {
			sleep(1)
			app.buttons["No"].tap()
		}
		
		sleep(1)
		
		let alert = app.alerts["Game results"]
		alert.buttons.firstMatch.tap()
		
		sleep(1)
		
		XCTAssertEqual(app.staticTexts["Index"].firstMatch.label, "1/10")
	}
}
