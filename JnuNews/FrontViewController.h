//
//  FrontViewController.h
//  JnuNews
//
//  Created by liuyanjun on 6/24/15.
//  Copyright (c) 2015 JiNan University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrontViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *newsTitle;
@property (strong, nonatomic) NSString *moduleName;
@end
