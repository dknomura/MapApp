//
//  ViewController.h
//  MapApp
//
//  Created by Aditya Narayan on 12/4/15.
//  Copyright © 2015 Daniel Nomura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <WebKit/WebKit.h>
#import "webViewController.h"

@interface ViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapSegControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)search:(id)sender;

- (IBAction)mapTypeSwitch:(id)sender;


@end

