//
//  SongTable+CoreDataProperties.h
//  vkPlay
//
//  Created by Admin on 18.04.16.
//  Copyright © 2016 Boris-Mikhalev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SongTable.h"

NS_ASSUME_NONNULL_BEGIN

@interface SongTable (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *idSong;
@property (nullable, nonatomic, retain) NSString *artist;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *downloadedFilePath;

@end

NS_ASSUME_NONNULL_END
