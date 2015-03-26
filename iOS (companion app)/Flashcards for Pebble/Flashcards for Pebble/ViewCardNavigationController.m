//
//  EditorNavigationController.m
//  #Pad
//
//  Created by Brandon Walsh on 12/24/14.
//  Copyright (c) 2014 Brandon Walsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewCardNavigationController.h"

@interface ViewCardNavigationController ()



@end

@implementation ViewCardNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    front = _cardFront;
    back = _cardBack;
    row = _indexPath.row;
    
}


@end