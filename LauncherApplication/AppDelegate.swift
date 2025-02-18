//
//  AppDelegate.swift
//  LauncherApplication
//
//  Created by Thanh Nguyen on 1/28/19.
//  Copyright © 2019 Dwarves Foundation. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @objc func terminate() {
        NSApp.terminate(nil)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mainAppIdentifier = "com.dwarvesv.minimalbar"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == mainAppIdentifier }.isEmpty
        
        if !isRunning {
            DistributedNotificationCenter.default().addObserver(
                self,
                selector: #selector(self.terminate),
                name: Notification.Name("killLauncher"),
                object: mainAppIdentifier
            )
            
            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast(3)
            components.append("MacOS")
            let appName = "Hidden Bar" // main app name
            components.append(appName)
            let newPath = NSString.path(withComponents: components)
            let newPathURL = URL(fileURLWithPath: newPath)
            
            // Use NSWorkspace.OpenConfiguration to hide and not activate the app
            let configuration = NSWorkspace.OpenConfiguration()
            configuration.hides = true
            configuration.activates = false
            
            do {
                try NSWorkspace.shared.openApplication(at: newPathURL, configuration: configuration)
            } catch {
                print("Error launching app: \(error)")
            }
        } else {
            self.terminate()
        }
    }
    
    
}

