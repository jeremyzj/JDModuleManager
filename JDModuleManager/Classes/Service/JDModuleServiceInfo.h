//
//  JDModuleServeInfo.h
//  JDModuleManager
//
//  Created by Mac on 2022/5/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDModuleServiceInfo : NSObject

@property (nonatomic, strong) Protocol *protocol; /**< 服务的协议 */
@property (nonatomic, strong) Class implClass;   /**< 提供服务的类 */

@end

NS_ASSUME_NONNULL_END
