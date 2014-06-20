//
//  ViewController.m
//  CreditCard
//
//  Created by Home on 6/18/14.
//  Copyright (c) 2014 APR. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate, CreditCardDelegate>

@property (strong, nonatomic) CreditCardView *creditCardView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.creditCardView = [[CreditCardView alloc] initWithFrame:CGRectMake(0, 100, 320, 100)];
    self.creditCardView.delegate = self;
    [self.view addSubview:self.creditCardView];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard
{
    [self.creditCardView dismissAllKeyboards];
}

- (void)creditCardCompleted:(BOOL)creditCardValid withCreditCardNumber:(NSString *)cardNumber withExpirationDate:(NSString *)expirationDate withCVVNumber:(NSString *)cvv
{
    NSLog(@"XXX");
    
}

@end
