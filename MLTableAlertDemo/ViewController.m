//
//  ViewController.m
//  MLTableAlertDemo
//
//  Version 1.0
//
//  Created by Matteo Del Vecchio on 11/12/12.
//  Copyright (c) 2012 Matthew Labs. All rights reserved.
//  For the complete copyright notice, read Source Code License.
//

#import "ViewController.h"
#import "MLTableAlert.h"


@interface ViewController ()
@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(IBAction)showTableAlert:(id)sender
{
	// create the alert
	self.alert = [MLTableAlert tableAlertWithTitle:@"Choose an option..." cancelButtonTitle:@"Cancel" numberOfRows:^NSInteger (NSInteger section)
	{
		if (self.rowsNumField.text == nil || [self.rowsNumField.text length] == 0 || [self.rowsNumField.text isEqualToString:@"0"])
			return 1;
		else
			return [self.rowsNumField.text integerValue];
	}
	andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
	{
		static NSString *CellIdentifier = @"CellIdentifier";
		UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil)
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		
		cell.textLabel.text = [NSString stringWithFormat:@"Section %d Row %d", indexPath.section, indexPath.row];
		
		return cell;
	}];
	
	// Setting custom alert height
	self.alert.height = 350;
	
	// configure actions to perform
	[self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
		self.resultLabel.text = [NSString stringWithFormat:@"Selected Index\nSection: %d Row: %d", selectedIndex.section, selectedIndex.row];
	} andCompletionBlock:^{
		self.resultLabel.text = @"Cancel Button Pressed\nNo Cells Selected";
	}];
	
	// show the alert
	[self.alert show];
}

@end
