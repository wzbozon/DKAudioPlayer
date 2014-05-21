#DKAudioPlayer

Audio player component for iOS (both iPhone and iPad) with neat and flexible interface design. It can be added as a header view to the table view.

##GIF demo

<p align="center"><img src="https://github.com/wzbozon/DKAudioPlayer/blob/master/audioplayer.gif?raw=true"></p>

##Youtube demo
<a href="http://youtu.be/By0qU4dhHZ0">Watch</a>

##ScreenShot

<p align="center"><img src="https://github.com/wzbozon/DKAudioPlayer/blob/master/SmallScreenshot.png?raw=true"></p>

##Available to be added via CocoaPods
```
pod DKAudioPlayer
```

##How to use

There is a sample project of a universal app for iPhone and iPad. Player can stretch to the width of a parent View Controller.

First you create an instance of a player object: 
```
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:@"sample.mp3" ofType:nil];
    
    if ( audioFilePath ) {
        
        // The width of a player is equal to the width of a parent view
        _audioPlayer = [[DKAudioPlayer alloc] initWithAudioFilePath:audioFilePath width:self.view.frame.size.width height:0];
        
        // Setting the origin of an audio player
        CGRect frame = _audioPlayer.frame;
        frame.origin = CGPointMake(0, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height);
        _audioPlayer.frame = frame;
        
        // Adding player on a view
        [self.view addSubview:_audioPlayer];
    }
}
```

Then on some action you can just show or hide the player: 
```
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (! _audioPlayer.isVisible) {
        [self.audioPlayer showAnimated:YES];
    }
}


- (IBAction)showHideClicked:(id)sender
{
    if (_audioPlayer.isVisible) {
        [_audioPlayer hideAnimated:YES];
    }
    else {
        [_audioPlayer showAnimated:YES];
    }
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

