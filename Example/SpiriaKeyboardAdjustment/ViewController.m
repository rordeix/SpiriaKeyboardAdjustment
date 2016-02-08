//
//  SpiriaViewController.m
//  SpiriaKeyboardAdjustment
//
//  Created by rordeix on 02/05/2016.
//  Copyright (c) 2016 rordeix. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(IBAction)hideKeyboardBtnPressed:(id)sender {
    [self.view endEditing:YES];
}
@end
