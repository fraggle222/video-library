//
//  VideoPlayController.m
//  VideoLibrary
//
//  Created by Paul Goldstein on 3/13/13.
//  Copyright (c) 2013 Paul Goldstein. All rights reserved.
//

#import "VideoPlayController.h"

@interface VideoPlayController ()

@end

@implementation VideoPlayController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate=self;
    NSLog(@"self url=%@",self.url);
    
    
    //[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    
    self.webView.mediaPlaybackRequiresUserAction = NO;
    [self playVideo];
}

- (void)playVideo
{
    self.autoPlay = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"http://www.youtube.com/embed/", self.videoId]]]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"load request=%@",request.URL);
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finished");
    if (self.autoPlay) {
        self.autoPlay = NO;
        [self clickVideo];
    }
}

- (void)clickVideo {
    [self.webView stringByEvaluatingJavaScriptFromString:@"\
     function pollToPlay() {\
     var vph5 = document.getElementById(\"video-player-html5\");\
     if (vph5) {\
     vph5.playVideo();\
     } else {\
     setTimeout(pollToPlay, 100);\
     }\
     }\
     pollToPlay();\
     "];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"error %@",error);
}

@end
