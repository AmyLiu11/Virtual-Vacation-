//
//  Tag+create.h
//  TopPlaces
//
//  Created by apple apple on 12-3-19.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "Tag.h"

@interface Tag (create)
+(Tag*)tagWithName:(NSString*)name   inManagedObjectContext:(NSManagedObjectContext*)context; 
@end
