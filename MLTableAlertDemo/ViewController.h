//
//  ViewController.h
//  MLTableAlertDemo
//
//  Version 1.0
//
//  Created by Matteo Del Vecchio on 11/12/12.
//  Copyright (c) 2012 Matthew Labs. All rights reserved.
//  For the complete copyright notice, read Source Code License.
//

#import <UIKit/UIKit.h>

@class MLTableAlert;


@interface ViewController : UIViewController

@property (strong, nonatomic) MLTableAlert *alert;

@property (nonatomic, strong) IBOutlet UITextField *rowsNumField;
@property (nonatomic, strong) IBOutlet UILabel *resultLabel;

-(IBAction)showTableAlert:(id)sender;

@end
