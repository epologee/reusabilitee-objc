//
//  Created by Eric-Paul Lecluse (c) 2011
//

#import <Foundation/Foundation.h>

typedef enum {
    kEEResponderStatusUninitialized = 0,
    kEEResponderStatusInitialized = 1,
    kEEResponderStatusHidden = 2,
    kEEResponderStatusAppearing = 4,
    kEEResponderStatusShown = 8,
    kEEResponderStatusSwapping = 16,
    kEEResponderStatusDisappearing = 32
} EEResponderStatus;

@protocol EENavigationBehavior;

@interface EEStatusByResponder : NSObject

-(void)setStatus:(EEResponderStatus)status ofResponder:(id<EENavigationBehavior>)responder;
-(NSMutableSet *)respondersWithStatus:(EEResponderStatus)status;
-(EEResponderStatus)statusOfResponder:(id <EENavigationBehavior>)responder;

@end
