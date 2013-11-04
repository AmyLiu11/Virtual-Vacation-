//
//  ShowTagPhotoTableViewController.h
//  TopPlaces
//
//  Created by apple apple on 12-3-22.
//  Copyright (c) 2012年 xian. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Tag.h"

@interface ShowTagPhotoTableViewController : CoreDataTableViewController
@property (nonatomic,strong) Tag * tag;
@end


