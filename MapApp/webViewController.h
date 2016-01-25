//
//  webViewController.h
//  MapApp
//
//  Created by Aditya Narayan on 12/7/15.
//  Copyright © 2015 Daniel Nomura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
@interface webViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardInBrowser;
@property (strong, nonatomic) NSString *currentRestaurantName;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backToMap;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backInBrowser;
@property (strong, nonatomic) UIViewController *backToMapViewController;

- (IBAction)forwardInBrowser:(id)sender;
- (IBAction)backInBrowser:(id)sender;

@end
