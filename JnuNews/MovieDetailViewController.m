//
//  MovieDetailViewController.m
//  JnuNews
//
//  Created by liuyanjun on 7/14/15.
//  Copyright (c) 2015 JiNan University. All rights reserved.
//

#import "MovieDetailViewController.h"
#import <BmobSDK/Bmob.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MovieDetailViewController ()

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_indicatorView setHidesWhenStopped:YES];
    [_indicatorView startAnimating];
    
    _titleName.title = _movieName;
    
    BmobQuery  *bquery = [BmobQuery queryWithClassName:@"module3"];
    [bquery selectKeys:@[@"content", @"imageBigCover"]];
    [bquery whereKey:@"title" equalTo:_movieName];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BmobObject *bomb = [array objectAtIndex:0];
        [_movieContentView loadHTMLString:[bomb objectForKey:@"content"] baseURL:nil];

        NSString *url = [(BmobFile *)[[array objectAtIndex:0] objectForKey:@"imageBigCover"] url];
        
        NSLog(@"%@",url);
        [_movieImageView setImageWithURL:[NSURL URLWithString:url]];
        
        [_indicatorView stopAnimating];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
