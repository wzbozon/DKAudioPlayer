//
//  DKAudioPlayer.h
//
//  Created by Dennis Kutlubaev on 27.02.14.

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

// TODO: here are some problems with blinking of a bubble
@property (nonatomic) BOOL isBubbleViewVisible;

/**
 Creates player from NSData and puts it on a parentViewController's view automatically
 */
- (id)initWithData:(NSData *)audioData parentViewController:(UIViewController *)parentViewController;

/**
 Creates player from NSData with a given width, but doesn't add it on a parent view automatically
 */
- (id)initWithData:(NSData *)audioData width:(CGFloat)width height:(CGFloat)height;

/**
 Creates player and puts it on a parentViewController's view automatically
 */
- (id)initWithAudioFilePath:(NSString *)audioFilePath parentViewController:(UIViewController *)parentViewController;

/**
 Creates player with a given width, but doesn't add it on a parent view automatically
 */
- (id)initWithAudioFilePath:(NSString *)audioFilePath width:(CGFloat)width height:(CGFloat)height;

/**
 You can programmatically play or pause audio, played in this control
 */
- (void)play;

/**
 Use this method to pause playing audio programmatically
 */
- (void)pause;

- (void)dismiss;

/**
 Use these methods to show or hide player
 */
- (void)showAnimated:(BOOL)animated;

- (void)hideAnimated:(BOOL)animated;

- (void)setVolume:(float)volume;

@end
