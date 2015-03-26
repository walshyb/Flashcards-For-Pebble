//
//  ViewController.m
//  Flashcards for Pebble
//
//  Created by Brandon Walsh on 3/20/15.
//  Copyright (c) 2015 Brandon Walsh. All rights reserved.
//

#import "AddDeckViewController.h"
#import "AppDelegate.h"
#import "DecksViewController.h"

@interface AddDeckViewController ()

@end

@implementation AddDeckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addDeck:(id)sender {
    NSMutableArray *deck = [[NSMutableArray alloc] init];
    if(_deckNameField.text != nil)
    {
        NSMutableDictionary *replacementDeck = [NSMutableDictionary dictionaryWithDictionary:decksTable];
        [replacementDeck setObject:deck forKey:_deckNameField.text];
        //[decksTable setObject:deck forKey:_deckNameField.text];
        //[decksTable setValue:deck forKey:_deckNameField.text];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:replacementDeck forKey:@"decksTable"];
        [userDefaults synchronize];
        
        decksTable = [userDefaults objectForKey:@"decksTable"];
        
        DecksViewController *notSelf = loadedDecksViewControllerInstance;
        [notSelf.tableView reloadData]; //reload tables 
        [notSelf reloadInputViews];
    }
    //[decksTable addObject:@42];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
