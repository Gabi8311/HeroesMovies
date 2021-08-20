final class MoviesDetailsPresenter {
    
    private var moviesDetailsView: MoviesDetailsViewProtocol!
    private var setupView: MovieDetailSetupData!
    
    // Se le mete los UseCases para pasárselo en appDependencies()
    init(moviesDetailsView: MoviesDetailsViewProtocol, useCase: GetMoviesUseCase) {
        self.moviesDetailsView = moviesDetailsView
    }
    
    // Se cargan los datos que queremos pasar
    func setupView(_ data: MovieDetailSetupData) {
        self.setupView = data
    }
    
    // Seteamos el array de movies y el índice pulsado desde la lista de movies
    func getAllMoviesAndIndexPushed() -> Void {
        guard let setup = self.setupView else {
            return
        }
        moviesDetailsView.setMovies(setup.movies)
        moviesDetailsView.setIndex(setup.index)
    }
    
}

protocol MoviesDetailsViewProtocol {
    func setMovies(_ movies: [Movie]) -> Void
    func setIndex(_ index: Int) -> Void
}
