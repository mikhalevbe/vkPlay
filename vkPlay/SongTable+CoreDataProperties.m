//
//  SongTable+CoreDataProperties.m
//  vkPlay
//
//  Created by Admin on 18.04.16.
//  Copyright © 2016 Boris-Mikhalev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SongTable+CoreDataProperties.h"

@implementation SongTable (CoreDataProperties)

@dynamic idSong;
@dynamic artist;
@dynamic title;
@dynamic url;
@dynamic downloadedFilePath;

@end
