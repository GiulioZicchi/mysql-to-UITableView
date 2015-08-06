//
//  ViewController.h
//  mysqlTableView
//
//  Created by Giulio Zicchi on 26/07/2015.
//  Copyright (c) 2015 Giulio Zicchi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "defines.h"
#import "gzHTTP.h"
#import <sqlite3.h>
#import "gzCustomHeader.h"
#import "detailViewController.h"


@class AppDelegate;

static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)    UINavigationController *myNavigationController;
@property (nonatomic,strong)    detailViewController *myDetailVC;
@property (nonatomic,strong)    NSArray *myUserInfo;
@property (nonatomic)           UIView *mask;
@property (nonatomic)           UIView *popOver;

@end
