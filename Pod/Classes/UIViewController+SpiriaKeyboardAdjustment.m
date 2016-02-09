//
//  ViewController+KeyboardAdjustment.m
//  TestKeyboardRelayout
//
//  Created by Rodrigo Ordeix on 2/4/16.
//  Copyright © 2016 Spiria. All rights reserved.
//

#import "UIViewController+SpiriaKeyboardAdjustment.h"
#import <objc/runtime.h>

#pragma mark - UIViewController (SpiriaKeyboardAdjustmentExtraProperties)
// This classs exists just to keep track of the original values and hide it from the main interface extension
static char const * const kKeyboardAdjustmentAdjustOriginalConstraintValue = "kKeyboardAdjustmentAdjustOriginalConstraintValue";
static char const * const kKeyboardAdjustmentAdjustOriginalFrame = "kKeyboardAdjustmentAdjustOriginalFrame";

@interface UIViewController (SpiriaKeyboardAdjustmentExtraProperties)
@property(nonatomic) CGFloat originalBottomConstraintValue;
@property(nonatomic) CGRect originalViewFrame;
@end

@implementation UIViewController (SpiriaKeyboardAdjustmentExtraProperties)
@dynamic originalBottomConstraintValue;
@dynamic originalViewFrame;

-(CGFloat)originalBottomConstraintValue {
    return [objc_getAssociatedObject(self, kKeyboardAdjustmentAdjustOriginalConstraintValue) doubleValue];
}

-(void)setOriginalBottomConstraintValue:(CGFloat)originalBottomConstraintValue {
    objc_setAssociatedObject(self, kKeyboardAdjustmentAdjustOriginalConstraintValue, [NSNumber numberWithDouble:originalBottomConstraintValue], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGRect)originalViewFrame {
    return [objc_getAssociatedObject(self, kKeyboardAdjustmentAdjustOriginalFrame) CGRectValue];
}

-(void)setOriginalViewFrame:(CGRect)originalViewFrame {
    objc_setAssociatedObject(self, kKeyboardAdjustmentAdjustOriginalFrame, [NSValue valueWithCGRect:originalViewFrame], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark - UIViewController (SpiriaKeyboardAdjustment)
static char const * const kKeyboardAdjustmentAdjustBottomConstraint = "kKeyboardAdjustmentAdjustBottomConstraint";

@implementation UIViewController (SpiriaKeyboardAdjustment)

#pragma mark Properties
@dynamic adjustBottomConstraint;

-(NSLayoutConstraint*)adjustBottomConstraint {
    return objc_getAssociatedObject(self, kKeyboardAdjustmentAdjustBottomConstraint);
}

-(void)setAdjustBottomConstraint:(NSLayoutConstraint*)adjustBottomConstraint {
    objc_setAssociatedObject(self, kKeyboardAdjustmentAdjustBottomConstraint, adjustBottomConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)shouldAutoAdjustScreen {
    return YES;
}

#pragma mark - Method Swizzling
// We swizz (since we cannot override and invoke super method from extensions) the methods:
// viewDidLoad to keep track of the original values (constraint and frame)
// viewWillAppear and viewWillDisappear to add/remove notification handlers
+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void (^swizleSelectors)(Class, SEL, SEL) = ^(Class class, SEL originalSelector, SEL swizzledSelector) {
            Method originalMethod = class_getInstanceMethod(class, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

            BOOL didAddMethod = class_addMethod(class,
                                                originalSelector,
                                                method_getImplementation(swizzledMethod),
                                                method_getTypeEncoding(swizzledMethod));

            if (didAddMethod) {
                class_replaceMethod(class,
                                    swizzledSelector,
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        };

        swizleSelectors([self class], @selector(viewDidLoad), @selector(keyboardAdjustmentViewDidLoad));
        swizleSelectors([self class], @selector(viewWillAppear:), @selector(keyboardAdjustmentViewWillAppear:));
        swizleSelectors([self class], @selector(viewWillDisappear:), @selector(keyboardAdjustmentViewWillDisappear:));
    });
}

-(void)keyboardAdjustmentViewDidLoad {
    [self keyboardAdjustmentViewDidLoad];
    if (self.adjustBottomConstraint) {
        self.originalBottomConstraintValue = self.adjustBottomConstraint.constant;
    } else {
        self.originalBottomConstraintValue = 0.0;
    }
    self.originalViewFrame = self.view.frame;
}

-(void)keyboardAdjustmentViewWillAppear:(BOOL)animated {
    [self keyboardAdjustmentViewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

-(void)keyboardAdjustmentViewWillDisappear:(BOOL)animated {
    [self.view endEditing:YES];
    [self keyboardAdjustmentViewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark Keyboard Notifications handlers
-(void)keyboardWillHide:(NSNotification*)notification {
    if (self.shouldAutoAdjustScreen) {
        NSDictionary *userInfo = notification.userInfo;
        [self adjustLayout:self.originalBottomConstraintValue userInfo:userInfo];
    }
}

-(void)keyboardWillShow:(NSNotification*)notification {
    if (self.shouldAutoAdjustScreen) {
        NSDictionary *userInfo = notification.userInfo;
        NSValue *keyboardFrame = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [keyboardFrame CGRectValue];
        [self adjustLayout:(keyboardRect.size.height + self.originalBottomConstraintValue) userInfo:userInfo];
    }
}

-(void)adjustLayout:(CGFloat)value userInfo:(NSDictionary*)userInfo {
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    BOOL usingConstraint = self.adjustBottomConstraint != nil;

    if (usingConstraint) {
        self.adjustBottomConstraint.constant = value;
    }
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        if (usingConstraint) {
            [self.view layoutIfNeeded];
        } else {
            CGRect newFrame = self.originalViewFrame;
            newFrame.size.height = newFrame.size.height - value;
            self.view.frame = newFrame;
        }
    } completion:nil];
}

@end
