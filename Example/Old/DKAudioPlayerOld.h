//
//  DKAudioPlayerOld.h
//
//  Created by Denis Kutlubaev on 27.02.14.

// Add this to your *.plist file to make your audio play in background mode too:
/*
 <key>UIBackgroundModes</key>
 <array>
 <string>audio</string>
 </array>
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

//! Project version number for DKAudioPlayer.
FOUNDATION_EXPORT double DKAudioPlayerVersionNumber;

//! Project version string for DKAudioPlayer.
FOUNDATION_EXPORT const unsigned char DKAudioPlayerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <DKAudioPlayer/PublicHeader.h>

@class DKAudioPlayerOld;
@protocol DKAudioPlayerOldDelegate <NSObject>

- (void)didUpdatePlaybackTimeAudioPlayer:(DKAudioPlayerOld *)audioPlayer;

@end

@interface DKAudioPlayerOld : UIView <AVAudioPlayerDelegate>

@property (nonatomic, weak) id <DKAudioPlayerOldDelegate> delegate;
@property (nonatomic, strong) UIViewController *parentViewController;
@property (nonatomic) BOOL isVisible;
@property (nonatomic, strong) UIColor *backgroundViewColor;

// Current playback time
@property (nonatomic) int currentSecond;

// Duration
@property (nonatomic) long duration;

// TODO: here are some problems with blinking of a bubble
@property (nonatomic) BOOL isBubbleViewVisible;

/**
 Creates player with NSData with a given frame
 */
- (instancetype)initWithData:(NSData *)audioData frame:(CGRect)frame;

/**
 Creates player with audio file path with a given frame
 */
- (instancetype)initWithAudioFilePath:(NSString *)audioFilePath frame:(CGRect)frame;

/**
 You can programmatically play or pause audio, played in this control
 */
- (void)play;

/**
 Use this method to pause playing audio programmatically
 */
- (void)pause;

/**
 Use this method to stop AVAudioPlayer and remove the DKAudioPlayer
 */
- (void)dismiss;

/**
 The audio player’s volume
 This property supports values ranging from 0.0 for silence to 1.0 for full volume.
 */
- (void)setVolume:(float)volume;

@end
