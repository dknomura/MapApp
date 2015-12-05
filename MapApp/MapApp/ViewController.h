//
//  ViewController.h
//  MapApp
//
//  Created by Aditya Narayan on 12/4/15.
//  Copyright © 2015 Daniel Nomura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapSegControl;


- (IBAction)mapTypeSwitch:(id)sender;


@end

