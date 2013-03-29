//
//  ViewController.h
//  VideoLibrary
//
//  Created by Paul Goldstein on 3/10/13.
//  Copyright (c) 2013 Paul Goldstein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataYouTube.h"

#define kBaseURL @"https://gdata.youtube.com/feeds/api/users/GoldsteinTech/playlists?v=2"
#define kDefaultTableHeaderHeight 30

@interface ViewController : UITableViewController  <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource,UICollectionViewDelegate>


@property NSArray *modelData;
@property NSMutableArray *scrollPositions;
@property (nonatomic,copy) NSString *startURL;
@property (nonatomic,retain) GDataServiceGoogleYouTube *service;
@property (nonatomic, retain) NSMutableArray *playlists;
@property (nonatomic,copy) NSString *baseURL;
@property (nonatomic,copy) NSDictionary *config;
@end
