//
//  ViewController.m
//  MapApp
//
//  Created by Aditya Narayan on 12/4/15.
//  Copyright © 2015 Daniel Nomura. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.icon.image = [UIImage imageNamed:@"logo.png"];
    
    NSArray *segmentTitles =  @[@"Standard", @"Hybrid", @"Satellite"];
    for (int i = 0; i<segmentTitles.count; i++) {
        [self.mapSegControl setTitle:segmentTitles[i] forSegmentAtIndex:i];
    }
    
    CLGeocoder *turnToTechLocation = [[CLGeocoder alloc]init];
    [turnToTechLocation geocodeAddressString:@"184 5th Ave, New York, NY" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error){
            NSLog(@"Error getting location, %@, %@", error.localizedDescription, error.userInfo);
        } else{
            if (placemarks.count > 0){
                CLPlacemark *placeMark = placemarks[0];
                CLLocationCoordinate2D tttLocation = placeMark.location.coordinate;
                MKCoordinateRegion turnToTechRegion = MKCoordinateRegionMakeWithDistance(tttLocation, 500, 500);
                [self.mapView setRegion:turnToTechRegion animated:YES];
                
                
                
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.title = @"TurnToTech";
                annotation.coordinate = tttLocation;
                MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationPin"];
                self.mapView.delegate = self;
//                MKAnnotationView *aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyAnnotation"];
//                aView.image = [UIImage imageNamed:@"logo.png"];
//                aView.centerOffset = CGPointMake(10, -20);
            }
        }
    }];
    // Do any additional setup after loading the view, typically from a nib.
}

//-(MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)mapTypeSwitch:(id)sender
{
    switch (self.mapSegControl.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}


@end
