

#import <math.h>
#import "ccConfig.h"

#import <Foundation/Foundation.h>
#import <Availability.h>
#import <UIKit/UIKit.h>

//terababy, Universal座标相关

#define IS_IPAD ((UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)?1:0)

#define LRATIO ((IS_IPAD==1)?1.0f:0.469f)
#define PRATIO ((IS_IPAD==1)?1.0f:0.417f)

#define LRATIO ((IS_IPAD==1)?1.0f:0.469f)
#define PRATIO ((IS_IPAD==1)?1.0f:0.417f)

#define LRATIOPH ((IS_IPAD==1)?(1024.0f/960.0f):1.0f)
#define PRATIOPH ((IS_IPAD==1)?(768.0f/640.0f):1.0f)


#define ccpO(__X__,__Y__) [NSValue valueWithCGPoint:ccp(__X__,__Y__)

#define ccpL(__X__,__Y__) CGPointMake(LRATIO * (__X__),PRATIO *(__Y__))
#define ccpP(__X__,__Y__) CGPointMake(PRATIO * (__X__),LRATIO *(__Y__))

#define ccpU(__XPAD__,__YPAD__, __XPHONE__,__YPHONE__) ((IS_IPAD==1)?CGPointMake(__XPAD__,__YPAD__):CGPointMake(__XPHONE__,__YPHONE__))

#define RATIO ((IS_IPAD==1)?1.0f:0.5f)

// 添加到非Layer父节点时需要用到的坐标，phone版取pad版的一半
#define ccp2(__X__,__Y__) CGPointMake(((IS_IPAD==1)?1.0f:0.5f) * (__X__),((IS_IPAD==1)?1.0f:0.5f) *(__Y__))
