//
//  ViewController.m
//  Flashcards for Pebble
//
//  Created by Brandon Walsh on 3/20/15.
//  Copyright (c) 2015 Brandon Walsh. All rights reserved.
//

#import "DecksViewController.h"
#import "AppDelegate.h"
#import <PebbleKit/PebbleKit.h>

@interface DecksViewController ()

@end

@implementation DecksViewController{
    PBWatch *_watch;
    //UITableView *tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    DecksViewController *d = self;
    loadedDecksViewControllerInstance = d;
    if([userDefaults objectForKey:@"decksTable"] == nil)    //if decksTable doesn't exist
    {
        decksTable = [[NSMutableDictionary alloc] init];
        [userDefaults setObject:decksTable forKey:@"decksTable"];
        [userDefaults synchronize];
    }
    else
    {
        decksTable = [userDefaults objectForKey:@"decksTable"];
        NSLog(@"exists");
        
        for (id key in decksTable) {
            NSLog(@"key: %@, value: %@", key, [decksTable objectForKey:key]);
        }
    }
    
    [self.tableView reloadData];
    [[self tableView] reloadData];
    
}

- (void)setTargetWatch:(PBWatch*)watch {
    _watch = watch;
    self.navigationItem.prompt = _watch ? [_watch name] : @"No Pebble";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return decksTable.count;
}

/*Displays file names in UITableView in FirstViewController*/
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
    }
    
    NSString *key = [decksTable allKeys][indexPath.row];
    
    cell.textLabel.text = key; //assigns the text in cell the path of the file
    //cell.detailTextLabel.text = [cell.textLabel.text lastPathComponent];  //rids of the file path, showing only the file name in the cell
    
    return cell;
}

/*Handles selecting a row*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the selected cell
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    //Create new instace of the editor
    UINavigationController *deckNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"deckNavigationController"]; //last attribute is id of editorviewcontroller
    
    appDelegateDeckTitle = cell.textLabel.text;
    //deckNavigationController.title = cell.textLabel.text;
    
    
    //creates reference to UINavigationController that automatically pushes to editor view
    [self presentViewController:deckNavigationController animated:YES completion:nil];
    
}

- (void)reloadTable{
    [[self tableView] reloadData];
}

@end
