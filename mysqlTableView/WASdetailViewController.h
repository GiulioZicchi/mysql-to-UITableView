//
//  detailViewController.h
//  mysqlTableView
//
//  Created by Giulio Zicchi on 28/07/2015.
//  Copyright (c) 2015 Giulio Zicchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defines.h"
#import "gzHTTP.h"


@interface WASdetailViewController : UIViewController


@property(nonatomic,strong) NSDictionary *wineDict;
@property(nonatomic,strong) UIImage *wineImage;


@end
