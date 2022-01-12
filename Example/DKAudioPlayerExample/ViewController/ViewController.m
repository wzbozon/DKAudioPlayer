//
//  ViewController.m
//  DKAudioPlayerSample
//
//  Created by Denis Kutlubaev on 17.01.14.

#import "ViewController.h"
#import <DKAudioPlayer/DKAudioPlayer.h>

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
    
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:@"sample.mp3" ofType:nil];
    if (!audioFilePath) { return; }

    // The width of a player is equal to the width of a parent view
    self.audioPlayer = [[DKAudioPlayer alloc] initWithAudioFilePath:audioFilePath
                                                              frame:self.audioPlayerContainerView.frame];

    // You can set any background color to the background view of the player
    // self.audioPlayer.backgroundViewColor = [UIColor clearColor];

    // Adding player on a view
    self.audioPlayer.frame = self.audioPlayerContainerView.bounds;
    [self.audioPlayerContainerView addSubview:self.audioPlayer];
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
