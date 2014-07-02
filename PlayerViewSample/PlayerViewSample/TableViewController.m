//
//  TableViewController.m
//  PlayerViewSample
//
//  Created by Dennis Kutlubaev on 21.05.14.
//
//

#import "TableViewController.h"
#import "DKAudioPlayer.h"

@interface TableViewController ()

@property (strong, nonatomic) DKAudioPlayer *audioPlayer;
@property (strong, nonatomic) NSArray *tableData;

@end


@implementation TableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.tabBarItem.title = @"Table View";
        self.tabBarItem.image = [UIImage imageNamed:@"259-list"];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // List of audio file names
    _tableData = @[@"sample.mp3", @"sample1.mp3", @"sample2.mp3"];
    
    // By default first audio file is set up to play
    [self setAudioPlayerForFileName:_tableData[0]];
}


// The logic is to reinitialize audioplayer for each file, this is not optimal, but simple solution
- (void)setAudioPlayerForFileName:(NSString *)fileName
{
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    
    if ( audioFilePath ) {
        
        // The width of a player is equal to the width of a parent view
        // TODO: here are some problems with a size of a player (I had to make it bigger to make bubble visible since bubble is not inside player by default)
        _audioPlayer = [[DKAudioPlayer alloc] initWithAudioFilePath:audioFilePath width:self.view.frame.size.width height:90.0 backgroundColor:[UIColor clearColor]];
        
        // Setting the origin of an audio player
        CGRect frame = _audioPlayer.frame;
        frame.origin = CGPointMake(0, _audioPlayer.frame.size.height);
        _audioPlayer.frame = frame;
        
        // TODO: here are some problems with blinking of a bubble
        _audioPlayer.isBubbleViewVisible = YES;
        
        // Adding player on a view
        self.tableView.tableHeaderView = _audioPlayer;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ( cell == nil ) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    cell.textLabel.text = _tableData[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Removing current audioplayer
    [_audioPlayer dismiss];
    
    // Setting audio player as a table header view for current file
    [self setAudioPlayerForFileName:_tableData[indexPath.row]];
    
    // Automatically staring playing that file
    [_audioPlayer play];
}



@end
