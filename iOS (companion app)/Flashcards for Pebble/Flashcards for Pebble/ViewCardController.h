//
//  ViewController.h
//  Flashcards for Pebble
//
//  Created by Brandon Walsh on 3/20/15.
//  Copyright (c) 2015 Brandon Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>

NSInteger indexRow;
@interface CardViewController : UIViewController

- (IBAction)cancelButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *cardFront;
@property (weak, nonatomic) IBOutlet UITextView *cardBack;
- (IBAction)saveButtonClick:(id)sender;

@end

