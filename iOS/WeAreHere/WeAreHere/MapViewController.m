//
//  MapViewController.m
//  WeAreHere
//
//  Created by Tara Wilson on 11/20/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import "MapViewController.h"
#import <Mapbox-iOS-SDK/Mapbox.h>


@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"MAP USER IS %@", _user);
    
    RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetResource:@"cornellfloorplan" ofType:@"mbtiles"];
    
    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:offlineSource];
    
    mapView.zoom = 2;
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    mapView.adjustTilesForRetinaDisplay = YES; // these tiles aren't designed specifically for retina, so make them legible
    
    [self.view addSubview:mapView];
    
    CLLocationDegrees latitude = 20;
    CLLocationDegrees longitude = 40;
    
    CLLocationCoordinate2D yourLocation = CLLocationCoordinate2DMake(latitude, longitude);
    
    
    RMPointAnnotation *annotation = [[RMPointAnnotation alloc] initWithMapView:mapView
                                                                    coordinate:yourLocation
                                                                      andTitle:_user];
    [mapView addAnnotation:annotation];
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
