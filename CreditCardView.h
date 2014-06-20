//
//  CreditCardView.h
//  CreditCard
//
//  Created by Home on 6/20/14.
//  Copyright (c) 2014 APR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CreditCardView;
@protocol CreditCardDelegate <NSObject>
- (void)creditCardCompleted:(BOOL)creditCardValid withCreditCardNumber:(NSString *)cardNumber withExpirationDate:(NSString *)expirationDate withCVVNumber:(NSString *)cvv;
@end

@interface CreditCardView : UIView <UITextFieldDelegate>

@property (nonatomic, weak) id <CreditCardDelegate> delegate;

- (void)dismissAllKeyboards;

- (id)initWithFrame:(CGRect)frame AndTextColor:(UIColor *)textColor AndFontSize:(CGFloat)fontSize;

@property (strong, nonatomic) UIColor *textColor;
@property (nonatomic) CGFloat fontSize;

@end
