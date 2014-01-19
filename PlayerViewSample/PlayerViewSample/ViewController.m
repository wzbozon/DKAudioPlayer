//
//  ViewController.m
//  DKAudioPlayerSample
//
//  Created by Dennis Kutlubaev on 17.01.14.
//  Copyright (c) 2014 Alwawee. All rights reserved.
//

#import "ViewController.h"
#import "DKAudioPlayer.h"

@interface ViewController ()

@property (strong, nonatomic) DKAudioPlayer *audioPlayer;

- (IBAction)showHideClicked:(id)sender;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:@"sample.mp3" ofType:nil];
    
    if ( audioFilePath ) {
        self.audioPlayer = [[DKAudioPlayer alloc] initWithAudioFilePath:audioFilePath parentViewController:self];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.audioPlayer showAnimated:YES];
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
