//
//  MLTableAlert.m
//
//  Version 1.0
//
//  Created by Matteo Del Vecchio on 11/12/12.
//  Copyright (c) 2012 Matthew Labs. All rights reserved.
//  For the complete copyright notice, read Source Code License.
//

#import "MLTableAlert.h"


#define kTableAlertWidth     284.0
#define kLateralInset         12.0
#define kVerticalInset         8.0
#define kMinAlertHeight      264.0
#define kCancelButtonHeight   44.0
#define kCancelButtonMargin    5.0
#define kTitleLabelMargin     12.0


@interface MLTableAlert ()
@property (nonatomic, strong) UIView *alertBg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cancelButtonTitle;

@property (nonatomic) BOOL cellSelected;

@property (nonatomic, strong) MLTableAlertNumberOfRowsBlock numberOfRows;
@property (nonatomic, strong) MLTableAlertTableCellsBlock cells;

-(void)createBackgroundView;	// Draws and manages the view behind the alert
-(void)animateIn;	 // Animates the alert when it has to be shown
-(void)animateOut;	 // Animates the alert when it has to be dismissed
-(void)dismissTableAlert;	// Dismisses the alert
@end



@implementation MLTableAlert

#pragma mark - MLTableAlert Class Method

+(MLTableAlert *)tableAlertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelBtnTitle numberOfRows:(MLTableAlertNumberOfRowsBlock)rowsBlock andCells:(MLTableAlertTableCellsBlock)cellsBlock
{
	return [[self alloc] initWithTitle:title cancelButtonTitle:cancelBtnTitle numberOfRows:rowsBlock andCells:cellsBlock];
}

#pragma mark - MLTableAlert Initialization

-(id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle numberOfRows:(MLTableAlertNumberOfRowsBlock)rowsBlock andCells:(MLTableAlertTableCellsBlock)cellsBlock
{
	// Throw exception if rowsBlock or cellsBlock is nil
	if (rowsBlock == nil || cellsBlock == nil)
	{
		[[NSException exceptionWithName:@"rowsBlock and cellsBlock Error" reason:@"These blocks MUST NOT be nil" userInfo:nil] raise];
		return nil;
	}
	
	self = [super init];
	if (self)
	{
		_numberOfRows = rowsBlock;
		_cells = cellsBlock;
		_title = title;
		_cancelButtonTitle = cancelButtonTitle;
		_height = kMinAlertHeight;	// Defining default (and minimum) alert height
	}
	
	return self;
}

#pragma mark - Actions

-(void)configureSelectionBlock:(MLTableAlertRowSelectionBlock)selBlock andCompletionBlock:(MLTableAlertCompletionBlock)comBlock
{
	self.selectionBlock = selBlock;
	self.completionBlock = comBlock;
}

-(void)createBackgroundView
{
	// reset cellSelected value
	self.cellSelected = NO;
	
	// adding some styles to background view (behind table alert)
	self.frame = [[UIScreen mainScreen] bounds];
	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
	self.opaque = NO;
	
	// adding it as subview of app's UIWindow
	UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
	[appWindow addSubview:self];
	
	// get background color darker
	[UIView animateWithDuration:0.2 animations:^{
		self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
	}];
}

-(void)animateIn
{
	// UIAlertView-like pop in animation
	self.alertBg.transform = CGAffineTransformMakeScale(0.6, 0.6);
	[UIView animateWithDuration:0.2 animations:^{
		self.alertBg.transform = CGAffineTransformMakeScale(1.1, 1.1);
	} completion:^(BOOL finished){
		[UIView animateWithDuration:1.0/15.0 animations:^{
			self.alertBg.transform = CGAffineTransformMakeScale(0.9, 0.9);
		} completion:^(BOOL finished){
			[UIView animateWithDuration:1.0/7.5 animations:^{
				self.alertBg.transform = CGAffineTransformIdentity;
			}];
		}];
	}];
}

-(void)animateOut
{
	[UIView animateWithDuration:1.0/7.5 animations:^{
		self.alertBg.transform = CGAffineTransformMakeScale(0.9, 0.9);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:1.0/15.0 animations:^{
			self.alertBg.transform = CGAffineTransformMakeScale(1.1, 1.1);
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:0.3 animations:^{
				self.alertBg.transform = CGAffineTransformMakeScale(0.01, 0.01);
				self.alpha = 0.3;
			} completion:^(BOOL finished){
				// table alert not shown anymore
				[self removeFromSuperview];
			}];
		}];
	}];
}

-(void)show
{
	[self createBackgroundView];
	
	// alert view creation
	self.alertBg = [[UIView alloc] initWithFrame:CGRectZero];
	[self addSubview:self.alertBg];
	
	// setting alert background image
	UIImageView *alertBgImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"MLTableAlertBackground.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:30]];
	[self.alertBg addSubview:alertBgImage];
	
	// alert title creation
	self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	self.titleLabel.backgroundColor = [UIColor clearColor];
	self.titleLabel.textColor = [UIColor whiteColor];
	self.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
	self.titleLabel.shadowOffset = CGSizeMake(0, -1);
	self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
	self.titleLabel.frame = CGRectMake(kLateralInset, 15, kTableAlertWidth - kLateralInset * 2, 22);
	self.titleLabel.text = self.title;
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	[self.alertBg addSubview:self.titleLabel];
	
	// table view creation
	self.table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	self.table.frame = CGRectMake(kLateralInset, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + kTitleLabelMargin, kTableAlertWidth - kLateralInset * 2, (self.height - kVerticalInset * 2) - self.titleLabel.frame.origin.y - self.titleLabel.frame.size.height - kTitleLabelMargin - kCancelButtonMargin - kCancelButtonHeight);
	self.table.layer.cornerRadius = 6.0;
	self.table.layer.masksToBounds = YES;
	self.table.delegate = self;
	self.table.dataSource = self;
	self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.table.backgroundView = [[UIView alloc] init];
	[self.alertBg addSubview:self.table];
	
	// setting white-to-gray gradient as table view's background
	CAGradientLayer *tableGradient = [CAGradientLayer layer];
	tableGradient.frame = CGRectMake(0, 0, self.table.frame.size.width, self.table.frame.size.height);
	tableGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:174.0/255.0 green:174.0/255.0 blue:174.0/255.0 alpha:1.0] CGColor], nil];
	[self.table.backgroundView.layer insertSublayer:tableGradient atIndex:0];
	
	// adding inner shadow mask on table view
	UIImageView *maskShadow = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"MLTableAlertShadowMask.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:7]];
	maskShadow.userInteractionEnabled = NO;
	maskShadow.layer.masksToBounds = YES;
	maskShadow.layer.cornerRadius = 5.0;
	maskShadow.frame = self.table.frame;
	[self.alertBg addSubview:maskShadow];
	
	// cancel button creation
	self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.cancelButton.frame = CGRectMake(kLateralInset, self.table.frame.origin.y + self.table.frame.size.height + kCancelButtonMargin, kTableAlertWidth - kLateralInset * 2, kCancelButtonHeight);
	self.cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
	self.cancelButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
	self.cancelButton.titleLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
	[self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
	[self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[self.cancelButton setBackgroundColor:[UIColor clearColor]];
	[self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
	[self.cancelButton setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButtonPressed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateHighlighted];
	self.cancelButton.opaque = NO;
	self.cancelButton.layer.cornerRadius = 5.0;
	[self.cancelButton addTarget:self action:@selector(dismissTableAlert) forControlEvents:UIControlEventTouchUpInside];
	[self.alertBg addSubview:self.cancelButton];
	
	// setting alert and alert background image frames
	self.alertBg.frame = CGRectMake((self.frame.size.width - kTableAlertWidth) / 2, (self.frame.size.height - self.height) / 2, kTableAlertWidth, self.height - kVerticalInset * 2);
	alertBgImage.frame = CGRectMake(0.0, 0.0, kTableAlertWidth, self.height);
	
	// the alert will be the first responder so any other controls,
	// like the keyboard, will be dismissed before the alert
	[self becomeFirstResponder];
	
	// show the alert with animation
	[self animateIn];
}

-(void)dismissTableAlert
{
	// dismiss the alert with its animation
	[self animateOut];
	
	// perform actions contained in completionBlock if the
	// cancel button of the alert has been pressed
	// if completionBlock == nil, nothing is performed
	if (self.completionBlock != nil)
		if (!self.cellSelected)
			self.completionBlock();
}

// Allows the alert to be first responder
-(BOOL)canBecomeFirstResponder
{
	return YES;
}

// Alert height setter
-(void)setHeight:(CGFloat)height
{
	if (height > kMinAlertHeight)
		_height = height;
	else
		_height = kMinAlertHeight;
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// TODO: Allow multiple sections
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// according to the numberOfRows block code
	return self.numberOfRows(section);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// according to the cells block code
	return self.cells(self, indexPath);
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	// set cellSelected to YES so the completionBlock won't be
	// executed because a cell has been pressed instead of the cancel button
	self.cellSelected = YES;
	// dismiss the alert
	[self dismissTableAlert];
	
	// perform actions contained in the selectionBlock if it isn't nil
	// add pass the selected indexPath
	if (self.selectionBlock != nil)
		self.selectionBlock(indexPath);
}

@end
