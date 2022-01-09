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
                                                              width:self.audioPlayerContainerView.frame.size.width
                                                             height:self.audioPlayerContainerView.frame.size.height];

    // You can set any background color to the background view of the player
    // self.audioPlayer.backgroundViewColor = [UIColor clearColor];

    // Adding player on a view
    self.audioPlayer.frame = self.audioPlayerContainerView.bounds;
    [self.audioPlayerContainerView addSubview:self.audioPlayer];
}

- (IBAction)showHideButtonTapped:(id)sender {
    self.audioPlayer.hidden = !self.audioPlayer.isHidden;
}

@end
