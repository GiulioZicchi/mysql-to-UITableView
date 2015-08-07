//
//  detailViewController.m
//  mysqlTableView
//
//  Created by Giulio Zicchi on 05/08/2015.
//  Copyright © 2015 Giulio Zicchi. All rights reserved.
//

#import "detailViewController.h"

@interface detailViewController ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *lblRegionLabel;
@property (strong, nonatomic) IBOutlet UILabel *lblRegion;
@property (strong, nonatomic) IBOutlet UILabel *lblTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *lblType;
@property (strong, nonatomic) IBOutlet UIImageView *wineIV;


@end

@implementation detailViewController

@synthesize myScrollView,contentView,wineDict, wineImage;


//------------------------------------------------------------------------------------------------------------

- (void)viewDidLoad {
    
    // all straightforward
    // adjust constraints for view inseide scrollview
    // wineDict passed from calling view controller
    // data to labels, then call for image, based on realtive path in passed dictionary

    
    [super viewDidLoad];
    [self constrainLayout];
    
    NSString *wineName = [wineDict valueForKey:@"name"];
    self.name.text = wineName;
    
    self.lblRegionLabel.text = @"Region";
    
    NSString *wineRegion = [wineDict valueForKey:@"area"];
    self.lblRegion.text = wineRegion;
    
    self.lblTypeLabel.text = @"Type";
    
    NSString *wineType = [wineDict valueForKey:@"type"];
    self.lblType.text = wineType;
    
    NSString *image = [wineDict objectForKey:@"gfx"];
    
    NSString *myURL = [NSString stringWithFormat:@"http://www.scenariodevelopments.co.uk/images/vickis/wines/%@",image];
    [self getImageFromServer:myURL];
    

}

//------------------------------------------------------------------------------------------------------------

-(void)constrainLayout{
    
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.0
                                                                       constant:0];
    [self.view addConstraint:leftConstraint];
    
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:0
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.0
                                                                        constant:0];
    [self.view addConstraint:rightConstraint];
    
    
     
}
     


//------------------------------------------------------------------------------------------------------------


-(void)getImageFromServer:(NSString *)urlForImage{
    
    
    // as it says, minimal warning if no image available, either missing in database
    // or network unavailable
    
    NSString *urlString = [urlForImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:urlString];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        NSData *data = [NSData dataWithContentsOfURL:URL];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(data){
                
                wineImage = [UIImage imageWithData:data];
                UIImage *scaledImage = [UIImage imageWithCGImage:[image CGImage] scale:wineImage.scale * 1.0f orientation:wineImage.imageOrientation];
                
                [self.wineIV setImage:scaledImage];
        
                
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
