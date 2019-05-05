//
//  AppDelegate.swift
//  clipboardextention
//
//  Created by Sihnya Fukumura on 2019/05/03.
//  Copyright © 2019 Sihnya Fukumura. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, PasteboardWatcherDelegate {
    @IBOutlet weak var menu: NSMenu!
    private var watcher: PasteboardWatcher!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // check double startup
        if !checkDoubleStartup() {
            exit(0)
        }
        
        // title of this application displayed on menubar
        self.statusItem.button?.title = "cliputiex"
        
        // clipboard polling start
        setInitialChars()
        watcher.startPolling()

        // construct menu
        constructMenu()
    }
    
    // check double startup
    func checkDoubleStartup() -> Bool {
        var returnCode = true
        let bundleId = Bundle.main.bundleIdentifier!
        if NSRunningApplication.runningApplications(withBundleIdentifier: bundleId).count > 1 {
            // show alert
            let alert = NSAlert()
            alert.addButton(withTitle: "OK")
            alert.messageText = "Another copy of cliputiex is already running."
            alert.informativeText = "This copy will now quit."
            alert.alertStyle = NSAlert.Style.critical
            alert.runModal()
            
            // activate the other instance and terminate this instance
            let apps = NSRunningApplication.runningApplications(withBundleIdentifier: bundleId)
            for app in apps {
                if app != NSRunningApplication.current {
                    app.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])
                    break
                }
            }
            NSApp.terminate(nil)
            
            returnCode = false
        }
        
        return returnCode
    }
    
    // defined characters which I want to erase
    func setInitialChars() {
        watcher = PasteboardWatcher(initialChars: ["#", "$"])
        watcher.delegate = self
    }
    
    // change availability of this application
    @objc func changeAvailableState(_ sender: Any?) {
        statusItem.menu?.item(withTitle: "Available")?.state = statusItem.menu?.item(withTitle: "Available")?.state == NSControl.StateValue.on ? NSControl.StateValue.off : NSControl.StateValue.on
    }

    // check availability of this application
    func isAvailable() -> Bool {
        if statusItem.menu?.item(withTitle: "Available")?.state == NSControl.StateValue.on {
            // this application works
            return true
        }else{
            // this application does not work
            return false
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // construct menu
    func constructMenu() {
        let menu = NSMenu()
        var menuItem = NSMenuItem(title: "Available", action: #selector(AppDelegate.changeAvailableState(_:)), keyEquivalent: "a")
        menuItem.state = NSControl.StateValue.on
        menu.addItem(menuItem)
        menuItem = NSMenuItem.separator()
        menu.addItem(menuItem)
        menuItem = NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        menu.addItem(menuItem)
        
        statusItem.menu = menu
    }
}
