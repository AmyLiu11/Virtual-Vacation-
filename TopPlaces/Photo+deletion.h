//
//  Photo+deletion.h
//  TopPlaces
//
//  Created by apple apple on 12-3-27.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "Photo.h"

@interface Photo (deletion)
+(void)prepareForDeletion:(NSManagedObjectContext*)context with:(Photo*)photo;
@end
