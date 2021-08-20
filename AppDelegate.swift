import UIKit

@UIApplicationMain  // Punto de entrada de la aplicación
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    let appDependencies = AppDependencies()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        appDependencies.installRootViewControllerIntoWindow(window!) // Se inyectan las dependencias
        
        return true
    }
}

