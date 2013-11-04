//
//  Photo.h
//  TopPlaces
//
//  Created by apple apple on 12-3-19.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Place, Tag;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * unique;
@property (nonatomic, retain) Place *tookPhotoAt;
@property (nonatomic, retain) NSSet *hasATag;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)addHasATagObject:(Tag *)value;
- (void)removeHasATagObject:(Tag *)value;
- (void)addHasATag:(NSSet *)values;
- (void)removeHasATag:(NSSet *)values;

@end
