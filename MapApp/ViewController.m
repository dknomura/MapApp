//
//  ViewController.m
//  MapApp
//
//  Created by Aditya Narayan on 12/4/15.
//  Copyright © 2015 Daniel Nomura. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()
@property (strong, nonatomic) NSString *currentRestaurantName;
@property (strong, nonatomic) NSMutableArray *currentAnnotations;
@property (nonatomic) CLLocationCoordinate2D turnToTechLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL didSearchRestaurants;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager =[[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];

    self.mapView.delegate = self;
    self.searchBar.delegate = self;

    self.mapView.showsUserLocation = YES;
    self.icon.image = [UIImage imageNamed:@"logo.png"];
    

    self.title = @"MAPPSS!";

    CLGeocoder *turnToTechLocation = [[CLGeocoder alloc]init];
    [turnToTechLocation geocodeAddressString:@"184 5th Ave, New York, NY" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error){
            NSLog(@"Error getting location, %@, %@", error.localizedDescription, error.userInfo);
        } else{
            if (placemarks.count > 0){
                self.turnToTechLocation = placemarks[0].location.coordinate;
                [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.turnToTechLocation, 3000, 3000) animated:YES];
                
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.title = @"TurnToTech";
                annotation.subtitle = placemarks[0].name;
                annotation.coordinate = placemarks[0].location.coordinate;
                
                [self.mapView addAnnotation:annotation];
            }
        }
    }];
    UITapGestureRecognizer *tapToDismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboarda)];
    [self.view addGestureRecognizer:tapToDismissKeyboard];
}


#pragma mark - Search bar delegate methods and Keyboard dismissal

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = self.searchBar.text;
    request.region = self.mapView.region;
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc]initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if (error){
            NSLog(@"Error with local search, %@", error.localizedDescription);
            if (response.mapItems.count == 0) {
                UIAlertController *noLocationAlert = [UIAlertController alertControllerWithTitle: nil message:@"No Locations Found" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmation = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [noLocationAlert addAction:confirmation];
                [self presentViewController:noLocationAlert animated:YES completion:nil];
            }
        }else {
            [self.mapView removeAnnotations:self.currentAnnotations];
            
            for(MKMapItem *obj in response.mapItems){
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.coordinate = obj.placemark.location.coordinate;
                annotation.title = obj.name;
                NSLog(@"Got.. %@, city: %@", obj.name, obj.placemark.locality);
                annotation.subtitle = obj.phoneNumber;
                
                [self.mapView addAnnotation:annotation];
                [self.currentAnnotations addObject:annotation];
            }
        }
    }];
    self.searchBar.alpha = .5;
    [self.searchBar endEditing:YES];

}

-(BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.alpha = 1;
    return true;
}


-(void)dismissKeyboarda
{
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
        self.searchBar.alpha = .5;
    }
}


#pragma mark - MapView delegate methods
-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!self.didSearchRestaurants) {
        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        request.naturalLanguageQuery = @"restaurant";
        request.region = self.mapView.region;
        
        self.currentAnnotations = [NSMutableArray new];
        
        MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
        [localSearch startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
            if (error){
                NSLog(@"Error searching for local restaurants %@", error.localizedDescription);
            } else {
                
                if([NSThread isMainThread]){
                    NSLog(@"In Main Thread");
                }
                else {
                    NSLog(@"Not in Main Thread");
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (MKMapItem *obj in response.mapItems){
                        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                        annotation.coordinate = obj.placemark.location.coordinate;
                        annotation.title = obj.name;
                        annotation.subtitle = obj.phoneNumber;
                        [self.mapView addAnnotation:annotation];
                        [self.currentAnnotations addObject:annotation];
                    }
                });
            }
        }];
    }
    if (!self.didSearchRestaurants) {
        self.didSearchRestaurants = TRUE;
    }
    mapView.centerCoordinate = userLocation.location.coordinate;
}

-(void) mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views
{
//    if ([views[0].annotation.title isEqualToString:@"TurnToTech"]) {
// 
//    }
}


-(MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    if ([annotation isKindOfClass:[MKPointAnnotation class]]){
        MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"customPinView"];
        
        if(!pinAnnotationView){
            CGFloat red = arc4random_uniform(255) / 255.0;
            CGFloat green = arc4random_uniform(255) / 255.0;
            CGFloat blue = arc4random_uniform(255) / 255.0;
            UIColor *randomColor = [UIColor colorWithRed:red green:green blue:blue alpha:.8];
            
            pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"customPinView"];
            pinAnnotationView.pinTintColor = randomColor;
            
            pinAnnotationView.animatesDrop = YES;
            pinAnnotationView.canShowCallout = YES;
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//            [leftButton addTarget:self action:@selector(calloutWebsiteView) forControlEvents:UIControlEventTouchUpInside];
            pinAnnotationView.rightCalloutAccessoryView = rightButton;
            
            UIImage *iconImage = [UIImage imageNamed:[NSString stringWithFormat: @"%@.jpeg", annotation.title]];
            UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
            iconImageView.image = iconImage;
            pinAnnotationView.leftCalloutAccessoryView = iconImageView;
        }
        return pinAnnotationView;
    }
    return nil;
}



-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MKPointAnnotation *annotation = view.annotation;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    webViewController *webviewController = [storyBoard instantiateViewControllerWithIdentifier:@"webViewController"];
    webviewController.currentRestaurantName = annotation.title;
//    webviewController.backToMapViewController = self;
    
    [self.navigationController pushViewController:webviewController animated:YES];
}




- (void)didReceiveMemoryWarning
{
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
