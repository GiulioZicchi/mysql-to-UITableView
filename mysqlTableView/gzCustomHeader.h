//
//  gzCustomHeader.h
//  mysqlTableView
//
//  Created by Giulio Zicchi on 01/08/2015.
//  Copyright (c) 2015 Giulio Zicchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "defines.h"

@import UIKit;

@interface gzCustomHeader : NSObject


@property(nonatomic,strong) UIView *viewForHeader;
@property(nonatomic,strong) UIImageView *indicator;



@end
