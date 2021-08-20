import Foundation

final class DiskMoviesRepository: MoviesRepository {
    
    func getMovies() -> [Movie]{// Se devuelve el array de movies una vez se rellenan los objetos con los datos del JSON
        
        var movies:[Movie] = []
        let url = Bundle.main.url(forResource: "Movies", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            
            if let moviesjson = json as? [[String: AnyObject]] {
                for moviejson in moviesjson {
                    let movie: Movie = Movie();
                    movie.title = moviejson["title"] as? String
                    movie.image = moviejson["image"] as? String
                    movie.description = moviejson["description"] as? String
                    movie.company = moviejson["company"] as? String
                    movie.year = moviejson["year"] as? String
                    movie.rating = moviejson["rating"] as? String
                    movie.duration = moviejson["duration"] as? String
                    
                    if let filmImageCount = moviejson["filmImages"]?.count {
                        for i in 0..<filmImageCount {
                            let image = moviejson["filmImages"]?[i]
                            movie.filmImages.append(image as! String)
                        }
                    }
                    
                    movies.append(movie)
                }
            }
        } catch {
            print("Error serializing JSON: \(error)")
        }
        
        simulateDelay()
        
        return movies;
    }
    
    private func simulateDelay() -> Void{
        sleep(1)
    }
    
}
