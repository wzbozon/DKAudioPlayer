//
//  TableViewController.m
//  DKAudioPlayerExample
//
//  Created by Denis Kutlubaev on 21.05.14.
//
//

#import "TableViewController.h"
#import <DKAudioPlayer/DKAudioPlayer.h>

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
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // By default first audio file is set up to play
    [self setAudioPlayerForFileName:_tableData[0]];
}

// The logic is to reinitialize audioplayer for each file, this is not optimal, but simple solution
- (void)setAudioPlayerForFileName:(NSString *)fileName
{
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    
    if ( audioFilePath ) {

        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 90)];
        self.audioPlayer = [[DKAudioPlayer alloc] initWithAudioFilePath:audioFilePath width:containerView.bounds.size.width height:75];
        
        // Setting the origin of an audio player
        CGRect frame = self.audioPlayer.frame;
        frame.origin = CGPointMake(0, 15);
        self.audioPlayer.frame = frame;
        
        // TODO: here are some problems with blinking of a bubble
        self.audioPlayer.isBubbleViewVisible = YES;

        containerView.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];
        [containerView addSubview:self.audioPlayer];
        
        // Adding player on a view
        self.tableView.tableHeaderView = containerView;
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
    [self.audioPlayer dismiss];
    
    // Setting audio player as a table header view for current file
    [self setAudioPlayerForFileName:_tableData[indexPath.row]];
    
    // Automatically staring playing that file
    [self.audioPlayer play];
}

@end
