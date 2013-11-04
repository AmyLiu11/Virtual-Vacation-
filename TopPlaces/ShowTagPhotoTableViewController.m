//
//  ShowTagPhotoTableViewController.m
//  TopPlaces
//
//  Created by apple apple on 12-3-22.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "ShowTagPhotoTableViewController.h"
#import "VactionHelper.h"
#import "Photo.h"
#import "Tag.h"

@interface ShowTagPhotoTableViewController ()

@end

@implementation ShowTagPhotoTableViewController
@synthesize tag = _tag;


-(void)setupFetchedResultsController:(NSManagedObjectContext*)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest  fetchRequestWithEntityName:@"Photo"];
    NSLog(@"tag = %@",self.tag.title);
    fetchRequest.predicate = [NSPredicate  predicateWithFormat:@"ANY hasATag.title contains %@",(NSString*)self.tag.title];//photo search,因为一张photo会有多个tag，所以使用any ，只要这张photo的tag中包含self.tag.title,这张photo就被选中
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
}

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

-(void)openVacation:(UIManagedDocument*)vacation
{
    [self setupFetchedResultsController:vacation.managedObjectContext];
}

-(void)setTag:(Tag*)tag
{
    if (_tag != tag) {
        _tag = tag;
    }
    [VactionHelper openVacation:@"Vacation1" usingBlock:^(UIManagedDocument*doc){
        [self openVacation:doc];
    }];//每次setPlace的时候都要打开doc取photo
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tags";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];//get the managedObject in the row
    cell.textLabel.text = photo.title;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *ip = [self.tableView indexPathForCell:sender];
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:ip];
    if ([segue.identifier isEqualToString:@"show detail"]) {
        [segue.destinationViewController setImageURL:photo.imageURL];
        [segue.destinationViewController setTitle:photo.title];
    }
}



@end



