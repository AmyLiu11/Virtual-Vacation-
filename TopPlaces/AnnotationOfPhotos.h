//
//  AnnotationOfPhotos.h
//  TopPlaces
//
//  Created by apple apple on 12-3-10.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface AnnotationOfPhotos : NSObject<MKAnnotation>
+(AnnotationOfPhotos*)annotationForPhoto:(NSDictionary*)photo;
@property (nonatomic,strong)NSDictionary*photo;
@end
