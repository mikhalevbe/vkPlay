//
//  Songs.h
//  vkPlay
//
//  Created by Admin on 14.04.16.
//  Copyright © 2016 Boris-Mikhalev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SongStructure.h"

@interface listOfSongsSingleton : NSObject

@property (strong, atomic) NSMutableArray* listOfSongs;

+ (instancetype)sharedInstance;

@end
