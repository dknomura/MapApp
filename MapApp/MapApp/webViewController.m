//
//  webViewController.m
//  MapApp
//
//  Created by Aditya Narayan on 12/7/15.
//  Copyright © 2015 Daniel Nomura. All rights reserved.
//

#import "webViewController.h"

@interface webViewController()
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation webViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    
//    self.backToMap.buttonGroup = uibut
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    

}

-(void) viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    self.title = self.currentRestaurantName;
    NSString *nameWithoutSpaces = [self.currentRestaurantName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *searchString = [NSString stringWithFormat:@"https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=%@", nameWithoutSpaces];
    
    NSURL *url = [NSURL URLWithString:searchString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //
    CGRect webFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + self.toolBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.toolBar.frame.size.height * 2);
    self.webView = [[WKWebView alloc] initWithFrame:webFrame];
    [self.webView loadRequest:request];

    
    [self.view addSubview:self.webView];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


- (IBAction)forwardInBrowser:(id)sender
{
    [self.webView goForward];
}

- (IBAction)backInBrowser:(id)sender
{
    [self.webView goBack];
}

- (IBAction)backToMap:(id)sender
{
    
    [self presentViewController:self.backToMapViewController animated:YES completion:^{
    }];
}
@end
