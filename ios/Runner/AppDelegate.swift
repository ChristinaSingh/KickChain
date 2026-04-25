import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Handle deep link redirect from wallet apps back to KickChain
    override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        // Log the incoming URL for debugging
        print("📱 AppDelegate received URL: \(url.absoluteString)")

        // Let Flutter plugins handle the URL
        if super.application(app, open: url, options: options) {
            return true
        }

        // Handle custom scheme manually if needed
        if url.scheme == "kickchain" || url.scheme == "wc" {
            // The reown_appkit plugin will automatically handle this
            return true
        }

        return false
    }

    // Handle Universal Links (https://)
    override func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {

        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let url = userActivity.webpageURL {
            print("📱 AppDelegate received Universal Link: \(url.absoluteString)")

            // Let Flutter plugins handle universal links
            return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
        }

        return false
    }
}