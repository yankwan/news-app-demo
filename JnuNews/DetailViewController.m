//
//  DetailViewController.m
//  JnuNews
//
//  Created by liuyanjun on 7/10/15.
//  Copyright (c) 2015 JiNan University. All rights reserved.
//

#import "DetailViewController.h"
#import <BmobSDK/Bmob.h>
#import <CoreData/CoreData.h>

@interface DetailViewController ()
{
    NSString *module;
    
}
@end

@implementation DetailViewController
@synthesize titleLabel;
@synthesize scrollerView;
@synthesize newsTitle;
@synthesize newsContent;
@synthesize titleName;
@synthesize publishTime;
@synthesize moduleName;
@synthesize indicatorView;


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
    // Do any additional setup after loading the view.
    titleLabel.text = titleName;
    
    
    [indicatorView setHidesWhenStopped:YES];
    [indicatorView startAnimating];
    [self selectModule];
    
    
    BmobQuery  *bquery = [BmobQuery queryWithClassName:module];
    [bquery selectKeys:@[@"content"]];
    [bquery whereKey:@"title" equalTo:titleName];
    [bquery whereKey:@"publishTime" equalTo:publishTime];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *bomb = [array objectAtIndex:0];
        [newsContent loadHTMLString:[bomb objectForKey:@"content"] baseURL:nil];

        [self performSelector:@selector(changeFrameSizeOfTextView) withObject:nil afterDelay:0];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)changeFrameSizeOfTextView {
    [indicatorView stopAnimating];
    
    [scrollerView setShowsVerticalScrollIndicator:NO];
    [scrollerView setScrollEnabled:YES];
    [scrollerView setPagingEnabled:YES];

}


- (void)selectModule {
    
    if ([moduleName isEqual:@"recruitInfo"] || moduleName == nil) {
        module = @"module1";
        newsTitle.title = @"招聘详情";
    } else if ([moduleName isEqual:@"internshipInfo"]) {
        module = @"module2";
        newsTitle.title = @"实习兼职详情";
    } else if ([moduleName isEqual:@"campusInfo"]) {
        module = @"module4";
        newsTitle.title = @"信息详情";
    }
}



@end
