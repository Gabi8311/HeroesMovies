final class MoviesPresenter: GetMoviesUseCaseHandler {// Se implementa el protocolo GetMoviesUseCaseHandler
    
    private var useCase: GetMoviesUseCase
    private var moviesView: MoviesVCProtocol!
    private var movies: [Movie] = []
    
    init(useCase: GetMoviesUseCase, moviesView: MoviesVCProtocol) {// Se mete al constructor, las Movies y el protocol de la vista
        self.useCase = useCase
        self.moviesView = moviesView
    }
    
    // Cambiamos estas func(loadMovies,loadingMovies & loadedMovies)del MoviesViewController al Presenter
    func loadMovies() {
        loadingMovies()
        self.useCase.fetchAllMovies(handler:self)// Se cargan las movies, llamando a los hilos
    }
    
    func loadingMovies(){
        moviesView.clearMovies()
        moviesView.showLoadingText()
    }
    
    func onLoadedMovies(movies: [Movie]){// Método del protocol -> GetMoviesUseCaseHandler, para pintar la view
        self.movies = movies
        moviesView.showMovies(movies: movies)
        moviesView.showNumberOfMovies(numberOfMovies: movies.count)
    }
    
}

// Protocolo con el que se comunica el presenter con la vista
protocol MoviesVCProtocol {
    func showMovies(movies: [Movie]) -> Void
    func clearMovies() -> Void
    func showLoadingText() -> Void
    func showNumberOfMovies(numberOfMovies: Int) -> Void
}
