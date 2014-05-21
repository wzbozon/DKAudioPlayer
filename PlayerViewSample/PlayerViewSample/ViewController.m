//
//  ViewController.m
//  DKAudioPlayerSample
//
//  Created by Dennis Kutlubaev on 17.01.14.

#import "ViewController.h"
#import "DKAudioPlayer.h"


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
        _audioPlayer = [[DKAudioPlayer alloc] initWithAudioFilePath:audioFilePath width:self.view.frame.size.width height:0];
        
        // Setting the origin of an audio player
        CGRect frame = _audioPlayer.frame;
        frame.origin = CGPointMake(0, self.view.frame.size.height - self.tabBarController.tabBar.frame.size.height);
        _audioPlayer.frame = frame;
        
        // Adding player on a view
        [self.view addSubview:_audioPlayer];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (! _audioPlayer.isVisible) {
        [self.audioPlayer showAnimated:YES];
    }
}


- (IBAction)showHideClicked:(id)sender
{
    if (_audioPlayer.isVisible) {
        [_audioPlayer hideAnimated:YES];
    }
    else {
        [_audioPlayer showAnimated:YES];
    }
}


@end
