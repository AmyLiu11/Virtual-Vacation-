//
//  ViewController.h
//  TopPlaces
//
//  Created by apple apple on 12-3-11.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>


@interface ViewController : UIViewController  <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) NSArray *annotations;// of id<MKAnnotation> model!!
@property (nonatomic,strong) NSArray *places;
@property (nonatomic)  NSInteger *annotationValue;
@property (strong,nonatomic)UIBarButtonItem * backItem;

-(NSArray*)mapAnnotations;
-(void)updateMapView;
@end
