//
//  defines.h
//  mysqlTableView
//
//  Created by Giulio Zicchi on 28/07/2015.
//  Copyright (c) 2015 Giulio Zicchi. All rights reserved.
//

#ifndef mysqlTableView_defines_h
#define mysqlTableView_defines_h

//---------------------------------------------------------

#define ZDEBUG

//---------------------------------------------------------

#ifdef ZDEBUG
#   define ZLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define ZLog(...)
#endif

//---------------------------------------------------------

#define CMD_NULL        0
#define CMD_COUNTRIES   1
#define CMD_WINES       2


#endif
