//
//  MovieTableViewController.m
//  JnuNews
//
//  Created by liuyanjun on 7/13/15.
//  Copyright (c) 2015 JiNan University. All rights reserved.
//

#import "MovieTableViewController.h"
#import "MovieTableViewCell.h"
#import "SWRevealViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobFile.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MovieDetailViewController.h"
#import <CoreData/CoreData.h>


static NSString * const MovieTableViewCellIdentifier = @"MovieTableViewCell";
static NSString * const MovieDetailViewControllerIdentifier = @"MovieDetailViewController";

@interface MovieTableViewController ()

@end

@implementation MovieTableViewController
{
    NSArray *newsItems;
    BOOL isLocal;
    NSString *entity;
}

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
    
    newsTitle.title = @"礼堂观影";
    entity = @"AuditoriumInfo";
    
    self.tableView.rowHeight = 128;
    
    UINib *cellNib = [UINib nibWithNibName:MovieTableViewCellIdentifier bundle:nil     ];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:MovieTableViewCellIdentifier];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [self getLatestNews];
    
    
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [newsItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieTableViewCell *cell = (MovieTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MovieTableViewCellIdentifier];
    
    cell.movieNameLabel.text = [[newsItems objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.movieSubLabel.text = [[newsItems objectAtIndex:indexPath.row] objectForKey:@"subTitle"];
    cell.movieDateLabel.text = [[newsItems objectAtIndex:indexPath.row] objectForKey:@"date"];
    cell.moviePriceLabel.text = [[newsItems objectAtIndex:indexPath.row] objectForKey:@"price"];
    
    
    NSString *style = [[newsItems objectAtIndex:indexPath.row] objectForKey:@"style"];
    cell.movieStyleLabel.text = style;
    
    NSLog(@"movie name %@, style %@", [[newsItems objectAtIndex:indexPath.row] objectForKey:@"title"], style);
    
    if ([style isEqualToString:@"2D"]) {
        cell.movieStyleLabel.hidden = YES;
    } else {
        cell.movieStyleLabel.hidden = NO;
    }
    
    NSString *url = [(BmobFile *)[[newsItems objectAtIndex:indexPath.row] objectForKey:@"imageCover"] url];
    
    NSLog(@"%@",url);
    
    
    [cell.movieImageView setImageWithURL:[NSURL URLWithString:url]];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieDetailViewController *movieDetailViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:MovieDetailViewControllerIdentifier];
    
    movieDetailViewController.movieName = [[newsItems objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    [self.navigationController pushViewController:movieDetailViewController animated:YES];
    
}


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
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"module3"];
    [bquery selectKeys:@[@"title", @"subTitle", @"date", @"price", @"style", @"imageCover"]];
    [bquery setLimit:15];
    [bquery orderByDescending:@"createdAt"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
//        for (BmobObject *obj in array) {
//            NSLog(@"title = %@", [obj objectForKey:@"title"]);
//            NSLog(@"image = %@", [(BmobFile *)[obj objectForKey:@"imageCover"] url]);
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
        [latestNews setValue:[obj objectForKey:@"subTitle"] forKey:@"subTitle"];
        [latestNews setValue:[obj objectForKey:@"date"] forKey:@"date"];
        [latestNews setValue:[obj objectForKey:@"price"] forKey:@"price"];
        [latestNews setValue:[obj objectForKey:@"style"] forKey:@"style"];
        
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        } else {
            NSLog(@"save success!");
        }
        
    }
    
    
}




@end
