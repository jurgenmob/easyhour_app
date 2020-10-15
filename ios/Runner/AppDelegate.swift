import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey(Constants.GOOGLE_MAPS_API_KEY)
    GeneratedPluginRegistrant.register(with: self)
    if (FirebaseApp.app() == nil) { FirebaseApp.configure() }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
