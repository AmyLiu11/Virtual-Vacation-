//
//  imageCacher.h
//  TopPlaces
//
//  Created by apple apple on 12-3-13.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface imageCacher : NSObject
+(void)cacheImg:(UIImage*)img   withImgInfo:(NSString*)info;//save img
+(UIImage*)getCachedImg:(NSString*)info;//get img
@end
