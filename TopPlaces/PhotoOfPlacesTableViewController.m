//
//  PhotoOfPlacesTableViewController.m
//  TopPlaces
//
//  Created by apple apple on 12-2-26.
//  Copyright (c) 2012年 xian. All rights reserved.
//

#import "PhotoOfPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "ShowPhotoViewController.h"

@interface PhotoOfPlacesTableViewController ()

@end

@implementation PhotoOfPlacesTableViewController
@synthesize photoList = _photoList;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setPhotoList:(NSArray *)photoList
{
    if (_photoList!=photoList) {
        _photoList = photoList;
    }
    [self.tableView reloadData];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath*indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.identifier isEqualToString:@"Show Detail"]) 
    {
        NSDictionary *photo = [self.photoList objectAtIndex:indexPath.row];
        [segue.destinationViewController setTitle: [photo objectForKey:FLICKR_PHOTO_TITLE]];
        [segue.destinationViewController setPhoto:photo];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    else {
        return  YES;
    }

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Info";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *photo = [self.photoList objectAtIndex:indexPath.row];
    NSString *title = [photo objectForKey:FLICKR_PHOTO_TITLE];
    NSString *subtitle = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    if ([title isEqualToString:@""]) {
        title = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        subtitle = @"";
        if ([title isEqualToString:@""]) {
            title = @"Unknown";
        }
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subtitle;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
