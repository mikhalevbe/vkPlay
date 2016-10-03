//
//  playListViewController.h
//  vkPlay
//
//  Created by Admin on 24.03.16.
//  Copyright © 2016 Boris-Mikhalev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk.h>

@interface playListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

// fix
@property (nonatomic ,weak) IBOutlet UITableView* table;
@property (nonatomic) BOOL tumbler;


@end
