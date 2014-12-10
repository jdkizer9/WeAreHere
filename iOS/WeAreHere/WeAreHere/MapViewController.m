//
//  MapViewController.m
//  WeAreHere
//
//  Created by Tara Wilson on 11/20/14.
//  Copyright (c) 2014 JKNLTW-MAUC. All rights reserved.
//

#import "MapViewController.h"
#import <Mapbox-iOS-SDK/Mapbox.h>
#import "WRHOccupancy.h"


@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CLLocationDegrees latitude = self.location.coordinate.latitude;
    CLLocationDegrees longitude = self.location.coordinate.longitude;
    self.occupiedrooms = [NSMutableArray array];
    RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetResource:@"cornellfloorplan" ofType:@"mbtiles"];
    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:offlineSource];
    

    mapView.zoom = 2;
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    mapView.adjustTilesForRetinaDisplay = YES; // these tiles aren't designed specifically for retina, so make them legible
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
    
    
    CLLocationCoordinate2D yourLocation = CLLocationCoordinate2DMake(self.location.coordinate.latitude, self.location.coordinate.longitude);
    
    RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapView
                                                                      coordinate:yourLocation
                                                                        andTitle:@"Your Location!"];
    
    [mapView addAnnotation:annotation];
    
    RMCircleAnnotation *pointannotation = [[RMCircleAnnotation alloc] initWithMapView:mapView
                                                          coordinate:yourLocation
                                                            andTitle:@"Your Location!"];
    
    [mapView addAnnotation:pointannotation];
    
    

    for(CLLocation* loc in self.receivelocations){
        NSUInteger locationindex = [self.receivelocations indexOfObject:loc];
        latitude = loc.coordinate.latitude;
        longitude = loc.coordinate.longitude;
        if(([self.occupiedrooms containsObject:loc])){
            
            NSLog(@"%@", loc);
            NSLog(@"already has");
            longitude = longitude + 8;
            CLLocationCoordinate2D yourLocation = CLLocationCoordinate2DMake(latitude, longitude);
            RMAnnotation *annotation = [[RMPointAnnotation alloc] initWithMapView:mapView
                                                                       coordinate:yourLocation
                                                                         andTitle:[self.receiveusers objectAtIndex:locationindex]];
            [mapView addAnnotation:annotation];
        }
        
            
            
            
//        else if([[self.receiveusers objectAtIndex:locationindex] isEqualToString:(NSString *)self.user]){
//            NSLog(@"it's me");
//            CLLocationCoordinate2D yourLocation = CLLocationCoordinate2DMake(latitude, longitude);
//            RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapView
//                                                                  coordinate:yourLocation
//                                                                    andTitle:@"Your Location!"];
//            
//            [mapView addAnnotation:annotation];
//
//        }
    
    
    
        else{
            [self.occupiedrooms addObject:loc];
        CLLocationCoordinate2D yourLocation = CLLocationCoordinate2DMake(latitude, longitude);
        RMAnnotation *annotation = [[RMPointAnnotation alloc] initWithMapView:mapView
                                                                        coordinate:yourLocation
                                                                          andTitle:[self.receiveusers objectAtIndex:locationindex]];
        
            [mapView addAnnotation:annotation];
        }
    }


    


    
    
    
    
    
}



- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;
    
    RMCircle *circle = [[RMCircle alloc] initWithView:mapView radiusInMeters:2000000];
    
    circle.lineColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    circle.fillColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.2];
    circle.lineWidthInPixels = 5.0;
    
    return circle;
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [self.occupiedrooms removeAllObjects];

}



@end
