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
@property (nonatomic) NSInteger  tag;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak,nonatomic) IBOutlet UITabBar *tab;

-(void)loadImage;
-(void) fetchFlickrDataIntoDocument:(UIManagedDocument*)doc;
@end
