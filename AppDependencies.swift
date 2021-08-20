import UIKit

final class AppDependencies{
    // Las dos Objetos que se van a inyectar globalmente
    private var moviesRepository: MoviesRepository!
    private var useCase: GetMoviesUseCase!
    
    init() {
        configureDependencies()
    }
    
    // Se crean los objetos que se pasan en el constructor
    func configureDependencies(){
        self.moviesRepository = DiskMoviesRepository()
        self.useCase = GetMoviesUseCase(self.moviesRepository)
    }
    
    // 1º. Se recoge el UINavigationController
    func navigationControllerFromWindow(_ window: UIWindow) -> UINavigationController {
        let navigationController = window.rootViewController as! UINavigationController
        
        return navigationController
    }
    
    // 2º. Se le dice a la view actualmente visible que es del tipo MoviesViewController
    func getMoviesVC(_ window: UIWindow) -> MoviesViewController {
        let navigationController = navigationControllerFromWindow(window)
        let moviesTableViewController = navigationController.visibleViewController as! MoviesViewController
        // visibleViewController -> vista asociada con la vista actualmente visible en la interfaz de navegación
        return moviesTableViewController
    }
    
    // 3º. Se crean la view y el presenter y se enlazan(Func que se llama desde AppDelegate)
    func installRootViewControllerIntoWindow(_ window: UIWindow) {
        let viewController = getMoviesVC(window)
        let moviesPresenter = MoviesPresenter(useCase: self.useCase, moviesView: viewController)
        viewController.setMoviePresenter(moviesPresenter)
    }
    
    // Se crea el detailsPresenter y se le asignan la view y los UseCases
    func configureMovieDetailsVC(_ moviesDetailsViewController: MoviesDetailsViewController) {
        let detailsPresenter = MoviesDetailsPresenter(moviesDetailsView: moviesDetailsViewController, useCase: self.useCase)
        moviesDetailsViewController.setMovieDetailsPresenter(detailsPresenter)
    }
    
    // Se crea el moreDetailsPresenter y se le asignan la view y los UseCases
    func configureMoreDetailsVC(_ moreDetailsViewController: MoreDetailsViewController) {
        let moreDetailsPresenter = MoreDetailsPresenter(moreDetailsView: moreDetailsViewController, useCase: self.useCase)
        moreDetailsViewController.setMoreDetailsPresenter(moreDetailsPresenter)
    }
    
}
