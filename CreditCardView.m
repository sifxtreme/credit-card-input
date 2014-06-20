//
//  CreditCardView.m
//  CreditCard
//
//  Created by Home on 6/20/14.
//  Copyright (c) 2014 APR. All rights reserved.
//

#import "CreditCardView.h"

@interface CreditCardView ()

@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;

@property (strong, nonatomic) UIImageView *cardImage;

@property (strong, nonatomic) UIView *cardView;
@property (strong, nonatomic) UITextField *cardField;
@property (strong, nonatomic) UITextField *lastFourField;
@property (strong, nonatomic) UITextField *expirationField;
@property (strong, nonatomic) UITextField *cvvField;

@property (strong, nonatomic) NSString *creditCardType;
@property (nonatomic) BOOL isBackspace;
@property (nonatomic) BOOL creditCardValid;
@property (nonatomic) CGFloat lastFourStartingPoint;
@property (strong, nonatomic) NSDateComponents *components;

@end

@implementation CreditCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupCreditCardView];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndTextColor:(UIColor *)textColor AndFontSize:(CGFloat)fontSize
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.textColor = textColor;
        self.fontSize = fontSize;
        [self setupCreditCardView];
        
    }
    return self;
}

#pragma mark - SETUP METHODS

- (void)setupCreditCardView
{
    [self viewTouchSetup];
    [self setupProperties];
    [self setupCreditCardImage];
    [self setupCardView];
}

- (void)setupProperties
{
    self.creditCardType = @"blankcc";
    self.isBackspace = NO;
    self.creditCardType = NO;
    self.components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.screenWidth = screenRect.size.width;
    self.screenHeight = screenRect.size.height;
    
    if(self.textColor == nil){
        self.textColor = [UIColor blackColor];
    }
    if(!self.fontSize){
        self.fontSize = 14.0f;
    }

}

- (void)setupCreditCardImage
{
    CGFloat leftPadding = 25;
    CGFloat topPadding = 5;
    CGFloat width = 54.0f/2;
    CGFloat height = 38.0f/2;
    
    CGRect frame = CGRectMake(leftPadding, topPadding, width, height);
    self.cardImage = [[UIImageView alloc] initWithFrame:frame];
    self.cardImage.image = [UIImage imageNamed:@"blankcc"];
    
    [self addSubview:self.cardImage];
}

- (void)setupCardView
{
    CGFloat leftPadding = self.cardImage.frame.origin.x + self.cardImage.frame.size.width + 10;
    CGFloat topPadding = 0;
    CGFloat width = self.screenWidth - leftPadding - 20;
    CGFloat height = 30;
    
    CGRect frame = CGRectMake(leftPadding, topPadding, width, height);
    self.cardView = [[UIView alloc] initWithFrame:frame];
    
    [self addSubview:self.cardView];
    
    [self setupCardTextFields];
}

- (void)setupCardTextFields
{
    [self setupCardField];
    [self setupLastFourField];
    [self setupExpirationField];
    [self setupCVVField];
}

- (void)setupCardField
{
    CGFloat leftPadding = 0;
    CGFloat topPadding = 0;

    CGRect frame = CGRectMake(leftPadding, topPadding, self.cardView.frame.size.width, self.cardView.frame.size.height);
    self.cardField = [[UITextField alloc] initWithFrame:frame];
    self.cardField.keyboardType = UIKeyboardTypeNumberPad;
    [self.cardField setBorderStyle:UITextBorderStyleNone];
    self.cardField.font = [UIFont systemFontOfSize:self.fontSize];
    self.cardField.placeholder = @"1234 5678 9012 3456";
    self.cardField.delegate = self;
    [self.cardField addTarget:self
                       action:@selector(creditCardTextFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    
    [self.cardView addSubview:self.cardField];
}

- (void)setupLastFourField
{
    self.lastFourField = [[UITextField alloc] init];
    self.lastFourField.keyboardType = UIKeyboardTypeNumberPad;
    [self.lastFourField setBorderStyle:UITextBorderStyleNone];
    self.lastFourField.font = [UIFont systemFontOfSize:self.fontSize];
    self.lastFourField.placeholder = @"1234";
    self.lastFourField.delegate = self;
    [self.lastFourField addTarget:self
                       action:@selector(lastFourTextFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    
    [self.cardView addSubview:self.lastFourField];
}

- (void)setupExpirationField
{
    self.expirationField = [[UITextField alloc] init];
    self.expirationField.keyboardType = UIKeyboardTypeNumberPad;
    [self.expirationField setBorderStyle:UITextBorderStyleNone];
    self.expirationField.font = [UIFont systemFontOfSize:self.fontSize];
    self.expirationField.placeholder = @"MM/YY";
    self.expirationField.delegate = self;
    [self.expirationField addTarget:self
                       action:@selector(expirationFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    
    [self.cardView addSubview:self.expirationField];
}

- (void)setupCVVField
{
    self.cvvField = [[UITextField alloc] init];
    self.cvvField.keyboardType = UIKeyboardTypeNumberPad;
    [self.cvvField setBorderStyle:UITextBorderStyleNone];
    self.cvvField.font = [UIFont systemFontOfSize:self.fontSize];
    self.cvvField.placeholder = @"CVV";
    self.cvvField.delegate = self;
    [self.cvvField addTarget:self
                       action:@selector(cvvFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    
    [self.cardView addSubview:self.cvvField];
}

- (void)viewTouchSetup
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAllKeyboards)];
    [self addGestureRecognizer:tap];
}

#pragma mark - Credit Card Functions

- (void)creditCardTextFieldDidChange:(id)sender
{
    NSString *creditCardText = self.cardField.text;
    int creditCardStringLength = [[creditCardText stringByReplacingOccurrencesOfString:@" " withString:@""] length];
    BOOL checkCreditCard = NO;
    
    if(![self.creditCardType isEqualToString:@"amex"]){
        if(creditCardStringLength == 4 || creditCardStringLength == 8 || creditCardStringLength == 12){
            if(self.isBackspace){
                creditCardText = [creditCardText substringToIndex:[creditCardText length] - 1];
            }
            else{
                creditCardText = [creditCardText stringByAppendingString:@" "];
            }
        }
        
        if(creditCardStringLength == 16) checkCreditCard = YES;
    }
    else{
        if(creditCardStringLength == 4 || creditCardStringLength == 10){
            if(self.isBackspace){
                creditCardText = [creditCardText substringToIndex:[creditCardText length] - 1];
            }
            else{
                creditCardText = [creditCardText stringByAppendingString:@" "];
            }
        }
        
        if(creditCardStringLength == 15) checkCreditCard = YES;
    }
    
    self.cardField.text = creditCardText;
    if(self.isBackspace == YES) self.isBackspace = NO;
    [self whichTypeOfCard:creditCardText];
    
    if(checkCreditCard) [self creditCardHasBeenFilled];
}

- (void)lastFourTextFieldDidChange:(id)sender
{
    [self.lastFourField resignFirstResponder];
    [self.cardField becomeFirstResponder];
    
    [UIView animateWithDuration:0.25
     animations:^{
         self.cardField.alpha = 1.0;
         self.cardField.frame = CGRectMake(self.lastFourField.frame.origin.x, self.cardField.frame.origin.y, self.cardField.frame.size.width, self.cardField.frame.size.height);
         self.lastFourField.frame = CGRectMake(self.lastFourStartingPoint, self.cardField.frame.origin.y, 40, self.cardField.frame.size.height);
         
     }];
    
    [self.lastFourField setHidden:YES];
    [self.expirationField setHidden:YES];
    [self.cvvField setHidden:YES];
    
    self.cardField.text = [self.cardField.text substringToIndex:[self.cardField.text length] - 1];
}

- (void)creditCardHasBeenFilled
{
    NSString *cardText = self.cardField.text;
    self.creditCardValid = [self luhnCheck:[cardText stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    // if the card is not valid set the color to red
    if(self.creditCardValid){
        self.lastFourField.textColor = self.textColor;
    }
    else{
        self.lastFourField.textColor = [UIColor redColor];
    }
    
    UITextPosition *beginning = self.cardField.beginningOfDocument;
    UITextPosition *start = [self.cardField positionFromPosition:beginning offset:[cardText length] - 4];
    CGRect startingPoint = [self.cardField caretRectForPosition:start];
    self.lastFourStartingPoint = self.cardField.frame.origin.x + startingPoint.origin.x;
    
    NSString *lastFour = [self.cardField.text substringFromIndex:[self.cardField.text length] - 4];
    self.lastFourField.text = lastFour;
    self.lastFourField.frame = CGRectMake(self.lastFourStartingPoint, self.cardField.frame.origin.y, 40, self.cardField.frame.size.height);
    
    [self.cardField resignFirstResponder];
    [self.lastFourField setHidden:NO];
    self.expirationField.frame = CGRectMake(self.cardField.frame.origin.x + 70, self.cardField.frame.origin.y, 50, self.cardField.frame.size.height);
    self.cvvField.frame = CGRectMake(self.expirationField.frame.origin.x + 40 + 40, self.cardField.frame.origin.y, 50, self.cardField.frame.size.height);
    [UIView animateWithDuration:0.5
    animations:^{
        self.cardField.alpha = 0.0;
        self.lastFourField.frame = CGRectMake(self.cardField.frame.origin.x, self.cardField.frame.origin.y, 40, self.cardField.frame.size.height);
        self.cardField.frame = CGRectMake(-100, self.cardField.frame.origin.y, self.cardField.frame.size.width, self.cardField.frame.size.height);
        [self.expirationField setHidden:NO];
        [self.cvvField setHidden:NO];
    }];
    
    [self.expirationField becomeFirstResponder];
}

- (void)expirationFieldDidChange:(id)sender
{
    NSString *expirationText = self.expirationField.text;
    if([expirationText length] == 2){
        if(self.isBackspace){
            expirationText = [expirationText substringToIndex:[expirationText length] - 1];
        }
        else{
            expirationText = [expirationText stringByAppendingString:@"/"];
        }
    }
    self.expirationField.text = expirationText;
    
    if(self.isBackspace == YES) self.isBackspace = NO;
    
    if([expirationText length] == 5){
        [self.expirationField resignFirstResponder];
        [self.cvvField becomeFirstResponder];
    }
}

- (void)cvvFieldDidChange:(id)sender
{
    if([self.creditCardType isEqualToString:@"amex"] && [self.cvvField.text length] >= 4){
        [self.cvvField resignFirstResponder];
    }
    else if(![self.creditCardType isEqualToString:@"amex"] && [self.cvvField.text length] >= 3){
        [self.cvvField resignFirstResponder];
    }
}

#pragma mark - Credit Card Image Functions
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.cvvField){
        self.cardImage.image = [UIImage imageNamed:@"cvv"];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.cvvField){
        [self setCreditCardImage];
        [self finishCreditCardForm];
    }
}

- (void)whichTypeOfCard:(NSString *)creditCardNumber
{
    self.creditCardType = @"blankcc";
    
    if([creditCardNumber length] >= 1){
        int firstFewDigits = [[creditCardNumber substringToIndex:1] intValue];
        if(firstFewDigits == 4){
            self.creditCardType = @"visa";
        }
    }
    
    if([creditCardNumber length] >= 2){
        int firstFewDigits = [[creditCardNumber substringToIndex:2] intValue];
        if(firstFewDigits == 34 || firstFewDigits == 37){
            self.creditCardType = @"amex";
        }
        if(firstFewDigits >= 51 && firstFewDigits <= 55){
            self.creditCardType = @"master";
        }
    }
    
    if([creditCardNumber length] >= 4){
        int firstFewDigits = [[creditCardNumber substringToIndex:4] intValue];
        if(firstFewDigits == 6011){
            self.creditCardType = @"discover";
        }
    }
    
    [self setCreditCardImage];
}

- (void)setCreditCardImage
{
    self.cardImage.image = [UIImage imageNamed:self.creditCardType];
}

#pragma mark - On Typing in Field Functions
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
    int isBackSpace = strcmp(_char, "\b");
    
    if (isBackSpace == -8) {
        if(textField == self.cardField || textField == self.expirationField){
            self.isBackspace = YES;
            return YES;
        }
        else if(textField == self.lastFourField){
            return YES;
        }
        return YES;
    }
    if(textField == self.cardField){
        return YES;
    }
    if(textField == self.lastFourField){
        return NO;
    }
    
    if(textField == self.expirationField){
        return [self validTypingOnExpirationDateField:string];
    }
    
    if(textField == self.cvvField){
        return [self validTypingOnCVVField];
    }
    
    return YES;
}

- (BOOL)validTypingOnExpirationDateField:(NSString *)newInput
{
    NSString *currentInput = self.expirationField.text;
    int newInputInt = [newInput intValue];
    
    if([currentInput length] == 0 && (newInputInt > 1)){
        self.expirationField.text = @"0";
    }
    
    if([currentInput length] == 1 && ([currentInput isEqualToString:@"1"] && newInputInt > 2)){
        return NO;
    }
    
    if([currentInput length] == 3){
        int currentYear = [self.components year] % 2000;
        if(newInputInt < currentYear / 10) return NO;
    }
    
    if([currentInput length] == 4){
        int month = [[currentInput substringToIndex:2] intValue];
        int currentYear = [self.components year] % 2000;
        NSString *yearTensValue = [currentInput substringFromIndex:3];
        if([[yearTensValue stringByAppendingString:newInput] intValue] < currentYear) return NO;
        if([[yearTensValue stringByAppendingString:newInput] intValue] == currentYear && month < [self.components month]) return NO;
    }
    
    if([currentInput length] >= 5){
        [self.cvvField becomeFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)validTypingOnCVVField
{
    if([self.creditCardType isEqualToString:@"amex"] && [self.cvvField.text length] >= 4){
        [self.cvvField resignFirstResponder];
        return NO;
        
    }
    else if(![self.creditCardType isEqualToString:@"amex"] && [self.cvvField.text length] >= 3){
        [self.cvvField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - Finish Credit Card Method
- (void)finishCreditCardForm
{
    NSString *cardNumber = [self.cardField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *expirationDate = self.expirationField.text;
    NSString *cvv = self.cvvField.text;
    
    [self.delegate creditCardCompleted:self.creditCardValid withCreditCardNumber:cardNumber withExpirationDate:expirationDate withCVVNumber:cvv];
}


#pragma mark - Luhn Check

- (NSMutableArray *)toCharArray:(NSString *)charArray
{
    NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:[charArray length]];
    for (int i=0; i < [charArray length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [charArray characterAtIndex:i]];
        [characters addObject:ichar];
    }
    
    return characters;
}

- (BOOL)luhnCheck:(NSString *)stringToTest {
    
    NSMutableArray *stringAsChars = [self toCharArray:stringToTest];
    
    BOOL isOdd = YES;
    int oddSum = 0;
    int evenSum = 0;
    
    for (int i = [stringToTest length] - 1; i >= 0; i--) {
        
        int digit = [(NSString *)[stringAsChars objectAtIndex:i] intValue];
        
        if (isOdd)
            oddSum += digit;
        else
            evenSum += digit/5 + (2*digit) % 10;
        
        isOdd = !isOdd;
    }
    
    return ((oddSum + evenSum) % 10 == 0);
}


#pragma mark - PUBLIC METHODS

- (void)dismissAllKeyboards
{
    [self.cardField resignFirstResponder];
    [self.lastFourField resignFirstResponder];
    [self.expirationField resignFirstResponder];
    [self.cvvField resignFirstResponder];
}


@end
