//
//  ViewController.h
//  Flashcards for Pebble
//
//  Created by Brandon Walsh on 3/20/15.
//  Copyright (c) 2015 Brandon Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDeckViewController : UIViewController

- (IBAction)addDeck:(id)sender;
- (IBAction)cancelButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITextField *deckNameField;

@end

