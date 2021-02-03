//
//  PopularMoviesTests.swift
//  PopularMoviesTests
//
//  Created by Júlio Andherson de Oliveira Silva on 24/01/21.
//

import XCTest
@testable import PopularMovies

class PopularMoviesTests: XCTestCase {
    let movieViewModel = MovieViewModel()

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMoviePersistence() throws {
        let mockMovie = Movie(id: 123456, originalTitle: "Cast Away", title: "Cas Away", overview: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", posterPath: "posterPath/", backdropPath: "backdropPath/", voteAverage: 7.23)
        
        var hasMovie = movieViewModel.hasMovie(id: mockMovie.id)
        XCTAssertFalse(hasMovie)
        
        movieViewModel.saveMovie(movie: mockMovie)
        hasMovie = movieViewModel.hasMovie(id: mockMovie.id)
        XCTAssertTrue(hasMovie)
        
        XCTAssert(movieViewModel.getAllMovies().count >= 1)

        movieViewModel.deleteMovie(id: mockMovie.id)
        hasMovie = movieViewModel.hasMovie(id: mockMovie.id)
        XCTAssertFalse(hasMovie)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
