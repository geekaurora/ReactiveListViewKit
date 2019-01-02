#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "IOHIDEvent+KIF.h"
#import "KIF.h"
#import "KIFAccessibilityEnabler.h"
#import "KIFSystemTestActor.h"
#import "KIFTestActor.h"
#import "KIFTestActor_Private.h"
#import "KIFTestCase.h"
#import "KIFTestStepValidation.h"
#import "KIFTextInputTraitsOverrides.h"
#import "KIFTypist.h"
#import "KIFUIObject.h"
#import "KIFUITestActor-ConditionalTests.h"
#import "KIFUITestActor.h"
#import "KIFUITestActor_Private.h"
#import "KIFUIViewTestActor.h"
#import "UIAutomationHelper.h"
#import "CAAnimation+KIFAdditions.h"
#import "CALayer-KIFAdditions.h"
#import "CGGeometry-KIFAdditions.h"
#import "NSBundle-KIFAdditions.h"
#import "NSError-KIFAdditions.h"
#import "NSException-KIFAdditions.h"
#import "NSFileManager-KIFAdditions.h"
#import "NSPredicate+KIFAdditions.h"
#import "NSString+KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import "UIEvent+KIFAdditions.h"
#import "UIScreen+KIFAdditions.h"
#import "UIScrollView-KIFAdditions.h"
#import "UITableView-KIFAdditions.h"
#import "UITouch-KIFAdditions.h"
#import "UIView-KIFAdditions.h"
#import "UIWindow-KIFAdditions.h"
#import "XCTestCase-KIFAdditions.h"
#import "UIView-Debugging.h"

FOUNDATION_EXPORT double KIFVersionNumber;
FOUNDATION_EXPORT const unsigned char KIFVersionString[];

