//
//  ShowPhotoViewController.h
//  TopPlaces
//
//  Created by apple apple on 12-2-27.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import <UIKit/UIKit.h>
#define  RECENT_PHOTO_KEY  @"RecentlyViewedPhotoTableViewCOntroller.recentPhotos"

@interface ShowPhotoViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic,strong) NSDictionary *photo;
@end
