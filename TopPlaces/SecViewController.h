//
//  SecViewController.h
//  TopPlaces
//
//  Created by apple apple on 12-3-10.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
 @class SecViewController;
 @protocol ViewControllerDelegate <NSObject>
 -(UIImage*)SecViewController:(SecViewController*)sender  imageForAnnotation:(id<MKAnnotation>)annotation;
 //为了保证ViewController的独立性，不引入Flickr.h，而是用delegate获得图片，we gonna ask this delegate anytime we want image to go in a callout
 @end

@interface SecViewController : ViewController
@property (nonatomic,strong)NSArray *photos;//model
@property (nonatomic,weak) id<ViewControllerDelegate> delegate;

-(NSArray*)mapAnnotations;//override the method,instance variables can not be overriden
@end
