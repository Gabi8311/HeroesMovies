import UIKit
import SDWebImage

final class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MoviesVCProtocol {// Implementamos el protocol MoviesVCProtocol
    
    private var moviesPresenter: MoviesPresenter!
    private var movies: [Movie] = []
    private var movie: Movie?
    private let identifierSegue = "sendMovie"
    
    @IBOutlet private weak var moviesTableView: UITableView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBAction func refreshClicked(_ sender: UIButton) {// "onClick" del botón refresh
        refreshButton.bounce()
        refreshButton.shine()
        moviesPresenter.loadMovies()
    }
    
    // Se crea este setter para setear al MoviesViewController el nuevo Presenter desde appDependencies
    func setMoviePresenter(_ moviesPresenter: MoviesPresenter){
        self.moviesPresenter = moviesPresenter
    }
    
    // Customizando el botón de refresh
    func customRefreshButton(_ button: UIButton) {
        self.refreshButton.backgroundColor = UIColor .lightGray
        self.refreshButton.layer.cornerRadius = 8
        self.refreshButton.layer.shadowColor = UIColor .darkGray.cgColor
        self.refreshButton.layer.shadowOpacity = 0.8
        self.refreshButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.refreshButton.layer.borderWidth = 2
        self.refreshButton.layer.borderColor = UIColor .white.cgColor
        self.refreshButton.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
    }
    
    // Se llama después de que la vista del controlador se haya cargado en la memoria
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesTableView.tableFooterView = UIView()// Se muestra bajo el contenido de la tabla
        moviesTableView.dataSource = self;
        moviesPresenter.loadMovies()
        customRefreshButton(self.refreshButton)
    }
    
    // Número de celdas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    // Formato de las celdas
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifierCell, for: indexPath) as! MovieTableViewCell

        let movie:Movie = movies[indexPath.row]
        cell.setMovieAndImage(title: movie.title ?? "", image: movie.image ?? "")
        
        return cell
    }
    
    // Se manda la movie y el index de la celda pulsada a través del segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == identifierSegue,
              let cell = sender as? UITableViewCell,
              let indexPath = self.moviesTableView.indexPath(for: cell) else {
            return
        }
        cell.bounce()//<-- La cell con animation
        assignmentOfValues(segue: segue, indexPath: indexPath)
    }
    
    // Asigna los valores
    func assignmentOfValues(segue: UIStoryboardSegue, indexPath: IndexPath) {
        let detailsVC = segue.destination as! MoviesDetailsViewController
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.appDependencies.configureMovieDetailsVC(detailsVC)
        }
        let setupData: MovieDetailSetupData = MovieDetailSetupData(movies: movies, index: indexPath.row)
        detailsVC.getMoviesDetailsPresenter().setupView(setupData)
    }
    
    // Funciones implementadas del MoviesVCProtocol
    func showMovies(movies: [Movie]) {
        self.movies = movies
        self.moviesTableView.reloadData()
    }
    
    func clearMovies() {
        self.movies.removeAll()
        self.moviesTableView.reloadData()
    }
    
    func showLoadingText() {
        self.titleLabel.text = "Loading ..."
    }
    
    func showNumberOfMovies(numberOfMovies: Int) {
        self.titleLabel.text = "Movies: " + String(numberOfMovies)
    }
    
}

