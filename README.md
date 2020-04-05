# wallpaper-whorler
A macOS application that periodically changes your desktop background image.

This only sets the image for the first Desktop in each of your screens - this is a limitation of the public API.

## Setting Preferences
This application runs entirely in the background without any UI.

You can change the wallpaper directory and the interval (in minutes) at which the wallpaper is changed in the Terminal.

`% defaults read com.PKBeam.WallpaperWhorler`

`% defaults write com.PKBeam.WallpaperWhorler imagePath "..."`

`% defaults write com.PKBeam.WallpaperWhorler timerInterval ...`
