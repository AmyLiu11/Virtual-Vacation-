//
//  AnnotationsOfPlacesAndPhoto.m
//  TopPlaces
//
//  Created by apple apple on 12-3-4.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "AnnotationsOfPlaces.h"
#import "FlickrFetcher.h"

@implementation AnnotationsOfPlacesAndPhoto
//@synthesize photo = _photo;
@synthesize place = _place;

/*+(AnnotationsOfPlacesAndPhoto*)annotationForPhoto:(NSDictionary *)photo
{
    AnnotationsOfPlacesAndPhoto *annotation = [[AnnotationsOfPlacesAndPhoto alloc] init];
    annotation.photo = photo;
    return annotation;
}*/

+(AnnotationsOfPlacesAndPhoto*)annotationForPlace:(NSDictionary *)place
{
    AnnotationsOfPlacesAndPhoto *annotation = [[AnnotationsOfPlacesAndPhoto alloc] init];
    annotation.place = place;
    return annotation;
}

-(NSString*)title
{
//    if (self.place) {
        return [self.place objectForKey:FLICKR_PLACE_NAME];
 //   }
//    else {
//        return [self.photo objectForKey:FLICKR_PHOTO_TITLE];
 //   }
}

-(NSString *)subtitle
{
 //   if (self.place) {
        return nil;
 //   }
 //   else {
 //       return [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
 //   }
}

-(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    if (self.place) {
        coordinate.latitude =[[self.place objectForKey:FLICKR_LATITUDE] doubleValue];
        coordinate.longitude = [[self.place objectForKey:FLICKR_LONGITUDE] doubleValue];
    }
//    else {
//        coordinate.latitude =[[self.photo objectForKey:FLICKR_LATITUDE] doubleValue];
//        coordinate.longitude = [[self.photo objectForKey:FLICKR_LONGITUDE] doubleValue];
 //   }
    return coordinate;
}

@end
