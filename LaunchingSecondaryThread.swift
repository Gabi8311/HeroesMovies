import Foundation

final class LaunchingSecondaryThread {// Clase que lanza el hilo secundario
    
    private var repository: MoviesRepository?
    private var movies: [Movie] = []
    
    func launchGlobal(callbackMain: CallbackMain) -> Void { // Se lanza el hilo secundario donde se cargan las movies
        DispatchQueue.global(qos: .background).async {
            callbackMain.launchMain(self.repository?.getMovies() ?? [])// LLama al hilo main pasándole el repositorio de movies
        }
    }
    
    func setRepository(moviesRepository: MoviesRepository) -> Void {
        self.repository = moviesRepository
    }
}

protocol CallbackMain {
    func launchMain(_ movies: [Movie]) -> Void
}
