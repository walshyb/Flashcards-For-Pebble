//
//  ViewController.m
//  Flashcards for Pebble
//
//  Created by Brandon Walsh on 3/20/15.
//  Copyright (c) 2015 Brandon Walsh. All rights reserved.
//

#import "DeckViewController.h"
#import "AppDelegate.h"
#import <PebbleKit/PebbleKit.h>
#import "AddCardViewController.h"
#import "ViewCardNavigationController.h"

NSInteger count = 1;
@interface DeckViewController ()

@end

@implementation DeckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = appDelegateDeckTitle;
    cardsArray = [decksTable objectForKey:appDelegateDeckTitle];
    
    //Assign back button to left side of navbar
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"< Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    
    //Assign save button and action buttons to right side of navbar
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonPressed)];
    
    //self.navigationItem.rightBarButtonItems = @[actionButton];
    
    self.navigationItem.leftBarButtonItems = @[backButton, actionButton];
    
    [[PBPebbleCentral defaultCentral] setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [cardsArray count];
}

/*Displays file names in UITableView in FirstViewController*/
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog([NSString stringWithFormat:@"Array Count %d", [cardsArray count]]);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
    }
    
    NSMutableString *cellText = [NSString stringWithFormat:@"Card %i", count];
    cell.textLabel.text = cellText; //assigns the text in cell the path of the file
    
    count = count + 1;
    
    return cell;
}

/*Handles selecting a row*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the selected cell
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    ViewCardNavigationController *viewCardNavigationControllerInstance = [self.storyboard instantiateViewControllerWithIdentifier:@"viewCardNavigationController"];

    NSString *card = cardsArray[indexPath.row];
    NSArray *lines = [card componentsSeparatedByString: @"&split&"];

    //NSLog(lines[0]);
    //NSLog(lines[1]);
    
    viewCardNavigationControllerInstance.indexPath = indexPath;
    viewCardNavigationControllerInstance.cardFront = lines[0];
    viewCardNavigationControllerInstance.cardBack = lines[1];
    
    [self presentViewController:viewCardNavigationControllerInstance animated:YES completion:nil];
    
}

- (void)backButtonPressed
{
    count = 1;
    UINavigationController *homeViewController = [self.storyboard instantiateInitialViewController];
    [self presentViewController:homeViewController animated:YES completion:nil];
}

- (void)actionButtonPressed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Send to Pebble"
                                                    message:@"Would you like to add this deck to Pebble Watch?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Send to Pebble", nil];
    [alert show];
}

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidConnect:(PBWatch*)watch isNew:(BOOL)isNew {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pebble Watch Status"
                                                    message:@"A connection with your Pebble Watch has been established."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    self.connectedWatch = watch;

}

- (void)pebbleCentral:(PBPebbleCentral*)central watchDidDisconnect:(PBWatch*)watch {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pebble Watch Status"
                                                    message:@"This device has lost connection with your pebble.  Please make sure that bluetooth is enabled on both this device and your Pebble."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    if (self.connectedWatch == watch || [watch isEqual:self.connectedWatch]) {
        self.connectedWatch = nil;
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 0 = Cancel button click
    if (buttonIndex == 0)
    {
    }
    else
    {
        self.connectedWatch = [[PBPebbleCentral defaultCentral] lastConnectedWatch];
        NSLog(@"Last connected watch: %@", self.connectedWatch);
        
        uuid_t myAppUUIDbytes;
        NSUUID *myAppUUID = [[NSUUID alloc] initWithUUIDString:@"02e9e837-dd80-4e20-b565-eef4ae4a33f1"];
        [myAppUUID getUUIDBytes:myAppUUIDbytes];
        
        [[PBPebbleCentral defaultCentral] setAppUUID:[NSData dataWithBytes:myAppUUIDbytes length:16]];
        
        //NSDictionary *update = @{ @(0):[NSNumber numberWithUint8:5],
        //                          @(1):@"a string" };
        
        NSArray *deck = [decksTable objectForKey:appDelegateDeckTitle];
        NSInteger deckCount = [deck count];
        NSLog(@"1");
        NSMutableString *deckString = [NSMutableString stringWithString:appDelegateDeckTitle];// appDelegateDeckTitle; //first line always deck name
        NSLog(@"2");
        [deckString appendString:@"\n"];
        NSLog(@"3");
        [deckString appendString:[NSString stringWithFormat:@"%d", deckCount]];   //second line always deck length
        NSLog(@"4");
        [deckString appendString:@"\n"];
        for(int i = 0; i < deckCount; i++)
        {
            [deckString appendFormat:deck[i]];
            [deckString appendString:@"\n"];
        }
        
        NSLog(deckString);
        
        
        
        NSDictionary *realToSend = @{ @(0):[NSNumber numberWithUint8:5],
                                  @(1):deckString};
        
        [self.connectedWatch appMessagesPushUpdate:realToSend onSent:^(PBWatch *watch, NSDictionary *update, NSError *error) {
            if (!error) {
                NSLog(@"Successfully sent message.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                message:@"Success"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Cancel", nil];
                [alert show];
            }
            else {
                NSLog(@"Error sending message: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"An Error Has Occurred"
                                                                message:@"Please make sure that bluetooth is enabled on this device and your Pebble, and that you have the Pebble FlashCards app open on your watch."
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}
@end
