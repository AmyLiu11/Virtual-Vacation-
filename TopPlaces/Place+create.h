//
//  Place+create.h
//  TopPlaces
//
//  Created by apple apple on 12-3-19.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "Place.h"

@interface Place (create)
+(Place*)placeWithName:(NSString*)name      inManagedObjectContext:(NSManagedObjectContext*)context;
@end
