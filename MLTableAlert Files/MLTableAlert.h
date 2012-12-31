//
//  MLTableAlert.h
//
//  Version 1.0
//
//  Created by Matteo Del Vecchio on 11/12/12.
//  Copyright (c) 2012 Matthew Labs. All rights reserved.
//  For the complete copyright notice, read Source Code License.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class MLTableAlert;


// Blocks definition for table view management
typedef NSInteger (^MLTableAlertNumberOfRowsBlock)(NSInteger section);
typedef UITableViewCell* (^MLTableAlertTableCellsBlock)(MLTableAlert *alert, NSIndexPath *indexPath);
typedef void (^MLTableAlertRowSelectionBlock)(NSIndexPath *selectedIndex);
typedef void (^MLTableAlertCompletionBlock)(void);


@interface MLTableAlert : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) MLTableAlertCompletionBlock completionBlock;	// Called when Cancel button pressed
@property (nonatomic, strong) MLTableAlertRowSelectionBlock selectionBlock;	// Called when a row in table view is pressed


// Classe method; rowsBlock and cellsBlock MUST NOT be nil 
+(MLTableAlert *)tableAlertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelBtnTitle numberOfRows:(MLTableAlertNumberOfRowsBlock)rowsBlock andCells:(MLTableAlertTableCellsBlock)cellsBlock;

// Initialization method; rowsBlock and cellsBlock MUST NOT be nil
-(id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelBtnTitle numberOfRows:(MLTableAlertNumberOfRowsBlock)rowsBlock andCells:(MLTableAlertTableCellsBlock)cellsBlock;

// Allows you to perform custom actions when a row is selected or the cancel button is pressed
-(void)configureSelectionBlock:(MLTableAlertRowSelectionBlock)selBlock andCompletionBlock:(MLTableAlertCompletionBlock)comBlock;

// Show the alert
-(void)show;

@end

