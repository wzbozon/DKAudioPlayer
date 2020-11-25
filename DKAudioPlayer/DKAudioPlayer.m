//
//  DKAudioPlayer.m
//
//  Created by Dennis Kutlubaev on 27.02.14.

#import "DKAudioPlayer.h"

#define RGBA(rgbValue, opacity) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:opacity]

#define RGB(rgbValue) RGBA(rgbValue, 1.0)

#define IS_IOS7_OR_HIGHER !([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending)

@interface DKAudioPlayer()
{
    AVAudioPlayer *_audioPlayer;

    float _playerHeight;
    float _playerWidth;
    float _inset;

    UIButton *_playPauseButton;
}

@property (nonatomic, strong) NSString *durationString;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *bubbleView;
@property (nonatomic, strong) UISlider *slider;

@end


@implementation DKAudioPlayer

- (instancetype)initWithData:(NSData *)audioData parentViewController:(UIViewController *)parentViewController
{
    // initalize audio player from nsData
    [self initAudioPlayerWithData:audioData];

    // initialize DKAudio with view controller
    self = [self initWithViewController:parentViewController];

    return self;
}

- (instancetype)initWithData:(NSData *)audioData width:(CGFloat)width height:(CGFloat)height
{
    // initalize audio player from nsData
    [self initAudioPlayerWithData:audioData];

    // initialize DK player with width and height
    self = [self initWithWidth:width height:height];

    return self;
}

- (instancetype)initWithAudioFilePath:(NSString *)audioFilePath parentViewController:(UIViewController *)parentViewController
{
    // initialize audio player from NSString
    [self initAudioPlayerWithString:audioFilePath];

    // initialize DKAudio with view controller
    self = [self initWithViewController:parentViewController];

    return self;
}

- (instancetype)initWithAudioFilePath:(NSString *)audioFilePath width:(CGFloat)width height:(CGFloat)height
{
    // initialize audio player from NSString
    [self initAudioPlayerWithString:audioFilePath];

    // initialize DK player with width and height
    self = [self initWithWidth:width height:height];

    return self;
}

- (instancetype)initWithViewController:(UIViewController *) parentViewController
{
    CGRect frame = CGRectMake(0, 0, parentViewController.view.bounds.size.width, 75.0);

    // initialize DK player with width and height
    self = [self initWithWidth:frame.size.width height:frame.size.height];

    frame.origin.y = parentViewController.view.bounds.size.height;
    self.frame = frame;
    [parentViewController.view addSubview:self];
    [parentViewController.view bringSubviewToFront:self];

    return self;
}

- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height
{
    if (height == 0) height = 75.0;

    CGRect frame = CGRectMake(0, 0, width, height);

    self = [super initWithFrame:frame];

    if (self) {

        _playerHeight = frame.size.height;
        _playerWidth = frame.size.width;
        _inset = 15;


        _audioPlayer.volume = 0.5;
        _audioPlayer.delegate = self;


        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error:nil];

        long totalPlaybackTime = _audioPlayer.duration;
        int tHours = (int)(totalPlaybackTime / 3600);
        int tMins = (int)((totalPlaybackTime/60) - tHours*60);
        int tSecs = (int)(totalPlaybackTime % 60 );
        _durationString = (tHours > 0) ? [NSString stringWithFormat:@"%i:%02d:%02d", tHours, tMins, tSecs ] : [NSString stringWithFormat:@"%02d:%02d", tMins, tSecs];

        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];

        self.clipsToBounds = NO;
        self.autoresizesSubviews = YES;
        self.backgroundColor = [UIColor clearColor];

        UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor = RGB(0xe8e8e8);
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:backgroundView];

        UIImageView *playerBgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"player_player_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
        playerBgImageView.frame = CGRectMake(_inset, _inset, _playerWidth - _inset * 2, _playerHeight - _inset * 2);
        playerBgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:playerBgImageView];

        _playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playPauseButton.autoresizesSubviews = YES;
        _playPauseButton.imageView.contentMode = UIViewContentModeScaleToFill;
        [_playPauseButton setImage:[UIImage imageNamed:@"player_play"] forState:UIControlStateNormal];
        [_playPauseButton setFrame:CGRectMake(_inset, _inset, _playerHeight - 2 * _inset, _playerHeight - 2 * _inset)];
        [_playPauseButton addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playPauseButton];

        float originY = _playerHeight / 2.0 - 34 / 2;
        float originX = _playPauseButton.frame.origin.x + _playPauseButton.frame.size.width + _inset;
        CGRect sliderFrame = CGRectMake(originX, originY, frame.size.width - originX - _inset * 2, 34);
        _slider = [[UISlider alloc] initWithFrame:sliderFrame];
        _slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        if ( ! IS_IOS7_OR_HIGHER ) {
            [_slider setMaximumTrackImage:[[UIImage imageNamed:@"player_progress_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)]  forState:UIControlStateNormal];
            [_slider setMinimumTrackImage:[[UIImage imageNamed:@"player_progress_blue"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)]  forState:UIControlStateNormal];
        }
        [_slider setThumbImage:[UIImage imageNamed:@"player_circle"] forState:UIControlStateNormal];
        _slider.minimumValue = 0.0;
        _slider.maximumValue = _audioPlayer.duration;
        [_slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_slider];

        _bubbleView = [[UIView alloc] initWithFrame:CGRectMake(160, _slider.frame.origin.y - 46 + _slider.frame.size.height / 2, 72, 46)];
        _bubbleView.backgroundColor = [UIColor clearColor];
        _bubbleView.frame = [self createCurrentPositionFrame];
        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player_bubble"]];
        bubbleImageView.contentMode = UIViewContentModeScaleToFill;
        bubbleImageView.frame = _bubbleView.bounds;
        [_bubbleView addSubview:bubbleImageView];
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 72, 11)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
        _timeLabel.text = [self calculateCurrentDuration];
        [_bubbleView addSubview:_timeLabel];

        _bubbleView.hidden = YES;
        [self addSubview:_bubbleView];

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

        self.duration = _audioPlayer.duration;
    }

    return self;
}

- (void)initAudioPlayerWithData:(NSData *)audioData
{
    NSError *error = nil;
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
    NSAssert(error == nil, @"Audio not found");
}

- (void)initAudioPlayerWithString:(NSString *)audioFilePath
{
    _audioFilePath = audioFilePath;
    NSAssert(audioFilePath != nil, @"Audio file path cannot be nil");

    NSURL *url = [NSURL fileURLWithPath:audioFilePath];
    NSError *error = nil;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    NSAssert(error == nil, @"Audio file not found");
}

- (void)playOrPause
{
    if (_audioPlayer.isPlaying) {
        [self pause];
    }
    else {
        [self play];
    }
}

- (void)play
{
    if (! _audioPlayer.isPlaying) {
        [_audioPlayer play];
        self.isBubbleViewVisible = YES;
        [self updatePlayButtonImage];
    }
}

- (void)pause
{
    if (_audioPlayer.isPlaying) {
        [_audioPlayer pause];
        [self updatePlayButtonImage];
    }
}

- (void)setVolume:(float)volume
{
    _audioPlayer.volume = volume;
}

- (void)updatePlayButtonImage {
    NSString *imageName = _audioPlayer.isPlaying ? @"player_pause" : @"player_play";
    [_playPauseButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)onTimer:(NSTimer *)timer
{

    self.timeLabel.text = [self calculateCurrentDuration];

    [self.slider setValue:_audioPlayer.currentTime animated:NO];
    self.bubbleView.frame = [self createCurrentPositionFrame];
}

- (float)xPositionFromSliderValue:(UISlider *)aSlider;
{
    float sliderRange = aSlider.frame.size.width - aSlider.currentThumbImage.size.width;
    float sliderOrigin = aSlider.frame.origin.x + (aSlider.currentThumbImage.size.width / 2.0);

    float sliderValueToPixels = ((aSlider.value-aSlider.minimumValue)/(aSlider.maximumValue-aSlider.minimumValue) * sliderRange) + sliderOrigin;

    return sliderValueToPixels;
}

- (void)sliderChanged:(UISlider *)slider
{
    [_audioPlayer setCurrentTime:(int)slider.value];
}

- (void)hideAnimated:(BOOL)animated
{
    _isVisible = NO;

    [self changeToVisible:_isVisible animated:animated];
}

- (void)showAnimated:(BOOL)animated
{
    _isVisible = YES;

    [self changeToVisible:_isVisible animated:animated];
}

- (void)changeToVisible:(BOOL)visible animated:(BOOL)animated
{
    CGRect playerFrame = self.frame;
    CGRect parentFrame = self.parentViewController.view.bounds;
    CGFloat bottomPadding = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        bottomPadding = window.safeAreaInsets.bottom;
    }

    if (visible) {
        playerFrame.origin.y -= (_playerHeight + bottomPadding);
        parentFrame.size.height -= (_playerHeight + bottomPadding);
        _bubbleView.hidden = NO;
    }
    else {
        playerFrame.origin.y += (_playerHeight + bottomPadding);
        parentFrame.size.height += (_playerHeight + bottomPadding);
        _bubbleView.hidden = YES;
    }

    if (animated) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

            self.frame = playerFrame;

        } completion:^(BOOL finished){

        }];
    }
    else {
        self.frame = playerFrame;
    }
}

- (void)dismiss
{
    _audioPlayer = nil;
    [self removeFromSuperview];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self updatePlayButtonImage];
}

- (void)setIsBubbleViewVisible:(BOOL)isBubbleViewVisible
{
    _isBubbleViewVisible = isBubbleViewVisible;

    _bubbleView.hidden = ! isBubbleViewVisible;
}

- (NSString *)calculateCurrentDuration
{
    long currentPlaybackTime = _audioPlayer.currentTime;

    self.currentSecond = (int)currentPlaybackTime;
    
    int currentHours = (int)(currentPlaybackTime / 3600);
    int currentMinutes = (int)((currentPlaybackTime / 60) - currentHours*60);
    int currentSeconds = (int)(currentPlaybackTime % 60);
    NSString *currentTimeString = (currentHours > 0) ? [NSString stringWithFormat:@"%i:%02d:%02d", currentHours, currentMinutes, currentSeconds] : [NSString stringWithFormat:@"%02d:%02d", currentMinutes, currentSeconds];

    [self.delegate didUpdatePlaybackTimeAudioPlayer:self];
    
    return [NSString stringWithFormat:@"%@ / %@", currentTimeString, self.durationString];
}

- (CGRect)createCurrentPositionFrame
{
    CGRect frame = self.bubbleView.frame;
    frame.origin.x = [self xPositionFromSliderValue:self.slider] - self.bubbleView.frame.size.width / 2.0;
    return frame;
}

@end
