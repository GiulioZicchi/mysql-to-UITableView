//
//  detailViewController.h
//  mysqlTableView
//
//  Created by Giulio Zicchi on 05/08/2015.
//  Copyright © 2015 Giulio Zicchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defines.h"

@interface detailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) NSDictionary *wineDict;
@property (strong, nonatomic) UIImage *wineImage;

@end
