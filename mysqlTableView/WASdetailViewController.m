//
//  detailViewController.m
//  mysqlTableView
//
//  Created by Giulio Zicchi on 28/07/2015.
//  Copyright (c) 2015 Giulio Zicchi. All rights reserved.
//

#import "WASdetailViewController.h"

@implementation WASdetailViewController{
    
    UIScrollView *myScrollView;
}


@synthesize wineDict,wineImage;

//------------------------------------------------------------------------------------------------------------

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self debugFrame:self.view.frame];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *image = [wineDict objectForKey:@"gfx"];
    ZLog(@"%@",image)
    
    NSString *myURL = [NSString stringWithFormat:@"http://www.scenariodevelopments.co.uk/images/vickis/wines/%@",image];
    [self getImageFromServer:myURL];
    
    
    
}

//------------------------------------------------------------------------------------------------------------


-(void)viewWillAppear:(BOOL)animated{

    myScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    myScrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:myScrollView];
    
    
}

//------------------------------------------------------------------------------------------------------------


-(void)debugFrame:(CGRect)frame{
    
    ZLog(@"%f %f %f %f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height)
    
}

//------------------------------------------------------------------------------------------------------------

-(void)getImageFromServer:(NSString *)urlForImage{
    

    NSString *urlString = [urlForImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:urlString];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        NSData *data = [NSData dataWithContentsOfURL:URL];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(data){
                
                ZLog(@"OK, got image... %@",image)
                
                wineImage = [UIImage imageWithData:data];
                
                UIImage *scaledImage = [UIImage imageWithCGImage:[wineImage CGImage] scale:wineImage.scale * 0.80f orientation:wineImage.imageOrientation];
                
                UIImageView *wineIV = [[UIImageView alloc] initWithImage:scaledImage];
                wineIV.center = self.view.center;
                
                //[self.view addSubview:wineIV];
                
                [myScrollView addSubview:wineIV];
                
                
            } else {
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Image Available."
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                

            }
            
            
        });
    });
    
}

//------------------------------------------------------------------------------------------------------------


@end
