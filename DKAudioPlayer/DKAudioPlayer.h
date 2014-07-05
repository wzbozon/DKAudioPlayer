//
//  DKAudioPlayer.h
//
//  Created by Dennis Kutlubaev on 27.02.14.
//  This code is distributed under the terms and conditions of the MIT license.
//  Copyright (c) 2014 Dennis Kutlubaev (kutlubaev.denis@gmail.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
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

// TODO: here are some problems with blinking of a bubble
@property (nonatomic) BOOL isBubbleViewVisible;

// Creates player and puts it on a parentViewController's view automatically
- (id)initWithAudioFilePath:(NSString *)audioFilePath parentViewController:(UIViewController *)parentViewController;

// Creates player with a given width, but doesn't add it on a parent view automatically
- (id)initWithAudioFilePath:(NSString *)audioFilePath width:(CGFloat)width height:(CGFloat)height;

// You can programmatically play or pause audio, played in this control
- (void)play;

// Use this method to pause playing audio programmatically
- (void)pause;

- (void)dismiss;

// Use these methods to show or hide player
- (void)showAnimated:(BOOL)animated;

- (void)hideAnimated:(BOOL)animated;

@end
