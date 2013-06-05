//
//  ViewController.m
//  NewMethodHoriztonDemo
//
//  Created by zhenai on 13-5-23.
//  Copyright (c) 2013年 zhenai. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (nonatomic) EasyTableView *horizontalView;

@end

#define SHOW_MULTIPLE_SECTIONS		1		// If commented out, multiple sections with header and footer views are not shown

#define PORTRAIT_WIDTH				280
#define LANDSCAPE_HEIGHT			(480-20)
#define HORIZONTAL_TABLEVIEW_HEIGHT	200
#define VERTICAL_TABLEVIEW_WIDTH	260
#define TABLE_BACKGROUND_COLOR		[UIColor clearColor]

#define BORDER_VIEW_TAG				10

#ifdef SHOW_MULTIPLE_SECTIONS
#define NUM_OF_CELLS			10
#define NUM_OF_SECTIONS			2
#else
#define NUM_OF_CELLS			21
#endif

@implementation ViewController
@synthesize horizontalView;


- (void)dealloc{

    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self setupHorizontalView];
}



#pragma mark -
#pragma mark EasyTableView Initialization

- (void)setupHorizontalView {
	CGRect frameRect	= CGRectMake(20, 0, PORTRAIT_WIDTH, HORIZONTAL_TABLEVIEW_HEIGHT);
	EasyTableView *view	= [[EasyTableView alloc] initWithFrame:frameRect numberOfColumns:NUM_OF_CELLS ofWidth:VERTICAL_TABLEVIEW_WIDTH];
	self.horizontalView = view;
	view.backgroundColor = [UIColor redColor];

	horizontalView.delegate						= self;
	horizontalView.tableView.backgroundColor	= TABLE_BACKGROUND_COLOR;
	horizontalView.tableView.allowsSelection	= YES;
	horizontalView.tableView.separatorColor		= [UIColor darkGrayColor];
	horizontalView.cellBackgroundColor			= [UIColor darkGrayColor];
	//horizontalView.autoresizingMask				= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	horizontalView.tableView.pagingEnabled = YES;
	[self.view addSubview:horizontalView];
}

- (EasyTableView*)createHorizontalViewWithReuseID:(NSString*)reuseID {
	CGRect frameRect	= CGRectMake(0, 0, 320, HORIZONTAL_TABLEVIEW_HEIGHT);
	EasyTableView *view	= [[EasyTableView alloc] initWithFrame:frameRect numberOfColumns:NUM_OF_CELLS ofWidth:VERTICAL_TABLEVIEW_WIDTH];

	view.backgroundColor = [UIColor redColor];
    
	view.delegate						= self;
	view.tableView.backgroundColor	= TABLE_BACKGROUND_COLOR;
	view.tableView.allowsSelection	= YES;
	view.tableView.separatorColor		= [UIColor darkGrayColor];
	view.cellBackgroundColor			= [UIColor darkGrayColor];
	//horizontalView.autoresizingMask				= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	view.tableView.pagingEnabled = NO;
    return view;
}
#pragma mark -
#pragma mark Utility Methods

- (void)borderIsSelected:(BOOL)selected forView:(UIView *)view {
	UIImageView *borderView		= (UIImageView *)[view viewWithTag:BORDER_VIEW_TAG];
	NSString *borderImageName	= (selected) ? @"selected_border.png" : @"image_border.png";
	borderView.image			= [UIImage imageNamed:borderImageName];
}


#pragma mark -
#pragma mark EasyTableViewDelegate

// These delegate methods support both example views - first delegate method creates the necessary views

- (UIView *)easyTableView:(EasyTableView *)easyTableView viewForRect:(CGRect)rect {
	CGRect labelRect		= CGRectMake(10, 10, rect.size.width-20, rect.size.height-20);
	UILabel *label			= [[UILabel alloc] initWithFrame:labelRect];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
	label.textAlignment		= UITextAlignmentCenter;
#else
	label.textAlignment		= NSTextAlignmentCenter;
#endif
	label.textColor			= [UIColor whiteColor];
	label.font				= [UIFont boldSystemFontOfSize:60];
	
	// Use a different color for the two different examples
	if (easyTableView == horizontalView)
		label.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
	else
		label.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
	
	UIImageView *borderView		= [[UIImageView alloc] initWithFrame:label.bounds];
	borderView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	borderView.tag				= BORDER_VIEW_TAG;
	
	[label addSubview:borderView];
    
	return label;
}

// Second delegate populates the views with data from a data source

- (void)easyTableView:(EasyTableView *)easyTableView setDataForView:(UIView *)view forIndexPath:(NSIndexPath *)indexPath {
	UILabel *label	= (UILabel *)view;
	label.text		= [NSString stringWithFormat:@"%i", indexPath.row];
	
	// selectedIndexPath can be nil so we need to test for that condition
	BOOL isSelected = (easyTableView.selectedIndexPath) ? ([easyTableView.selectedIndexPath compare:indexPath] == NSOrderedSame) : NO;
	[self borderIsSelected:isSelected forView:view];
}

// Optional delegate to track the selection of a particular cell

- (void)easyTableView:(EasyTableView *)easyTableView selectedView:(UIView *)selectedView atIndexPath:(NSIndexPath *)indexPath deselectedView:(UIView *)deselectedView {
	[self borderIsSelected:YES forView:selectedView];
	
	if (deselectedView)
		[self borderIsSelected:NO forView:deselectedView];
	
	//UILabel *label	= (UILabel *)selectedView;
	//bigLabel.text	= label.text;
}

#pragma mark -
#pragma mark Optional EasyTableView delegate methods for section headers and footers

#ifdef SHOW_MULTIPLE_SECTIONS

// Delivers the number of sections in the TableView
- (NSUInteger)numberOfSectionsInEasyTableView:(EasyTableView*)easyTableView{
    return 1;
}

// Delivers the number of cells in each section, this must be implemented if numberOfSectionsInEasyTableView is implemented
-(NSUInteger)numberOfCellsForEasyTableView:(EasyTableView *)view inSection:(NSInteger)section {
    return NUM_OF_CELLS;
}

/*
// The height of the header section view MUST be the same as your HORIZONTAL_TABLEVIEW_HEIGHT (horizontal EasyTableView only)
- (UIView *)easyTableView:(EasyTableView*)easyTableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
	label.text = @"HEADER";
	label.textColor = [UIColor whiteColor];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
	label.textAlignment		= UITextAlignmentCenter;
#else
	label.textAlignment		= NSTextAlignmentCenter;
#endif
    
	if (easyTableView == self.horizontalView) {
		label.frame = CGRectMake(0, 0, VERTICAL_TABLEVIEW_WIDTH, HORIZONTAL_TABLEVIEW_HEIGHT);
	}
//	if (easyTableView == self.verticalView) {
//		label.frame = CGRectMake(0, 0, VERTICAL_TABLEVIEW_WIDTH, 20);
//	}
    
    switch (section) {
        case 0:
            label.backgroundColor = [UIColor redColor];
            break;
        default:
            label.backgroundColor = [UIColor blueColor];
            break;
    }
    return label;
}

// The height of the footer section view MUST be the same as your HORIZONTAL_TABLEVIEW_HEIGHT (horizontal EasyTableView only)
- (UIView *)easyTableView:(EasyTableView*)easyTableView viewForFooterInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
	label.text = @"FOOTER";
	label.textColor = [UIColor yellowColor];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
	label.textAlignment		= UITextAlignmentCenter;
#else
	label.textAlignment		= NSTextAlignmentCenter;
#endif
	label.frame = CGRectMake(0, 0, VERTICAL_TABLEVIEW_WIDTH, 20);
    
	if (easyTableView == self.horizontalView) {
		label.frame = CGRectMake(0, 0, VERTICAL_TABLEVIEW_WIDTH, HORIZONTAL_TABLEVIEW_HEIGHT);
	}
//	if (easyTableView == self.verticalView) {
//		label.frame = CGRectMake(0, 0, VERTICAL_TABLEVIEW_WIDTH, 20);
//	}
	
    switch (section) {
        case 0:
            label.backgroundColor = [UIColor purpleColor];
            break;
        default:
            label.backgroundColor = [UIColor brownColor];
            break;
    }
    
    return label;
}
 
*/
#endif

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HORIZONTAL_TABLEVIEW_HEIGHT;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* tag = @"TagCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:tag];
    if(!cell)
    {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tag];
        //[cell addSubview:[self createHorizontalView]];
        CGRect frameRect	= CGRectMake(0, 0, 320, HORIZONTAL_TABLEVIEW_HEIGHT);
        EasyTableView *view	= [[[EasyTableView alloc] initWithStyle:UITableViewCellStyleDefault Frame:frameRect numberOfColumns:NUM_OF_CELLS ofWidth:VERTICAL_TABLEVIEW_WIDTH reuseIdentifier:tag] autorelease];
        
        view.backgroundColor = [UIColor redColor];
        
        view.delegate						= self;
        view.tableView.backgroundColor	= TABLE_BACKGROUND_COLOR;
        view.tableView.allowsSelection	= YES;
        view.tableView.separatorColor		= [UIColor darkGrayColor];
        view.cellBackgroundColor			= [UIColor darkGrayColor];
        //horizontalView.autoresizingMask				= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        view.tableView.pagingEnabled = NO;
        
        cell = view;
    }
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
