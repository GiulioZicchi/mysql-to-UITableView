//
//  gzCustomHeader.m
//  mysqlTableView
//
//  Created by Giulio Zicchi on 01/08/2015.
//  Copyright (c) 2015 Giulio Zicchi. All rights reserved.
//

#import "gzCustomHeader.h"

@implementation gzCustomHeader


@synthesize viewForHeader,indicator;


//------------------------------------------------------------------------------------------------------------


-(id)init{
    
    self = [super init];
    if(self){
        

        self.viewForHeader = [UIView new];
        UIImage *image = [UIImage imageNamed:@"caretOpen"];
        self.indicator = [[UIImageView alloc] initWithImage:image];
        [self.viewForHeader addSubview:self.indicator];
        CGRect frame = self.indicator.frame;
        frame.origin.x += 8;
        frame.origin.y += 20;
        self.indicator.frame = frame;
        
        
    }
    return self;
}

//------------------------------------------------------------------------------------------------------------



@end
