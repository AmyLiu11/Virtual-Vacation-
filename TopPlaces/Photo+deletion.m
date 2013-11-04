//
//  Photo+deletion.m
//  TopPlaces
//
//  Created by apple apple on 12-3-27.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "Photo+deletion.h"

@implementation Photo (deletion)
+(void)prepareForDeletion:(NSManagedObjectContext*)context with:(Photo*)photo
{
    [context deleteObject:photo];
}
@end
