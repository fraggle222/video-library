//
//  ViewController.m
//  VideoLibrary
//
//  Created by Paul Goldstein on 3/10/13.
//  Copyright (c) 2013 Paul Goldstein. All rights reserved.
//  credit to Dan Messing for code on saving the collectionView offsets approach
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "GDataYouTube.h"
#import "TableCell.h"
#import "CollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "VideoPlayController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.playlists=[[NSMutableArray alloc] initWithObjects:nil];
    
    
	self.tableView.backgroundColor = [UIColor blackColor];
	self.tableView.separatorColor = [UIColor blackColor]; //TBD get colors from config file
	
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
   
    self.config = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]];
   
    [self setupUrl];
    
    [self setupTitle];
		
	[self resetScrollPositions];
    
    [self execute];
}

-(void) setupTitle {

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];  
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; //TBD: get colors from config file
    label.text = NSLocalizedString([self.config objectForKey:@"main_title"], @"title bar");
    [label sizeToFit];
    self.navigationItem.titleView = label;
    
}

-(void) setupUrl {
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:
            [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]];
    
    self.baseURL=[data objectForKey:@"baseURL"];
    if(self.baseURL==nil) {
        self.baseURL=kBaseURL;
        NSLog(@"using default url");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) resetScrollPositions {
    
    self.scrollPositions = [NSMutableArray new];
	for ( int i = 0; i < self.playlists.count; i++ )
	{
		[self.scrollPositions addObject:@0];
	}
}

-(void) execute {
    self.service= [[GDataServiceGoogleYouTube alloc] init];
    NSURL *feedURL=[[NSURL alloc] initWithString:kBaseURL];
    [self.service fetchFeedWithURL:feedURL
                     delegate:self
            didFinishSelector:@selector(entryListFetchPlaylists:finishedWithFeed:error:)];
}

/*
 This method isn't being used anymore but is an alternative to using the GData classes from Google. Simpler, although authentication would be harder.
 */
-(void) executeJsonAPI {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&alt=json",kBaseURL]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"class=%@",[JSON class]);
        NSLog(@"class=: %@", [[JSON valueForKeyPath:@"feed.entry.title"] class]);
        NSLog(@"Json=: %@", [JSON valueForKeyPath:@"feed.entry.title.$t"]);
        NSLog(@"Json=: %@", [JSON valueForKeyPath:@"feed.entry.content.src"]);
    } failure:nil];
    
    [operation start];
}

- (void)entryListFetchPlaylists:(GDataServiceTicket *)ticket
            finishedWithFeed:(GDataFeedYouTubeVideo *)feed
                       error:(NSError *)error {
    NSLog(@"@got feed %@",feed.title);

    for(GDataEntryYouTubePlaylistLink *entry in feed.entries) {
        [self.service fetchFeedWithURL:entry.content.sourceURL delegate:self didFinishSelector:@selector(addPlayList:finishedWithFeed:error:)];
        NSLog(@" entry title=%@ and content Url=%@",entry.title.contentStringValue, entry.content.sourceURL);
    }
}


-(void) addPlayList:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedYouTubePlaylist *)playlist error:(NSError *)error{
    NSLog(@"adding %@",playlist.title.contentStringValue);
    [self.playlists addObject:playlist];
    [self.scrollPositions addObject:@0];
    [self.tableView reloadData];
    
    NSLog(@"videos in playlist %@",playlist.title.contentStringValue);
    for(GDataFeedYouTubeVideo *video in playlist.entries) {
        NSLog(@"video title=%@",video.title.contentStringValue);
    }
}

-(void) printInfo {
    NSLog(@"printing info...");
    for(GDataFeedYouTubePlaylist *playlist in self.playlists) {
        NSLog(@"videos in playlist %@",playlist.title.contentStringValue);
        for(GDataFeedYouTubeVideo *video in playlist.entries) {
            NSLog(@"video title=%@",video.title.contentStringValue);
        }
    }
    
}

#pragma mark - Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.playlists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return kDefaultTableHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
  
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 28)];
    customView.backgroundColor=[UIColor darkGrayColor];
    
    if(self.playlists.count>section) {
        UILabel *headline = [[UILabel alloc] initWithFrame:CGRectMake(0,0,150,28)];  //TBD: put sizes in config file
        headline.backgroundColor = [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1]; //TBD: get colors from config file
        headline.textColor = [UIColor lightGrayColor]; //TBD: get colors from config file
        headline.font = [UIFont fontWithName:@"Helvetica Neue" size:14]; //TBD: get font info from config file
        headline.text = ((GDataFeedYouTubePlaylist *)self.playlists[section]).title.contentStringValue;
        headline.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
        [customView addSubview:headline];
    }
    
    return customView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //set scroll position of collection view
	cell.collectionView.contentOffset = CGPointMake([self.scrollPositions[indexPath.section] floatValue], 0);
	cell.collectionView.dataSource = self;
    cell.collectionView.delegate=self;
	[cell.collectionView reloadData];
    return cell;
}


//called when the specified cell was removed from the table.
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionView *collectionView = ((TableCell *)cell).collectionView;
	[collectionView setContentOffset:collectionView.contentOffset animated:NO];
    //save the scroll position of the collection view
	[self.scrollPositions replaceObjectAtIndex:indexPath.section withObject:@(collectionView.contentOffset.x)]; 
   
}


#pragma mark - CollectionView Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	UITableViewCell *tableCell = (UITableViewCell *)[[collectionView superview] superview];
	NSUInteger tableRow = [self.tableView indexPathForCell:tableCell].section;
	
	return [[(GDataFeedYouTubePlaylist *)self.playlists[tableRow] entries] count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
	static NSString *CollectionCellIdentifier = @"CollectionCell";
	CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellIdentifier forIndexPath:indexPath];
	UITableViewCell *tableCell = (UITableViewCell *)[[collectionView superview] superview];
	NSUInteger tableRow = [self.tableView indexPathForCell:tableCell].section;
   
    GDataFeedYouTubePlaylist *playlist=self.playlists[tableRow];
    GDataEntryYouTubeVideo *video=playlist.entries[indexPath.row];
    cell.label.text=video.title.contentStringValue;
    
    //this uses AFNetworking to get image
    [cell.imageView setImageWithURL:[NSURL URLWithString:((GDataMediaThumbnail *)[[video mediaGroup] mediaThumbnails][1]).URLString]];
    
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"got click on collection item %i",indexPath.row);
    UITableViewCell *tableCell = (UITableViewCell *)[[collectionView superview] superview];
    NSUInteger tableRow = [self.tableView indexPathForCell:tableCell].section;
    
    GDataFeedYouTubePlaylist *playlist=self.playlists[tableRow];
    GDataEntryYouTubeVideo *video=playlist.entries[indexPath.row];
    VideoPlayController *vp=[[VideoPlayController alloc] initWithNibName:@"VideoPlayController" bundle:nil];
    
    vp.modalPresentationStyle=UIModalTransitionStyleFlipHorizontal;
    vp.url=((GDataMediaContent *)[[video mediaGroup] mediaContents][0]).URLString;
    vp.videoId=[[video mediaGroup] videoID];
    
    [self.navigationController pushViewController:vp animated:YES];
    
}

@end
