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
#import "imageCacher.h"


@implementation RecentlyViewedTableViewController
-(void)viewWillAppear:(BOOL)animated{
   [super viewWillAppear:animated];
 //   self.navigationController.navigationBar.tintColor =[[UIColor alloc] initWithRed:0.53 green:0.81 blue:0.98 alpha:0.2];
   self.photoList = [[NSUserDefaults standardUserDefaults] objectForKey:RECENT_PHOTO_KEY];
}//继承属性,因为此controller要多次出现，所以在viewWillAppear中

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath*indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.identifier isEqualToString:@"Show Detail"]) 
    {
        NSDictionary *photo = [self.photoList objectAtIndex:indexPath.row];
         NSLog(@"Tag = %@",[photo objectForKey:FLICKR_TAGS]);
        [segue.destinationViewController setTitle: [photo objectForKey:FLICKR_PHOTO_TITLE]];
        [segue.destinationViewController   setTag:1];//将recentPhoto标记为1
        [segue.destinationViewController setPhoto:photo];
    }
}//segue to showPhotoVC


@end
