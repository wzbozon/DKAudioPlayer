//
//  DKAudioPlayer.h
//
//  Created by Dennis Kutlubaev on 17.01.14.
//


// Add this to your *.plist file to make your audio play in background mode too:
/*
<key>UIBackgroundModes</key>
<array>
<string>audio</string>
</array>
*/


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DKAudioPlayer : UIView <AVAudioPlayerDelegate>

@property (nonatomic, strong) NSString *audioFilePath;
@property (nonatomic, strong) UIViewController *parentViewController;
@property (nonatomic) BOOL isVisible;

// Create your player after view of a parent view controller is loaded in ViewDidLoad method
- (id)initWithAudioFilePath:(NSString *)audioFilePath parentViewController:(UIViewController *)parentViewController;

// You can programmatically play or pause audio, played in this control
- (void)play;

- (void)pause;

- (void)dismiss;

// Use these methods to show or hide player
- (void)showAnimated:(BOOL)animated;

- (void)hideAnimated:(BOOL)animated;

@end
