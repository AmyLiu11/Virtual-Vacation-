//
//  AnnotationOfPhotos.m
//  TopPlaces
//
//  Created by apple apple on 12-3-10.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "AnnotationOfPhotos.h"
#import "FlickrFetcher.h"

@implementation AnnotationOfPhotos
@synthesize photo = _photo;

+(AnnotationOfPhotos*)annotationForPhoto:(NSDictionary *)photo
 {
      AnnotationOfPhotos *annotation = [[AnnotationOfPhotos alloc] init];
      annotation.photo = photo;
      return annotation;
 }

-(NSString*)title
{
     return [self.photo objectForKey:FLICKR_PHOTO_TITLE];
}

-(NSString*)subtitle
{
     return [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}

-(CLLocationCoordinate2D)coordinate
{
         CLLocationCoordinate2D coordinate;
         coordinate.latitude =[[self.photo objectForKey:FLICKR_LATITUDE] doubleValue];
         coordinate.longitude = [[self.photo objectForKey:FLICKR_LONGITUDE] doubleValue];
         return coordinate;
}
@end
