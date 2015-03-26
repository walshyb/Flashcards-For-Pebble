//
//  ViewController.m
//  Flashcards for Pebble
//
//  Created by Brandon Walsh on 3/20/15.
//  Copyright (c) 2015 Brandon Walsh. All rights reserved.
//

#import "AddCardViewController.h"
#import "AppDelegate.h"
#import "DeckViewController.h"

@interface AddCardViewController ()

@end

@implementation AddCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _cardFront.layer.borderWidth = 1.0f;
    _cardFront.layer.borderColor = [[UIColor blackColor] CGColor];

    _cardBack.layer.borderWidth = 1.0f;
    _cardBack.layer.borderColor = [[UIColor blackColor] CGColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addCard:(id)sender {
    NSString *front = _cardFront.text;
    NSString *back = _cardBack.text;
    
    NSMutableArray *currentDeck = [NSMutableArray arrayWithArray:[decksTable objectForKey:appDelegateDeckTitle]];
    
    NSMutableString *card = [NSMutableString stringWithString:front];   //add front to card
    [card appendString:@"&split&"];  //add new line
    [card appendString:[NSMutableString stringWithString:back]];    //add back to card
    
    [currentDeck addObject:[NSString stringWithString:card]];   //add to array as NSString
    
    NSMutableDictionary *replacementDeck = [NSMutableDictionary dictionaryWithDictionary:decksTable];
    [replacementDeck setObject:currentDeck forKey:appDelegateDeckTitle];
    
    //[decksTable setObject:currentDeck forKey:appDelegateDeckTitle];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:replacementDeck forKey:@"decksTable"];
    [userDefaults synchronize];
    
    decksTable = [userDefaults objectForKey:@"decksTable"];
    cardsArray = currentDeck;
    /*NSMutableArray *card = [[NSMutableArray alloc] init];
    [card addObject:front];
    [currentDeck setObject:card forKey:appDelegateDeckTitle];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:decksTable forKey:@"decksTable"];
    [userDefaults synchronize];*/
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
