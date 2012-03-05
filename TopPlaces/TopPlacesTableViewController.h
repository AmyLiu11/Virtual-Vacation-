//
//  TopPlacesTableViewController.h
//  TopPlaces
//
//  Created by apple apple on 12-2-24.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoOfPlacesTableViewController.h"

@interface TopPlacesTableViewController : UITableViewController
@property (nonatomic,strong)NSArray *places;
@property (nonatomic,strong)NSArray *photos;
@end
