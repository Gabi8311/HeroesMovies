import UIKit
import SDWebImage

final class MoviesDetailsViewController: UIViewController, UITableViewDelegate, MoviesDetailsViewProtocol, CarouselViewDelegate, DelegateMoreDetailsProtocol {
    
    private var moviesDetailsPresenter: MoviesDetailsPresenter!
    private var carouselData = [CarouselData]()
    private var carousel: CarouselView!// Las vistas ,normalmente, se fuerzan con !
    private var movies: [Movie] = []
    private var index: Int = 0
    private let identifierSegue = "moreDetails"
    
    // Se llama esta func desde el appDependencies() que inyecta el presenter
    func setMovieDetailsPresenter(_ moviesDetailsPresenter: MoviesDetailsPresenter) {
        self.moviesDetailsPresenter = moviesDetailsPresenter
    }
    
    // Se llama después de que la vista del controlador se haya cargado en la memoria, y se cargan las movies y el index
    override func viewDidLoad() {
        super.viewDidLoad()
        self.moviesDetailsPresenter.getAllMoviesAndIndexPushed()
        
        //<----------- Meter esto en una funcion que pueda acceder desde cualquier sitio
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background_DC_Marvel")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        carousel.configureView(with: carouselData)// Crea el UICollectionViewFlowLayout y lo configura
        carousel.setCurrentPage(currentPage: index)
        addCarouselConstraints()
    }
    
    func configureCarousel() {
        carousel = CarouselView(pages: movies.count, delegate: self, cellDelegate: self)
    }
    
    func addCarouselConstraints() {
        carousel.translatesAutoresizingMaskIntoConstraints = false
        carousel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        carousel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        carousel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        carousel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // Se rellena el array de carouselData con los datos de las movies y se engancha a la vista el carrusel
    func hookCarousel(_ movies: [Movie]) {
        configureCarousel()// Se crea el objeto carrusel
        
        for movie in movies {
            let movieImage = UIImageView()
            let data = CarouselData(image: movieImage.image,text: String(movie.title ?? ""), description: String(movie.description ?? ""), url: movie.image)
            
            carouselData.append(data)
        }
        view.addSubview(carousel)
        addCarouselConstraints()
    }
    
    
    // Una vez se consigue traer las movies, se engancha el carrusel
    func setMovies(_ movies: [Movie]) {
        self.movies = movies
        self.hookCarousel(movies)
    }
    
    // Seteamos el index que nos ha llegado a través del segue y se lo mandamos como currectPage al carrusel
    func setIndex(_ index: Int) {
        self.index = index
        carousel.setCurrentPage(currentPage: index)
    }
    
    func getMoviesDetailsPresenter() -> MoviesDetailsPresenter {
        return self.moviesDetailsPresenter
    }
    
    // Manda los valores a través del segue a la view que definamos
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == identifierSegue, let movie: Movie = sender as? Movie else {
            return
        }
        assignmentValue(segue: segue, movie: movie)
    }
    
    // Asigna los valores
    func assignmentValue(segue: UIStoryboardSegue, movie: Movie) {
        let moreDetailsVC = segue.destination as! MoreDetailsViewController
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.appDependencies.configureMoreDetailsVC(moreDetailsVC)
        }
        let setupData: MoreDetailSetupData = MoreDetailSetupData(movie: movie)
        moreDetailsVC.getMoreDetailsPresenter().setupMoreDetailsView(setupData)
        moreDetailsVC.setMovieMoreDetails(movie)
    }
    
    func enterToMoreDetails() {
        let movie = self.movies[self.index]
        self.performSegue(withIdentifier: "moreDetails", sender: movie)
        
    }
    
    func currentPageChanged(currentPage: Int) {
        self.index = currentPage
    }
    
}

