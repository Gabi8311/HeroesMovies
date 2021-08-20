final class MoreDetailsPresenter {
    
    private var moreDetailsView: MoreDetailsViewProtocol!
    private var setupDetailsView: MoreDetailSetupData!
    
    // Se le mete los UseCases para pasárselo en appDependencies()
    init(moreDetailsView: MoreDetailsViewProtocol, useCase: GetMoviesUseCase) {
        self.moreDetailsView = moreDetailsView
    }
    
    // Se cargan los datos que queremos pasar en el segue
    func setupMoreDetailsView(_ data: MoreDetailSetupData) {
        self.setupDetailsView = data
    }
    
    // Seteamos la movie
    func getMovieMoreDetails() -> Void {
        guard let setup = self.setupDetailsView else {
            return
        }
        moreDetailsView.setMovieMoreDetails(setup.movie)
    }
    
}

protocol MoreDetailsViewProtocol {
    func setMovieMoreDetails(_ movie: Movie) -> Void
}
