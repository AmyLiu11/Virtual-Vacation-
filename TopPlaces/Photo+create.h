//
//  Photo+create.h
//  TopPlaces
//
//  Created by apple apple on 12-3-21.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "Photo.h"

@interface Photo (create)
+(Photo*)photoWithFlickrInfo:(NSDictionary*)FlickrInfo
      inManagedObjectContext:(NSManagedObjectContext*)context;
@end
