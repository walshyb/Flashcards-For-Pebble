//
//  ViewController.h
//  Flashcards for Pebble
//
//  Created by Brandon Walsh on 3/20/15.
//  Copyright (c) 2015 Brandon Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PebbleKit/PebbleKit.h>

UIViewController *loadedDecksViewControllerInstance;

@interface DecksViewController : UITableViewController

- (void)setTargetWatch:(PBWatch*)watch;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

