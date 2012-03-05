//
//  RecentlyViewedTableViewController.m
//  TopPlaces
//
//  Created by apple apple on 12-2-24.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "RecentlyViewedTableViewController.h"
#import "FlickrFetcher.h"
#import "ShowPhotoViewController.h"


@implementation RecentlyViewedTableViewController
-(void)viewWillAppear:(BOOL)animated{
   [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor =[[UIColor alloc] initWithRed:0.53 green:0.81 blue:0.98 alpha:0.2];
   self.photoList = [[NSUserDefaults standardUserDefaults] objectForKey:RECENT_PHOTO_KEY];
}//继承属性

/*-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   // NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.identifier isEqualToString:@"Show Detail"]) {
        [segue.destinationViewController setTitle:@"Recently Viewed Photo"];
    }
}*/

@end
