#DKAudioPlayer

Audio player component for iOS (both iPhone and iPad) with neat and flexible interface design. 

##ScreenShot

<p align="center"><img src="https://github.com/wzbozon/DKAudioPlayer/blob/master/SmallScreenshot.png?raw=true"></p>

##How to use

There is a sample project of a universal app for iPhone and iPad. Player can stretch to the width of a parent View Controller.

First you create an instance of a player object: 
```
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:@"sample.mp3" ofType:nil];
    
    if ( audioFilePath ) {
        self.audioPlayer = [[DKAudioPlayer alloc] initWithAudioFilePath:audioFilePath parentViewController:self];
    }
}
```

Then on some action you can just show or hide the player: 
```
if (_audioPlayer.isVisible) {
        [_audioPlayer hideAnimated:YES];
    }
    else {
        [_audioPlayer showAnimated:YES];
    }
```

It works in background if you add this to your application plist file: 

Required background modes = App plays audio or streams audio/video using AirPlay

```
<key>UIBackgroundModes</key>
<array>
<string>audio</string>
</array>
```

###Supported iOS Versions 
It supports iOS 6.1 and higher. 

###Supported Orientations 
It supports both vertical and horizontal orientations. 

##More ScreenShots
###iPhone

<p align="center"><img src="https://github.com/wzbozon/DKAudioPlayer/blob/master/iPhoneScreenshot.png?raw=true"></p>

###iPad

<p align="center"><img src="https://github.com/wzbozon/DKAudioPlayer/blob/master/iPadScreenshot.png?raw=true"></p>

