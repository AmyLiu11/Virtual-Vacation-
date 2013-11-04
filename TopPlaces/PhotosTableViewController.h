//
//  PhotosTableViewController.h
//  TopPlaces
//
//  Created by apple apple on 12-3-21.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Place.h"

@interface PhotosTableViewController : CoreDataTableViewController
@property (nonatomic,strong) Place*place;
@end
