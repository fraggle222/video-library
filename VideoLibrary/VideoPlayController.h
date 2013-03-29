//
//  VideoPlayController.h
//  VideoLibrary
//
//  Created by Paul Goldstein on 3/13/13.
//  Copyright (c) 2013 Paul Goldstein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoPlayController : UIViewController <UIWebViewDelegate>

@property (nonatomic,weak) IBOutlet UIWebView *webView;
@property (nonatomic,copy) NSString *url;
@property (nonatomic) BOOL autoPlay;
@property (nonatomic,copy) NSString *videoId;
@end
