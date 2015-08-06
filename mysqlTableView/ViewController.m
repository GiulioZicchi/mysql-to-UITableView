
//
//  ViewController.m
//  mysqlTableView
//
//  Created by Giulio Zicchi on 26/07/2015.
//  Copyright (c) 2015 Giulio Zicchi. All rights reserved.
//
//------------------------------------------------------------------------------------------------------------
// demonstration of populating a UITableView with json data from a remote server
//
// creates custom expanding / collapsing headers from fields in a mySql wine database
//
//------------------------------------------------------------------------------------------------------------


#import "ViewController.h"
#import "gzHTTP.h"

@interface ViewController ()

@end

@implementation ViewController{
    
    UITableView     *myTableView;
    gzHTTP          *myHTTP;
    
    NSMutableArray  *countries;
    NSMutableArray  *wines;
    NSMutableArray  *winesCopy;
    NSMutableArray  *headerViews;

}

@synthesize myNavigationController,myDetailVC,myUserInfo,popOver,mask;

static int urlCMD;
static bool collapsed[0];


//------------------------------------------------------------------------------------------------------------

- (void)viewDidLoad {

    [super viewDidLoad];
    
    //--------------------------------------------------------------------
    // register self as receiver of these notifications
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(webJsonDataRetrieved:)
                                                 name:@"webJsonDataRetrieved"
                                               object:nil];
    
    //--------------------------------------------------------------------
    // initialise relevant arrays
    
    wines = [NSMutableArray new];
    myUserInfo = [NSMutableArray new];
    
    //--------------------------------------------------------------------
    // initial appearance
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                               target:self
                               action:@selector(refresh)];
    self.navigationItem.leftBarButtonItem = button;

    self.title = @"mySql Data to UITableView";
    self.view.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    
    //--------------------------------------------------------------------
    // initialise tableview
    
    myTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.sectionHeaderHeight = 0.0f;
    myTableView.sectionFooterHeight = 0.0f;
    myTableView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    myTableView.autoresizesSubviews = true;
    
    [self.view addSubview:myTableView];
    
    //--------------------------------------------------------------------
    // instantiate singleton, and make first call for data
    
    myHTTP = [gzHTTP getInstance];
    
    [self refresh];
    

}


//------------------------------------------------------------------------------------------------------------

-(void)refresh{
    
    countries = [NSMutableArray new];
    
    NSString *myURL = [NSString stringWithFormat:@"http://www.scenariodevelopments.co.uk/ios/demodata.php?cmd=%d",CMD_COUNTRIES];
    urlCMD = CMD_COUNTRIES;
    
    [myHTTP serverJsonRequest:myURL];
}

//------------------------------------------------------------------------------------------------------------


-(void)webJsonDataRetrieved:(NSNotification *)notification{
    
    // triggers methods accordingly
    
    switch (urlCMD) {
        case CMD_COUNTRIES:
            [self decodeCountries:notification];
            break;
            
        case CMD_WINES:
            [self decodeWines:notification];
            break;
            
        default:
            break;
    }
    
}

//---------------------------------------------------------------------

-(void)decodeCountries:(NSNotification *)notification{
    
    for(NSDictionary *dict in notification.userInfo){
        
        [countries addObject:dict];
    }
    
    long size = [countries count];
    collapsed[0] = malloc( sizeof(int) * size ) ;
    collapsed[0] = false;

    NSString *myURL = [NSString stringWithFormat:@"http://www.scenariodevelopments.co.uk/ios/demodata.php?cmd=%d",CMD_WINES];
    urlCMD = CMD_WINES;
    
    [myHTTP serverJsonRequest:myURL];

    
}

//---------------------------------------------------------------------

-(void)decodeWines:(NSNotification *)notification{
    
    for(NSDictionary *dictCountry in countries){
        
        NSMutableArray *tmpWine = [NSMutableArray new];
        
        NSString *countryID = [dictCountry objectForKey:@"countryid"];
        
        for(NSDictionary *dictWine in notification.userInfo){
            
            if([[dictWine objectForKey:@"countryid"] isEqualToString:countryID]){
                [tmpWine addObject:dictWine];
            }
            
        }
        
        [wines addObject:tmpWine];
        
    }
    
    winesCopy = [[NSMutableArray alloc] initWithArray:wines];
    
    [myTableView reloadData];
    
    
}

//------------------------------------------------------------------------------------------------------------

-(void)rebuildWines{

    [wines removeAllObjects];
    
    for(NSDictionary *dict in winesCopy){
        
        [wines addObject:dict];
        
    }
    
}

//------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------

#pragma mark tableview and datasource delegates


- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section{
    
    
    //-----------------------------------------------------------------------------------
    // this delegate method fires before viewForHeader, so we initialise view array
    // here on condition that is is nil
    // viewForHeader then uses that array for its views
    // since this fires for all headers, while viewForHeader only fires for visible
    // headers, this method is the place to do dynamic header changes
    //-----------------------------------------------------------------------------------
    
    if(headerViews == nil){
        
        headerViews = [NSMutableArray new];
        
        for(int lp = 0 ; lp < [self numberOfSectionsInTableView:myTableView] ; lp++){

            gzCustomHeader *newCustomHeader = [gzCustomHeader new];
            [headerViews addObject:newCustomHeader];
        
        }

    }
    
    //-----------------------------------------------------------------------------------
    // data for rows, matching section to countries for index
    // collapsed boolean array deafults to 0 = collapsed
    //-----------------------------------------------------------------------------------
    
    NSMutableArray *winesPerCountry = [wines objectAtIndex:section];
    NSInteger wineCount = [winesPerCountry count];
    gzCustomHeader *tempHeaderInfo = [headerViews objectAtIndex:section];
    UIView *tmpView = tempHeaderInfo.viewForHeader;
    
    if(!collapsed[section]){
        
        // header appearance attributes when closed
        
        tempHeaderInfo.indicator.image = [UIImage imageNamed:@"caretClosed"];
        tmpView.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
        

    } else {
        
        // header appearance attributes when open
        
        tempHeaderInfo.indicator.image = [UIImage imageNamed:@"caretOpen"];
        tmpView.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
        
    }
    
    
    return !collapsed[section] ? 0 : wineCount;
    
    
}

//------------------------------------------------------------------------------------------------------------

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // bog standard cell operations
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    NSMutableArray *winePerCountry = [wines objectAtIndex:indexPath.section];
    NSDictionary *dictWine = [winePerCountry objectAtIndex:indexPath.row];
    
    NSString *wineName = [dictWine objectForKey:@"name"];
    NSString *wineType = [dictWine objectForKey:@"type"];
    
    if(wineName){
        
        cell.textLabel.text = wineName;
        cell.detailTextLabel.text = wineType;
        cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        

    }
    
    return cell;
    
}

//------------------------------------------------------------------------------------------------------------

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{

    [self displayDetailViewController:indexPath];
    
}

//------------------------------------------------------------------------------------------------------------

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

//------------------------------------------------------------------------------------------------------------

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    // section headers are the countries from db
    
    return [countries count];
    
}

//------------------------------------------------------------------------------------------------------------

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    // applied in view for header
    
    return nil;
    
}

//------------------------------------------------------------------------------------------------------------

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    // arbitrary height, deemed to look ok
    
    return 48.0f;
    
}

//------------------------------------------------------------------------------------------------------------

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    // no footers in this demo
    
    return 0.0f;
    
}


//------------------------------------------------------------------------------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // display viewcontroller bearing data according to selected row
    
    [self displayDetailViewController:indexPath];
    
}

//------------------------------------------------------------------------------------------------------------

// called from both 'didSelectRow', and 'accessoryButtonTapped...'

-(void)displayDetailViewController:(NSIndexPath *)indexPath{
    
    NSMutableArray *wineCountries = [wines objectAtIndex:indexPath.section];
    NSDictionary *wineInfo = [wineCountries objectAtIndex:indexPath.row];
    
    myDetailVC = [[detailViewController alloc] init];
    myDetailVC.wineDict = wineInfo;
    
    [self.navigationController pushViewController:myDetailVC animated:YES];
    
    
}

//------------------------------------------------------------------------------------------------------------


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    // this only fires for onscreen headers, so grab pertinent info from array
    // before adding touch handler and common attributes
    
    gzCustomHeader *headerInfo = [headerViews objectAtIndex:section];
    UIView *headerView = headerInfo.viewForHeader;
    
    headerView.frame = CGRectMake(0, 0, myTableView.frame.size.width, 22);
    headerView.tag = section;
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [headerView addGestureRecognizer:gr];
    
    headerView.layer.borderColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f].CGColor;
    headerView.layer.borderWidth = 1.0;
    
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(44, 14, tableView.frame.size.width - 44, 22);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18.0];

    
    NSDictionary *dictCountry = [countries objectAtIndex:section];
    NSString *strCountry = [dictCountry objectForKey:@"country"];
    headerLabel.text = strCountry;
    
    [headerView addSubview:headerLabel];

    return headerView;

    
}

//------------------------------------------------------------------------------------------------------------


-(void)tapped:(UITapGestureRecognizer *)sender{
    
    //-----------------------------------------------------------------------------------
    // tapped view has tag set for index
    // flip collapsed/expanded status, then build index paths according to how many
    // rows we are about to display, zero for collapsed (obviously) and number of wines
    // per counry from db when expanded
    // simplest thing to do here, as we are not allowing editing/deletion, is to
    // overwrite dictionary at index with nil, but rebuild it from copy when expanded
    //-----------------------------------------------------------------------------------


    int section = (int)sender.view.tag;

    collapsed[section] = !collapsed[section];
    
    long numOfRows = [myTableView numberOfRowsInSection:section];
    NSArray* indexPaths = [self indexPathsForSection:section withNumberOfRows:(int)numOfRows];
    
    NSDictionary *cleared = [NSDictionary new];
    
    [wines setObject:cleared atIndexedSubscript:section];
    
    if(numOfRows > 0){
    
        [myTableView beginUpdates];
        [myTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [myTableView endUpdates];
    
    } else {
        
        [self rebuildWines];
    
        NSDictionary *rebuiltDict = [wines objectAtIndex:section];
        long numOfRows = [rebuiltDict count];
        NSArray *indexPaths = [self indexPathsForSection:section withNumberOfRows:(int)numOfRows];
        
        [myTableView beginUpdates];
        [myTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [myTableView endUpdates];
        
    }
    
}

//-------------------------------------------------------------------------------------

-(NSArray*) indexPathsForSection:(int)section withNumberOfRows:(int)numberOfRows{
    
    // what it says...
    
    NSMutableArray* indexPaths = [NSMutableArray new];
    
    for (int i = 0; i < numberOfRows; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

//------------------------------------------------------------------------------------------------------------

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    // handle rotations when multiple orientations allowed
    // presently just accounts for tableview resize

    CGSize contentSize = myTableView.contentSize;
    contentSize.width = myTableView.bounds.size.width;
    myTableView.contentSize = contentSize;

}

//------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------


@end
