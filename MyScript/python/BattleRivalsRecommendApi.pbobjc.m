// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: api/gift/gift_portal_ping_api.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

#import <stdatomic.h>

#import <IESLiveKit/GiftPortalPingApi.pbobjc.h>
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - GiftPortalPingApiRoot

@implementation GiftPortalPingApiRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - GiftPortalPingApiRoot_FileDescriptor

static GPBFileDescriptor *GiftPortalPingApiRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  IESLiveFileDescriptor1(descriptor,@"webcast.api.gift")
}

#pragma mark - Enum PortalPingType

GPBEnumDescriptor *PortalPingType_EnumDescriptor(void) {
  static _Atomic(GPBEnumDescriptor*) descriptor = nil;
  if (!descriptor) {
    static const char *valueNames =
        "WaitReward\000ReceiveInvitation\000ClickInvita"
        "tion\000JumpToRoom\000";
    static const int32_t values[] = {
        PortalPingType_WaitReward,
        PortalPingType_ReceiveInvitation,
        PortalPingType_ClickInvitation,
        PortalPingType_JumpToRoom,
    };
    GPBEnumDescriptor *worker =
        IESLiveCreateWorker2(GPBNSStringifySymbol(PortalPingType),valueNames,values,PortalPingType_IsValidValue)
    GPBEnumDescriptor *expected = nil;
    if (!atomic_compare_exchange_strong(&descriptor, &expected, worker)) {
      [worker release];
    }
  }
  return descriptor;
}

BOOL PortalPingType_IsValidValue(int32_t value__) {
  switch (value__) {
    case PortalPingType_WaitReward:
    case PortalPingType_ReceiveInvitation:
    case PortalPingType_ClickInvitation:
    case PortalPingType_JumpToRoom:
      return YES;
    default:
      return NO;
  }
}

#pragma mark - PortalPingResponse

@implementation PortalPingResponse

@dynamic hasData_p, data_p;

typedef struct PortalPingResponse__storage_ {
  uint32_t _has_storage_[1];
  PortalPingResponse_Data *data_p;
} PortalPingResponse__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "data_p",
        .dataTypeSpecific.className = GPBStringifySymbol(PortalPingResponse_Data),
        .number = PortalPingResponse_FieldNumber_Data_p,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(PortalPingResponse__storage_, data_p),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[PortalPingResponse class]
                                     rootClass:[GiftPortalPingApiRoot class]
                                          file:GiftPortalPingApiRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(PortalPingResponse__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - PortalPingResponse_Data

@implementation PortalPingResponse_Data

@dynamic nextTimePing;
@dynamic luckyMoneyCountDown;
@dynamic valid;
@dynamic luckyMoneyCloseCountDown;

typedef struct PortalPingResponse_Data__storage_ {
  uint32_t _has_storage_[1];
  int64_t nextTimePing;
  int64_t luckyMoneyCountDown;
  int64_t luckyMoneyCloseCountDown;
} PortalPingResponse_Data__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "nextTimePing",
        .dataTypeSpecific.className = NULL,
        .number = PortalPingResponse_Data_FieldNumber_NextTimePing,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(PortalPingResponse_Data__storage_, nextTimePing),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "luckyMoneyCountDown",
        .dataTypeSpecific.className = NULL,
        .number = PortalPingResponse_Data_FieldNumber_LuckyMoneyCountDown,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(PortalPingResponse_Data__storage_, luckyMoneyCountDown),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
      {
        .name = "valid",
        .dataTypeSpecific.className = NULL,
        .number = PortalPingResponse_Data_FieldNumber_Valid,
        .hasIndex = 2,
        .offset = 3,  // Stored in _has_storage_ to save space.
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeBool,
      },
      {
        .name = "luckyMoneyCloseCountDown",
        .dataTypeSpecific.className = NULL,
        .number = PortalPingResponse_Data_FieldNumber_LuckyMoneyCloseCountDown,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(PortalPingResponse_Data__storage_, luckyMoneyCloseCountDown),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[PortalPingResponse_Data class]
                                     rootClass:[GiftPortalPingApiRoot class]
                                          file:GiftPortalPingApiRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(PortalPingResponse_Data__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
    [localDescriptor setupContainingMessageClassName:GPBStringifySymbol(PortalPingResponse)];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)


static GPBFileDescriptor *IESLiveDrawAndGuessRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"webcast.sei"
                                                 objcPrefix:@"IESLive"
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}
