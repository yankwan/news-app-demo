//
//  SidebarViewController.m
//  JnuNews
//
//  Created by liuyanjun on 6/24/15.
//  Copyright (c) 2015 JiNan University. All rights reserved.
//

#import "SidebarViewController.h"
#import "FrontViewController.h"
#import "MovieTableViewController.h"

@interface SidebarViewController ()

@end

@implementation SidebarViewController {
    NSArray *menuItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuItems = @[@"titleInfo", @"recruitInfo", @"internshipInfo", @"auditoriumInfo", @"campusInfo", @"favouriteInfo"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([[segue identifier] isEqualToString:@"showRecruitInfo"]) {
    
        UINavigationController *navController = segue.destinationViewController;
        FrontViewController *frontViewController = (FrontViewController *)[navController topViewController];
        frontViewController.moduleName = [menuItems objectAtIndex:indexPath.row];
    } else if ([[segue identifier] isEqualToString:@"showMoiveInfo"]) {
        
        UINavigationController *navController = segue.destinationViewController;
        MovieTableViewController *movieTableViewController = (MovieTableViewController *)[navController topViewController];
        
    }    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:20/255.0f green:160/255.0f blue:160/255.0f alpha:0.25f];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 68;
    }
    
    return 44;
}




@end
