//
//  gzHTTP.m
//  mysqlTableView
//
//  Created by Giulio Zicchi on 26/07/2015.
//  Copyright (c) 2015 Giulio Zicchi. All rights reserved.
//

#import "gzHTTP.h"

@implementation gzHTTP


static gzHTTP *singletonInstance;

//------------------------------------------------------------------------------------------------------------


+(gzHTTP *)getInstance{
    
    if(singletonInstance == nil){
        
        singletonInstance = [[super alloc] init];
        
    }
    
    return singletonInstance;
    
}

//------------------------------------------------------------------------------------------------------------

-(void)serverJsonRequest:(NSString *)urlString{
    
    // call url passed in string, and fire completion handler when done
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               [self jsonCompletionHandler:data andError:error];
                               
                               
                           }];
    
}

//------------------------------------------------------------------------------------------------------------

-(void)jsonCompletionHandler:(NSData *)data andError:(NSError *)error{
    
    // completion handler, sends notification to listener (currently main view controller)
    // when done, passing json in dictionary
    // NOTE: php json encode creates an NSArray of dictionarys, NOT an NSDictionary of dictionaries...
    
    
    if(data){
        
        NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:data
                              
                              options:kNilOptions
                              error:&error];
        

        [[NSNotificationCenter defaultCenter] postNotificationName:@"webJsonDataRetrieved"
                                                            object:self
                                                          userInfo:json];
        
        
    } else {
        
        //---------------------------------------------------------------------------------------------
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Unavailable"
                                                        message:@"Please connect to the Internet\r\nand press the refresh button when ready."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        //---------------------------------------------------------------------------------------------
        
    }
    
    
}

//------------------------------------------------------------------------------------------------------------


@end
