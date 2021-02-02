/*
 MIT License

 Copyright (c) 2018-Present Omar Albeik

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */
import UserDefaultsStore

/// Class responsible to handler objects CRUD persistently.
class PersistenceManager {
    /// The movie database identifier.
    private let moviesStore = UserDefaultsStore<Movie>(uniqueIdentifier: Constants.moviesStoreId)

    /// Save a movie.
    /// - Parameter movie: The movie to be saved.
    func save(movie: Movie) {
        do {
            try moviesStore.save(movie)
        } catch {
            print("Save movie error: \(movie.title)") // TODO: Handle it
        }
    }

    /// Check if movie already exists.
    /// - Parameter id: The unique movie id.
    /// - Returns: A Boolean indicating whether movie already exists.
    func hasMovie(id: Int) -> Bool {
        return moviesStore.hasObject(withId: id)
    }

    /// Get all stored movies.
    /// - Returns: An Array of all stored movies.
    func getAllMovies() -> [Movie] {
        return moviesStore.allObjects()
    }

    /// Delete stored movie.
    /// - Parameter id: The movie id to be deleted.
    func deleteMovie(id: Int) {
        moviesStore.delete(withId: id)
    }

    /// Delete all stored movies.
    func deleteAllMovies() {
        moviesStore.deleteAll()
    }
}
