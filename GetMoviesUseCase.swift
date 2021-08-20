final class GetMoviesUseCase: Callback {
    
    private var main: LaunchingMainThread
    private var secondary: LaunchingSecondaryThread
    private var repository: MoviesRepository
    private var handler: GetMoviesUseCaseHandler?
    
    init(_ moviesRepository: MoviesRepository) {// Se mete el MovieRepository en el constructor
        self.main = LaunchingMainThread()// Se crean los objetos de las clases creadas para abstraer el DispatchQueue
        self.secondary = LaunchingSecondaryThread()
        self.repository = moviesRepository
        self.secondary.setRepository(moviesRepository: self.repository)// Se hace un set del repositorio al hilo secundario(Es el DiskMovie en appDependencies)
        self.main.setCallback(callback: self)// Asignamos el callback por el que se devolveran los datos
    }
    
    func fetchAllMovies(handler: GetMoviesUseCaseHandler) {// Traemos las movies en el hilo secundario, al que pasamos como atributo la función para mostrar las movies en el hilo principal. Lo llama el presenter
        self.handler = handler
        self.secondary.launchGlobal(callbackMain: main)
    }
    
    func loadMovies(movies: [Movie]) {// Muestra las movies en la view con la func de onLoadedMovies de GetMoviesUseCaseHandler
        handler?.onLoadedMovies(movies: movies)
    }
    
}

// Protocolo que carga de movies en la view
protocol GetMoviesUseCaseHandler {
    func onLoadedMovies(movies: [Movie]) -> Void
}
