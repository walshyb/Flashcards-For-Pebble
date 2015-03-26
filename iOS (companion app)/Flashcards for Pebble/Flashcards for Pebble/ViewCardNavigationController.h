//
//  ViewController.h
//  Flashcards for Pebble
//
//  Created by Brandon Walsh on 3/20/15.
//  Copyright (c) 2015 Brandon Walsh. All rights reserved.
//

#import <UIKit/UIKit.h>


NSString *front;
NSString *back;
NSInteger *row;
@interface ViewCardNavigationController : UINavigationController

@property (weak, nonatomic) NSString *cardFront;
@property (weak, nonatomic) NSString *cardBack;
@property (strong, nonatomic) NSIndexPath *indexPath;


@end

