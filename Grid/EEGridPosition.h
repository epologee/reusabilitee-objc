//
//  EEGridPosition.h
//  wowcal
//
//  Created by Eric-Paul Lecluse on 18-11-11.
//

#import <Foundation/Foundation.h>

@interface EEGridPosition : NSObject

@property (nonatomic) NSInteger row;
@property (nonatomic) NSInteger column;
@property (nonatomic, readonly) CGPoint point;

+ (EEGridPosition *)gridPositionFromPoint:(CGPoint)point;
+ (EEGridPosition *)gridPositionForColumn:(NSInteger)column row:(NSInteger)row;

@end
