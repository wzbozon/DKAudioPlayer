//
//  ViewController.m
//  DKAudioPlayerSample
//
//  Created by Denis Kutlubaev on 17.01.14.

#import "ViewController.h"
#import <DKAudioPlayer/DKAudioPlayer.h>


@interface ViewController ()

@property (strong, nonatomic) DKAudioPlayer *audioPlayer;

- (IBAction)showHideClicked:(id)sender;

@end


@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if ( self ) {
        
        self.tabBarItem.title = @"View";
        self.tabBarItem.image = [UIImage imageNamed:@"42-photos"];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:@"sample.mp3" ofType:nil];
    
    if ( audioFilePath ) {
        
        // The width of a player is equal to the width of a parent view
        self.audioPlayer = [[DKAudioPlayer alloc] initWithAudioFilePath:audioFilePath width:self.view.frame.size.width height:0];

        // You can set any background color to the background view of the player
        //self.audioPlayer.backgroundViewColor = [UIColor clearColor];
        
        // Setting the origin of an audio player
        CGRect frame = self.audioPlayer.frame;
        frame.origin = CGPointMake(0, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height);
        self.audioPlayer.frame = frame;
        
        // Adding player on a view
        [self.view addSubview:self.audioPlayer];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (! self.audioPlayer.isVisible) {
        [self.audioPlayer showAnimated:YES];
    }
}

- (IBAction)showHideClicked:(id)sender
{
    self.audioPlayer.hidden = !self.audioPlayer.isHidden;
}

@end
