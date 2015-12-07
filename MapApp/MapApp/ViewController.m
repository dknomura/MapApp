//
//  ViewController.m
//  MapApp
//
//  Created by Aditya Narayan on 12/4/15.
//  Copyright © 2015 Daniel Nomura. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSString *currentRestaurantName;
@property (strong, nonatomic) NSMutableArray *currentAnnotations;

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
    
    self.title = @"MAPPSS!";
    
    self.searchBar.delegate = self;
    
//    NSDictionary *tttAndNearbyRestaurantsDictionary = [NSDictionary dictionaryWithObjects:@[@"27 W 24th St, New York, NY", @"200 5TH AVE, New York, NY", @"E 23rd St & Madison Ave, New York, NY", @"12 E 22nd St, New York, NY 10010"] forKeys:@[@"Junoon", @"Eataly", @"Shake Shack", @"Almond"]];
    
//    NSMutableDictionary *tttAndNearbyRestaurantsDictionary = 
    
    [turnToTechLocation geocodeAddressString:@"184 5th Ave, New York, NY" completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error){
            NSLog(@"Error getting location, %@, %@", error.localizedDescription, error.userInfo);
        } else{
            if (placemarks.count > 0){
                MKCoordinateRegion turnToTechRegion = MKCoordinateRegionMakeWithDistance(placemarks[0].location.coordinate, 300, 300);
                [self.mapView setRegion:turnToTechRegion animated:YES];
                
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.title = [NSString stringWithFormat:@"TurnToTech\n %@", placemarks[0].name];
                annotation.coordinate = placemarks[0].location.coordinate;
                
                [self.mapView addAnnotation:annotation];
                
                self.mapView.delegate = self;
//                MKAnnotationView *aView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyAnnotation"];
//                aView.image = [UIImage imageNamed:@"logo.png"];
//                aView.centerOffset = CGPointMake(10, -20);
                
            }
        }
    }];
    WaitForNetworkToFinishDelegate *waiting = [[WaitForNetworkToFinishDelegate alloc] init];
    waiting.delegate = self;
    [waiting startToWaitForNetwork];
    
    
    UITapGestureRecognizer *tapToDismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboarda)];
    [self.view addGestureRecognizer:tapToDismissKeyboard];
}

-(void) onceNetworkComplete
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"restaurant";
    request.region = self.mapView.region;
    
    self.currentAnnotations = [NSMutableArray new];
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if (error){
            NSLog(@"Error searching for local restaurants %@", error.localizedDescription);
        } else {
            for (MKMapItem *obj in response.mapItems){
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.coordinate = obj.placemark.location.coordinate;
                annotation.title = obj.name;
                annotation.subtitle = obj.phoneNumber;
                [self.mapView addAnnotation:annotation];
                [self.currentAnnotations addObject:annotation];
            }
        }
    }];
    [self.view reloadInputViews];
}

-(void)dismissKeyboarda
{
    [self.searchBar resignFirstResponder];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.mapView removeAnnotations:self.currentAnnotations];
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = self.searchBar.text;
    request.region = self.mapView.region;
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc]initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if (error){
            NSLog(@"Error with local search, %@", error.localizedDescription);
        } else {
            [response.mapItems enumerateObjectsUsingBlock:^(MKMapItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.coordinate = obj.placemark.location.coordinate;
                annotation.title = obj.name;
                annotation.subtitle = obj.phoneNumber;
                
                [self.mapView addAnnotation:annotation];
                [self.currentAnnotations addObject:annotation];
            }];
        }
    }];
    self.searchBar.alpha = .5;
    [self.searchBar endEditing:YES];

}


//    NSDictionary *restaurantAddressAndName = [NSDictionary dictionaryWithObjects:@[@"27 W 24th St, New York, NY", @"200 5TH AVE, New York, NY", @"E 23rd St & Madison Ave, New York, NY", @"12 E 22nd St, New York, NY 10010"] forKeys:@[@"Junoon", @"Eataly", @"ShakeShack", @"Almond"]];
//    
//    for (NSString *name in restaurantAddressAndName){
//        NSString *address = [restaurantAddressAndName objectForKey:name];
//        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//        [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//            if (error){
//                NSLog(@"error getting coordinates for %@ at %@ \n%@, %@", name, address, error.localizedDescription, error.userInfo);
//            } else{
//                MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
//                pointAnnotation.coordinate = placemarks[0].location.coordinate;
//                pointAnnotation.title = name;
//                pointAnnotation.subtitle = placemarks[0].name;
//                self.currentRestaurantName = name;
//                [self.mapView addAnnotation:pointAnnotation];
//            }
//            
//        }];
//    }
    // Do any additional setup after loading the view, typically from a nib.


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
            
            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//            [leftButton addTarget:self action:@selector(calloutWebsiteView) forControlEvents:UIControlEventTouchUpInside];
            pinAnnotationView.rightCalloutAccessoryView = leftButton;
            
            UIImage *iconImage = [UIImage imageNamed:[NSString stringWithFormat: @"%@.jpeg", annotation.title]];
            UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
            iconImageView.image = iconImage;
            pinAnnotationView.leftCalloutAccessoryView = iconImageView;
        }
        return pinAnnotationView;
    }
    return nil;
}

-(BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.alpha = 1;
    return true;
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

//
//-(void)calloutWebsiteView
//{
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    webViewController *webviewController = [storyBoard instantiateViewControllerWithIdentifier:@"webViewController"];
//    
//    
//    webviewController.currentRestaurantName = self.currentRestaurantName;
//
//    [self presentViewController:webviewController animated:YES completion:^{
//    }];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)search:(id)sender {
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
