import UIKit

final class MoreDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MoreDetailsViewProtocol {
    
    private var moreDetailsPresenter: MoreDetailsPresenter!
    private var movie: Movie?
    private var timer: Timer?
    private var currentCellIndex = 0
    
    @IBOutlet weak var logoCompany: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelYear: UILabel!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var filmImages: UICollectionView!
    
    // Se llama esta func desde el appDependencies() que inyecta el presenter
    func setMoreDetailsPresenter(_ moreDetailsPresenter: MoreDetailsPresenter) {
        self.moreDetailsPresenter = moreDetailsPresenter
    }
    
    // Se llama después de que la vista del controlador se haya cargado en la memoria
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = self.movie {// <--- ESto está bien??
            self.setValues(movie)// TODO: --> Quitar los ! de Aquí
            setBackgroundImage((movie), contentMode: UIView.ContentMode.scaleAspectFill)
            startTimer()
        } else {
            return
        }
        movieTitle.moving(self)
    }
    
    // Setear la imagen del Background
    func setBackgroundImage(_ movie: Movie, contentMode: UIView.ContentMode) {
        let backgroundImage = UIImageView(frame: self.view.bounds)
        
        // Ternario
        backgroundImage.image = movie.company == "Marvel" ? UIImage(named: "background_Marvel") : UIImage(named: "background_DC")
        
        backgroundImage.contentMode = contentMode
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func getMoreDetailsPresenter() -> MoreDetailsPresenter {
        return self.moreDetailsPresenter
    }
    
    func setMovieMoreDetails(_ movie: Movie) {
        self.movie = movie
    }
    
    func setValues(_ movie: Movie) {
        self.logoCompany.image = UIImage(named: movie.company ?? "")
        self.movieTitle.text = movie.title
        self.labelDuration.text = "Duration: \(movie.duration ?? "")"
        self.labelYear.text = "Year: \(movie.year ?? "")"
        self.labelRating.text = "Rating: \(movie.rating ?? "")"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = .zero
        layout.itemSize = CGSize(width: 250, height: 250)
        layout.scrollDirection = .horizontal
        
        filmImages.collectionViewLayout = layout
        filmImages.dataSource = self
        filmImages.delegate = self
        filmImages.register(FilmImageCVCell.self, forCellWithReuseIdentifier: FilmImageCVCell.cellCVId)
        filmImages.backgroundColor = UIColor.clear
    }
    
    // Número de items del CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie?.filmImages.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let filmCell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmImageCVCell.cellCVId, for: indexPath) as? FilmImageCVCell else {
            
            return UICollectionViewCell()
        }
        
        filmCell.configureCell(movie?.filmImages[indexPath.row] ?? "")
        
        return filmCell
    }
    
    // Contador de tiempo del Slider
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
    }
    
    @objc func moveToNextIndex(){
        if let movie = self.movie, currentCellIndex < movie.filmImages.count - 1 {
            currentCellIndex += 1
        }else{
            currentCellIndex = 0
        }
        
        filmImages.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
}


