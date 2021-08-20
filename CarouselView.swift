import UIKit

final class CarouselView: UIView {
    
    // MARK: - Subviews
    
    // Se configura el UICollectionView
    private lazy var carouselCollectionView: UICollectionView = {// lazy -> Sólo se ejecuta cuando se llama
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.dataSource = self
        collection.delegate = self
        collection.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.cellId)
        collection.backgroundColor = .clear
        
        return collection
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .darkGray
        
        return pageControl
    }()
    
    // MARK: - Properties
    
    private weak var delegateCarouselCell: DelegateMoreDetailsProtocol?
    private weak var delegate: CarouselViewDelegate?
    private var carouselData = [CarouselData]()
    private var pages: Int
    private var currentPage = 0 {
        didSet {// Observador -> Cuando cambia el valor realiza lo que está dentro de las llaves
            pageControl.currentPage = currentPage
        }
    }
    
    // MARK: - Initializers
    
    init(pages: Int, delegate: CarouselViewDelegate?, cellDelegate: DelegateMoreDetailsProtocol) {
        self.pages = pages
        self.delegate = delegate
        self.delegateCarouselCell = cellDelegate
        
        super.init(frame: .zero)// La propiedad frame representa el rectángulo relativo a la vista contenedora, mientras que bounds representa el rectángulo relativo a sí mismo.
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCurrentPage(currentPage: Int) {
        self.currentPage = currentPage
        self.carouselCollectionView.scrollToItem(at: IndexPath(item: self.currentPage, section: .zero), at: .centeredHorizontally, animated: false)
    }
    
}

// MARK: - Setups

private extension CarouselView {
    func setupUI() {
        backgroundColor = .clear
        setupCollectionView()
        setupPageControl()
    }
    
    func setupCollectionView() {
        
        let cellPadding = (frame.width - 300) / 2
        let carouselLayout = UICollectionViewFlowLayout()
        // Style
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = .init(width: 400, height: 400)
        carouselLayout.sectionInset = .init(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
        carouselLayout.minimumLineSpacing = cellPadding * 2
        carouselCollectionView.collectionViewLayout = carouselLayout
        
        addSubview(carouselCollectionView)
        // Constraints
        carouselCollectionView.translatesAutoresizingMaskIntoConstraints = false
        carouselCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        carouselCollectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        carouselCollectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        carouselCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -70).isActive = true
    }
    
    func setupPageControl() {
        addSubview(pageControl)
        // Constraints
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.topAnchor.constraint(equalTo: carouselCollectionView.bottomAnchor, constant: 16).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: 150).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        pageControl.numberOfPages = pages
    }
    
}

// MARK: - UICollectionViewDataSource

extension CarouselView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.cellId, for: indexPath) as? CarouselCell else { return UICollectionViewCell() }
        
        let data = carouselData[indexPath.row]
        cell.configure(data: data, delegate: self.delegateCarouselCell)
        
        return cell
    }
    
}

// MARK: - UICollectionView Delegate

extension CarouselView: UICollectionViewDelegate {// Le dice al delegado que la vista de desplazamiento ha terminado de desacelerar el movimiento de desplazamiento
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.currentPageChanged(currentPage: getCurrentPage())
        currentPage = getCurrentPage()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {// Le dice al delegado cuándo finalizó el arrastre en la vista de desplazamiento
        delegate?.currentPageChanged(currentPage: getCurrentPage())
        currentPage = getCurrentPage()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {// Le dice al delegado cuando el usuario se desplaza por la vista de contenido dentro del receptor
        delegate?.currentPageChanged(currentPage: getCurrentPage())
        currentPage = getCurrentPage()
    }
}

// MARK: - Public

extension CarouselView {
    public func configureView(with data: [CarouselData]) {
        let cellPadding = (frame.width - 300) / 2
        let carouselLayout = UICollectionViewFlowLayout()
        // Style
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = .init(width: 300, height: 400)
        carouselLayout.sectionInset = .init(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
        carouselLayout.minimumLineSpacing = cellPadding * 2
        
        carouselCollectionView.collectionViewLayout = carouselLayout
        carouselData = data
        carouselCollectionView.reloadData()
    }
    
}

// MARKK: - Helpers

private extension CarouselView {
    func getCurrentPage() -> Int {
        let visibleRect = CGRect(origin: carouselCollectionView.contentOffset, size: carouselCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = carouselCollectionView.indexPathForItem(at: visiblePoint) {
            return visibleIndexPath.row
        }
        
        return currentPage
    }
    
}

protocol CarouselViewDelegate: AnyObject {
    func currentPageChanged(currentPage: Int)
}
