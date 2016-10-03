//
//  SongStructure.h
//  vkPlay
//
//  Created by Admin on 14.04.16.
//  Copyright © 2016 Boris-Mikhalev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongStructure : NSObject

@property (strong) NSNumber* idSong;
@property (strong) NSString* artist;
@property (strong) NSString* title;
@property (strong) NSString* url;
@property (strong) NSString* downloadedFilePath;


- (id)initWithArtist: (NSString*) artist Title: (NSString*) title Url: (NSString*) url Id: (NSNumber*) idSong downloadPath: (NSString*) path;


@end
