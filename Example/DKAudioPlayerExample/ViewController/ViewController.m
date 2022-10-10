//
//  ViewController.m
//  DKAudioPlayerSample
//
//  Created by Denis Kutlubaev on 17.01.14.

#import "ViewController.h"
@import DKAudioPlayer;

@interface ViewController ()

@property (strong, nonatomic) DKAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIView *audioPlayerContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *audioPlayerContainerViewBottomConstraint;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        self.tabBarItem.title = @"View";
        self.tabBarItem.image = [UIImage imageNamed:@"42-photos"];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAudioPlayer];
}

- (void)setupAudioPlayer {
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:@"sample.mp3" ofType:nil];
    if (!audioFilePath) { return; }

    self.audioPlayer = [[DKAudioPlayer alloc] initWithAudioFilePath:audioFilePath];
    [self.audioPlayerContainerView addSubview:self.audioPlayer];
    self.audioPlayer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.audioPlayerContainerView addConstraints:@[
        [self.audioPlayer.leadingAnchor constraintEqualToAnchor:self.audioPlayerContainerView.leadingAnchor],
        [self.audioPlayer.trailingAnchor constraintEqualToAnchor:self.audioPlayerContainerView.trailingAnchor],
        [self.audioPlayer.bottomAnchor constraintEqualToAnchor:self.audioPlayerContainerView.bottomAnchor],
        [self.audioPlayer.topAnchor constraintEqualToAnchor:self.audioPlayerContainerView.topAnchor]
    ]];
}

- (IBAction)showHideButtonTapped:(id)sender {
    // You can show or hide your player as you want
    // This is just an example
    // When you hide it this way, the music doesn't stop
    // If you want to stop a music, use a dismiss method or pause 
    [UIView animateWithDuration:0.4 animations:^{
        if (self.audioPlayerContainerViewBottomConstraint.constant != 0) {
            self.audioPlayerContainerViewBottomConstraint.constant = 0;
        } else {
            CGFloat bottomInset = self.keyWindow.safeAreaInsets.bottom;
            self.audioPlayerContainerViewBottomConstraint.constant = - (self.audioPlayerContainerView.bounds.size.height + bottomInset);
        }
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

- (UIWindow *)keyWindow {
    UIWindow *foundWindow = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];

    for (UIWindow *window in windows) {
        if (window.isKeyWindow) {
            foundWindow = window;
            break;
        }
    }

    return foundWindow;
}

@end
