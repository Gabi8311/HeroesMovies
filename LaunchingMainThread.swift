import Foundation

final class LaunchingMainThread: CallbackMain {// Clase para lanzar el hilo principal
    
    private var callback: Callback?
    
    func launchMain(_ movies: [Movie]) {// Se lanza el hilo principal que carga las movies en la view
        DispatchQueue.main.async {
            self.callback?.loadMovies(movies: movies)
        }
    }
    
    func setCallback(callback: Callback) {// Se hace el setHandler para setear el GetMoviesUseCaseHandler
        self.callback = callback
    }
    
}

protocol Callback {
    func loadMovies(movies: [Movie])
}

