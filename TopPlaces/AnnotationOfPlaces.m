//
//  AnnotationOfPlaces.m
//  TopPlaces
//
//  Created by apple apple on 12-3-10.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "AnnotationOfPlaces.h"

#import "AnnotationOfPlaces.h"
#import "FlickrFetcher.h"

@implementation AnnotationOfPlaces
@synthesize place = _place;

/*+(AnnotationsOfPlacesAndPhoto*)annotationForPhoto:(NSDictionary *)photo
 {
 AnnotationsOfPlacesAndPhoto *annotation = [[AnnotationsOfPlacesAndPhoto alloc] init];
 annotation.photo = photo;
 return annotation;
 }*/

+(AnnotationOfPlaces*)annotationForPlace:(NSDictionary *)place
{
    AnnotationOfPlaces *annotation = [[AnnotationOfPlaces alloc] init];
    annotation.place = place;
    return annotation;
}

-(NSString*)title
{
    NSString *str =  [self.place objectForKey:FLICKR_PLACE_NAME] ;
    NSRange range =[str rangeOfString:@","];
    return [str substringToIndex:range.location];
}

-(NSString *)subtitle
{
    NSString *str =  [self.place objectForKey:FLICKR_PLACE_NAME] ;
    NSRange range =[str rangeOfString:@","];
    return [str  substringFromIndex:range.location+1];
}

-(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    if (self.place) {
        coordinate.latitude =[[self.place objectForKey:FLICKR_LATITUDE] doubleValue];
        coordinate.longitude = [[self.place objectForKey:FLICKR_LONGITUDE] doubleValue];
    }
    return coordinate;
}

@end

