//
//  Tag.h
//  TopPlaces
//
//  Created by apple apple on 12-3-19.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * numOfPhoto;
@property (nonatomic, retain) NSSet *photosOfTag;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addPhotosOfTagObject:(Photo *)value;//向一个tag添加一个photo object
- (void)removePhotosOfTagObject:(Photo *)value;
- (void)addPhotosOfTag:(NSSet *)values;
- (void)removePhotosOfTag:(NSSet *)values;

@end
