//
//  TableViewCellSong.h
//  vkPlay
//
//  Created by Admin on 31.03.16.
//  Copyright © 2016 Boris-Mikhalev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioController.h"

@interface songTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *downloadPlayButton;
@property (strong, nonatomic) IBOutlet UILabel *songTitle;
@property (strong, nonatomic) AudioController* audioController;

- (IBAction)buttonPressed:(UIButton *)sender;

@end
