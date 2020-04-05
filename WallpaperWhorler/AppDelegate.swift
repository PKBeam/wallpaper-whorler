//
//  AppDelegate.swift
//  WallpaperWhorler
//
//  Created by Vincent Liu on 3/9/17.
//  Copyright © 2017 Vincent Liu. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	/** 
	A list of valid image file extensions in order of most to least common.
	*/
	let validImageFormats = [".jpg", ".png", ".jpeg", ".gif", ".tiff", ".tga"]

	/**
	path to search for wallpapers
	*/
    var imagePath = ""
	let defaultPath = NSString(string: "~/Pictures/Wallpapers/").expandingTildeInPath
	
	/**
	Time interval for which to change wallpapers
	*/
    var timerInterval: Double = 20
	let defaultTimerInterval: Double = 20 // Time in minutes
	
	var validWallpapers: [String] = []

	/**
	 Check for valid wallpapers and add them to the valid wallpapers array.
	 - Returns
	An array with the string names of all valid wallpapers.
	 */
	func checkForWallpapers() -> [String] {
		var returnArr: [String] = []

		precondition(FileManager.default.fileExists(atPath: imagePath))

        let contents = try! FileManager.default.contentsOfDirectory(atPath: imagePath)
        for item in contents {
            for format in validImageFormats {
                if item.hasSuffix(format) {
                    returnArr.append(item)
                }
            }
        }

		return returnArr
	}
	
	/** 
	 Choose and set a new wallpaper for the system.
	 */
	
    @objc func changeWallpaper() {
		if validWallpapers.count > 0 {

			// Multi-monitor support
			for screen in NSScreen.screens {
                // Make sure the same wallpaper doesn't get set again
                let prevURL = NSWorkspace.shared.desktopImageURL(for: screen)
                var curURL = prevURL

                repeat {
                    let randomNum = Int(arc4random_uniform(UInt32(validWallpapers.count)))
//                    print(randomNum)
                    let newWallpaperURL = URL(fileURLWithPath: imagePath.appending("/\(validWallpapers[randomNum])"), isDirectory: false)
                    try! NSWorkspace.shared.setDesktopImageURL(newWallpaperURL, for: screen, options: [:])
                    curURL = NSWorkspace.shared.desktopImageURL(for: screen)!

                    // if there's only one wallpaper it'll always be set again
                } while prevURL == curURL && validWallpapers.count > 1
            }
		}
	}

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application

        let prefs = UserDefaults.standard

        // defaults write com.PKBeam.WallpaperWhorler ...
        imagePath = prefs.string(forKey: "imagePath") ?? defaultPath
        timerInterval = prefs.double(forKey: "timerInterval")
        if timerInterval == 0 {
            timerInterval = defaultTimerInterval
        }

		validWallpapers = checkForWallpapers()
		
		/* Change wallpaper before:
			Computer screen goes to sleep
		*/
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(changeWallpaper), name: NSWorkspace.willSleepNotification, object: nil)

		// Change wallpaper periodically
		let timer = Timer.scheduledTimer(timeInterval: timerInterval * 60, target: self, selector: #selector(changeWallpaper), userInfo: nil, repeats: true)
		timer.fire()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		return true
	}
}

