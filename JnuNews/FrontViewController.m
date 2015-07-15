//
//  FrontViewController.m
//  JnuNews
//
//  Created by liuyanjun on 6/24/15.
//  Copyright (c) 2015 JiNan University. All rights reserved.
//

#import "FrontViewController.h"
#import "SWRevealViewController.h"
#import <CoreData/CoreData.h>
#import <BmobSDK/Bmob.h>
#import "FrontTableViewCell.h"
#import "DetailViewController.h"

static NSString * const NothingFoundCellIdentifier = @"NothingFoundCell";
static NSString * const FrontTableViewCellIdentifier = @"FrontTableViewCell";
static NSString * const DetailViewControllerIdentifier = @"DetailViewController";

@interface FrontViewController ()

@end

@implementation FrontViewController
{
    NSArray *newsItems; // 获取新闻数
    BOOL isLocal;
    NSString *module;
    NSString *entity;
}

@synthesize moduleName;
@synthesize newsTitle;

// 获取CoreData context
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // custom table cell
    self.tableView.rowHeight = 80;
    
    UINib *cellNib = [UINib nibWithNibName:FrontTableViewCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:FrontTableViewCellIdentifier];
    
    cellNib = [UINib nibWithNibName:NothingFoundCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:NothingFoundCellIdentifier];
    
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [self selectModule];
    
    if (![self isLocalData]) {
        NSLog(@"No local Data");
        [self getLatestNews];
    }
    
    //[self getLatestNews];
    
    
    // 下拉刷新
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(getLatestNews) forControlEvents:UIControlEventValueChanged];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    return 1;
        

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.

//    if ([newsItems count] == 0) {
//        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//        
//        messageLabel.text = @"暂无数据";
//        messageLabel.textColor = [UIColor blackColor];
//        messageLabel.numberOfLines = 0;
//        messageLabel.textAlignment = NSTextAlignmentCenter;
//        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
//        [messageLabel sizeToFit];
//        
//        self.tableView.backgroundView = messageLabel;
//        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    }

    if ([newsItems count] == 0) {
        return 1;
    } else {
        return [newsItems count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    static NSString *CoustomerTableIdentifier = @"FrontCell";
//    FrontTableViewCell *cell = (FrontTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CoustomerTableIdentifier];

    
    
//    if (cell == nil) {
//        cell = [[FrontTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CoustomerTableIdentifier];
//    }


    
//    if (isLocal) {
//        NSLog(@"isLoacl true");
//        cell.newsTitle.text = [[newsItems objectAtIndex:indexPath.row] valueForKey:@"title"];
//        cell.publishTime.text = [[newsItems objectAtIndex:indexPath.row] valueForKey:@"publishTime"];
//    } else {
//        cell.newsTitle.text = [[newsItems objectAtIndex:indexPath.row] objectForKey:@"title"];
//        cell.publishTime.text = [[newsItems objectAtIndex:indexPath.row] objectForKey:@"publishTime"];
//    }

    if ([newsItems count] == 0) {
        
        NSLog(@"newsItems is null");
        
        return [tableView dequeueReusableCellWithIdentifier:NothingFoundCellIdentifier forIndexPath:indexPath];
    
//        cell.nameLabel.text = @"Nothing";
//        cell.subNameLabel.text = @"";
//        cell.readingLabel.text = @"";
//        cell.countLabel.text = @"";
//        cell.dateLabel.text = @"";
    } else {
        
        FrontTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FrontTableViewCellIdentifier forIndexPath:indexPath];
    
        if (isLocal) {
            cell.nameLabel.text = [[newsItems objectAtIndex:indexPath.row] valueForKey:@"title"];
            cell.dateLabel.text = [[newsItems objectAtIndex:indexPath.row] valueForKey:@"publishTime"];
            cell.subNameLabel.text = [[newsItems objectAtIndex:indexPath.row]valueForKey:@"subTitle"];
            
        } else {
        
            cell.nameLabel.text = [[newsItems objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.dateLabel.text = [[newsItems objectAtIndex:indexPath.row] objectForKey:@"publishTime"];
            cell.subNameLabel.text = [[newsItems objectAtIndex:indexPath.row]objectForKey:@"subTitle"];
        }
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:DetailViewControllerIdentifier];
    
//    id obj = [newsItems objectAtIndex:indexPath.row];
//    NSLog(@"%i", [obj isKindOfClass:[BmobObject class]]);
//    NSLog(@"%i", [obj isKindOfClass:[NSManagedObject class]]);

    
    if ([[newsItems objectAtIndex:indexPath.row] isKindOfClass:[BmobObject class]]) {
        detailViewController.titleName = [[newsItems objectAtIndex:indexPath.row] objectForKey:@"title"];
        detailViewController.publishTime = [[newsItems objectAtIndex:indexPath.row] objectForKey:@"publishTime"];
    } else {
        detailViewController.titleName = [[newsItems objectAtIndex:indexPath.row] valueForKey:@"title"];
        detailViewController.publishTime = [[newsItems objectAtIndex:indexPath.row] valueForKey:@"publishTime"];
    }
    detailViewController.moduleName = moduleName;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}


//#pragma mark - Navigation
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"showDetail"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        DetailViewController *detailViewController = segue.destinationViewController;
//        
//        detailViewController.titleName = [[newsItems objectAtIndex:indexPath.row] valueForKey:@"title"];
//        detailViewController.publishTime = [[newsItems objectAtIndex:indexPath.row] valueForKey:@"publishTime"];
//        detailViewController.moduleName = moduleName;
//    }
//}




#pragma mark - User Define

- (void)getLatestNews {
    
    //获取上次刷新时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedTitle;
    
    NSLog(@"get news from Bmob");
    [self getNewsFromBmob];
    
}

- (void)getNewsFromBmob {
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:module];
    [bquery selectKeys:@[@"title", @"publishTime", @"subTitle"]];
    [bquery setLimit:15];
    [bquery orderByDescending:@"createdAt"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
//        for (BmobObject *obj in array) {
//            NSLog(@"title = %@", [obj objectForKey:@"title"]);
//            NSLog(@"publishTime = %@", [obj objectForKey:@"publishTime"]);
//        }
        
        if (!error) {
            isLocal = false;
            newsItems = array;
            NSLog(@"newsItems length %lu", (unsigned long)[newsItems count]);
            [NSThread detachNewThreadSelector:@selector(dataPersistence:) toTarget:self withObject:array];
            [self performSelector:@selector(reloadData) withObject:nil afterDelay:0];
        } else {
            [self.refreshControl endRefreshing];
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"友情提示" message:@"网络异常" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

- (void)reloadData {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];

}

- (void)dataPersistence:(NSArray *)array {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entity];
    [fetchRequest setFetchLimit:15];
    
    NSArray *news = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *obj in news) {
        [context deleteObject:obj];
    }
    
    for (BmobObject *obj in array) {
        NSManagedObject *latestNews = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:context];
        
        [latestNews setValue:[obj objectForKey:@"title"] forKey:@"title"];
        [latestNews setValue:[obj objectForKey:@"publishTime"] forKey:@"publishTime"];
        [latestNews setValue:[obj objectForKey:@"subTitle"] forKey:@"subTitle"];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        } else {
            NSLog(@"save success!");
        }
        
    }
    
    
}



- (BOOL)isLocalData {
    
    [self loadLocalData];
    if ([newsItems count] > 0) {
        NSLog(@"is local");
        isLocal = TRUE;
        return TRUE;
    }
    
    isLocal = FALSE;
    return FALSE;
}



- (void)loadLocalData {

    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entity];
    
    [fetchRequest setFetchLimit:15];
    NSArray *news = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    for (NSManagedObject *item in news) {
        NSLog(@"%@ %@", [item valueForKey:@"title"], [item valueForKey:@"publishTime"]);
    }
    
    newsItems = news;
}


- (void)selectModule {
    
    if ([moduleName isEqual:@"recruitInfo"] || moduleName == nil) {
        module = @"module1";
        newsTitle.title = @"校园招聘";
        entity = @"RecruitInfo";
    } else if ([moduleName isEqual:@"internshipInfo"]) {
        module = @"module2";
        newsTitle.title = @"实习招聘";
        entity = @"InternshipInfo";
    } else if ([moduleName isEqual:@"campusInfo"]) {
        module = @"module4";
        newsTitle.title = @"校内通知";
        entity = @"CampusInfo";
    }
}


@end
