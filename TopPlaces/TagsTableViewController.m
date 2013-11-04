//
//  TagsTableViewController.m
//  TopPlaces
//
//  Created by apple apple on 12-3-21.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "TagsTableViewController.h"
#import "VactionHelper.h"
#import "Tag.h"
#import "Tag+create.h"

@interface TagsTableViewController ()

@end

@implementation TagsTableViewController

-(void)setupFetchedResultsController:(NSManagedObjectContext*)context
{
    NSFetchRequest *fetchRequest  =  [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor  sortDescriptorWithKey:@"title" ascending:YES]];//there might be lots of sortDescriptors,so it's an array
    self.fetchedResultsController = [[NSFetchedResultsController alloc]  initWithFetchRequest:fetchRequest                                                         managedObjectContext:context   sectionNameKeyPath:nil cacheName:nil];                                                                        
}

-(void)openVacation:(UIManagedDocument*)vacation
{
      [self setupFetchedResultsController:vacation.managedObjectContext];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [VactionHelper openVacation:@"Vacation1" usingBlock:^(UIManagedDocument*doc){
        [self  openVacation:doc]; 
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Tags";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Tag*tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = tag.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d photos",[tag.photosOfTag count]];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"tag = %@",tag.title);
    if ([segue.destinationViewController respondsToSelector:@selector(setTag:)]) 
    {
        [segue.destinationViewController    performSelector:@selector(setTag:) withObject:tag];
        [segue.destinationViewController setTitle:tag.title];
    }
}
  
@end

