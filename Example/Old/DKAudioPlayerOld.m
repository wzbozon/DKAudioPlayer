//
//  DKAudioPlayerOld.m
//
//  Created by Denis Kutlubaev on 27.02.14.

#import "DKAudioPlayerOld.h"

@interface DKAudioPlayerOld()

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSString *durationString;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *bubbleView;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *playPauseButton;

@end


@implementation DKAudioPlayerOld

#pragma mark - Initializers

- (instancetype)initWithData:(NSData *)audioData frame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        NSError *error = nil;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
        NSAssert(error == nil, @"Audio not found");

        [self commonSetup];
    }

    return self;
}

- (instancetype)initWithAudioFilePath:(NSString *)audioFilePath frame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        NSAssert(audioFilePath != nil, @"Audio file path cannot be nil");

        NSURL *url = [NSURL fileURLWithPath:audioFilePath];
        NSError *error = nil;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        NSAssert(error == nil, @"Audio file not found");

        [self commonSetup];
    }

    return self;
}

- (void)commonSetup {
    CGFloat playerHeight = self.frame.size.height;
    CGFloat playerWidth = self.frame.size.width;
    CGFloat inset = 15;

    self.audioPlayer.volume = 0.5;
    self.audioPlayer.delegate = self;

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error:nil];

    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];

    self.clipsToBounds = NO;
    self.autoresizesSubviews = YES;
    self.backgroundColor = [UIColor clearColor];

    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.backgroundView];

    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];

    UIImageView *playerBgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"player_player_bg"
                                                                                    inBundle:frameworkBundle
                                                               compatibleWithTraitCollection:nil]
                                                                         stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
    playerBgImageView.frame = CGRectMake(inset, inset, playerWidth - inset * 2, playerHeight - inset * 2);
    playerBgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:playerBgImageView];

    self.playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playPauseButton.autoresizesSubviews = YES;
    self.playPauseButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [self.playPauseButton setImage:[UIImage imageNamed:@"player_play"
                                              inBundle:frameworkBundle
                         compatibleWithTraitCollection:nil]
                          forState:UIControlStateNormal];
    [self.playPauseButton setFrame:CGRectMake(inset, inset, playerHeight - 2 * inset, playerHeight - 2 * inset)];
    [self.playPauseButton addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playPauseButton];

    float originY = playerHeight / 2.0 - 34 / 2;
    float originX = self.playPauseButton.frame.origin.x + self.playPauseButton.frame.size.width + inset;
    CGRect sliderFrame = CGRectMake(originX, originY, self.frame.size.width - originX - inset * 2, 34);
    _slider = [[UISlider alloc] initWithFrame:sliderFrame];
    _slider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_slider setMaximumTrackImage:[[UIImage imageNamed:@"player_progress_bg"
                                              inBundle:frameworkBundle
                         compatibleWithTraitCollection:nil]
                                   resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)]
                         forState:UIControlStateNormal];
    [_slider setMinimumTrackImage:[[UIImage imageNamed:@"player_progress_blue"
                                              inBundle:frameworkBundle
                         compatibleWithTraitCollection:nil]
                                   resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)]
                         forState:UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"player_circle"
                                      inBundle:frameworkBundle
                 compatibleWithTraitCollection:nil]
                  forState:UIControlStateNormal];
    _slider.minimumValue = 0.0;
    _slider.maximumValue = self.audioPlayer.duration;
    [_slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_slider];

    self.bubbleView = [[UIView alloc] initWithFrame:CGRectMake(160, _slider.frame.origin.y - 46 + _slider.frame.size.height / 2, 72, 46)];
    self.bubbleView.backgroundColor = [UIColor clearColor];
    self.bubbleView.frame = [self createCurrentPositionFrame];
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player_bubble"
                                                                                 inBundle:frameworkBundle
                                                            compatibleWithTraitCollection:nil]];
    bubbleImageView.contentMode = UIViewContentModeScaleToFill;
    bubbleImageView.frame = self.bubbleView.bounds;
    [self.bubbleView addSubview:bubbleImageView];
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 72, 11)];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
    self.timeLabel.text = [self calculateCurrentDuration];
    [self.bubbleView addSubview:self.timeLabel];

    self.bubbleView.hidden = YES;
    [self addSubview:self.bubbleView];

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

    self.duration = self.audioPlayer.duration;
}

#pragma mark - Public methods

- (void)play
{
    if (! self.audioPlayer.isPlaying) {
        [self.audioPlayer play];
        self.isBubbleViewVisible = YES;
        [self updatePlayButtonImage];
    }
}

- (void)pause
{
    if (self.audioPlayer.isPlaying) {
        [self.audioPlayer pause];
        [self updatePlayButtonImage];
    }
}

- (void)dismiss
{
    [self.audioPlayer pause];
    self.audioPlayer = nil;
    [self removeFromSuperview];
}

- (void)setVolume:(float)volume
{
    self.audioPlayer.volume = volume;
}

#pragma mark - Private methods

- (void)playOrPause
{
    if (self.audioPlayer.isPlaying) {
        [self pause];
    }
    else {
        [self play];
    }
}

- (void)updatePlayButtonImage
{
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    NSString *imageName = self.audioPlayer.isPlaying ? @"player_pause" : @"player_play";
    [self.playPauseButton setImage:[UIImage imageNamed:imageName
                                          inBundle:frameworkBundle
                     compatibleWithTraitCollection:nil]
                      forState:UIControlStateNormal];
}

- (void)onTimer:(NSTimer *)timer
{

    self.timeLabel.text = [self calculateCurrentDuration];

    [self.slider setValue:self.audioPlayer.currentTime animated:NO];
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
    [self.audioPlayer setCurrentTime:(int)slider.value];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self updatePlayButtonImage];
}

- (void)setIsBubbleViewVisible:(BOOL)isBubbleViewVisible
{
    _isBubbleViewVisible = isBubbleViewVisible;

    self.bubbleView.hidden = ! isBubbleViewVisible;
}

- (NSString *)calculateCurrentDuration
{
    long currentPlaybackTime = self.audioPlayer.currentTime;

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

- (void)setBackgroundViewColor:(UIColor *)backgroundViewColor
{
    _backgroundViewColor = backgroundViewColor;

    self.backgroundView.backgroundColor = backgroundViewColor;
}

@end
