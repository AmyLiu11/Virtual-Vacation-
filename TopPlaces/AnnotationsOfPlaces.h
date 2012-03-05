//
//  AnnotationsOfPlacesAndPhoto.h
//  TopPlaces
//
//  Created by apple apple on 12-3-4.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AnnotationsOfPlacesAndPhoto : NSObject<MKAnnotation>    //It's part of controller,our data is array of places and photos,our view is MKAnnotationView.
+(AnnotationsOfPlacesAndPhoto*)annotationForPlace:(NSDictionary*)place;
//+(AnnotationsOfPlacesAndPhoto*)annotationForPhoto:(NSDictionary*)photo;
//you don't have to declare +(NSString*)subtitle/title and coordinate,they're automatically implicitly declared by the fact that I publicly implement this protocol,I have to implement them in the .m file,because they're required.
@property (nonatomic,strong)NSDictionary*place;
//@property (nonatomic,strong)NSDictionary*photo;//convenient method,you don't have to alloc/init
@end
