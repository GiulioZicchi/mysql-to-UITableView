//
//  gzHTTP.h
//  mysqlTableView
//
//  Created by Giulio Zicchi on 26/07/2015.
//  Copyright (c) 2015 Giulio Zicchi. All rights reserved.
//

#define ZDEBUG
//---------------------------------------------------------

#ifdef ZDEBUG
#   define ZLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define ZLog(...)
#endif

//---------------------------------------------------------


#import <Foundation/Foundation.h>
@import UIKit;

@interface gzHTTP : NSObject


+(gzHTTP *) getInstance;

-(void)serverJsonRequest:(NSString *)urlString;


@end
