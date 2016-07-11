//
//  ViewController+KeyboardAdjustment.h
//  TestKeyboardRelayout
//
//  Created by Rodrigo Ordeix on 2/4/16.
//  Copyright © 2016 Spiria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SpiriaKeyboardAdjustment)
@property(strong,nonatomic) IBOutlet NSLayoutConstraint *adjustBottomConstraint;
@property(readonly) BOOL shouldAutoAdjustScreen;
-(void)keyboardWillShow:(NSNotification*)notification;
-(void)keyboardWillHide:(NSNotification*)notification;
@end
