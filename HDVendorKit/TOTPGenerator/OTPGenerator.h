//
//  OTPGenerator.h
//
//  Copyright 2011 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

#import <Foundation/Foundation.h>

// The OTPGenerator class generates a one-time password (OTP) using
// the HMAC-Based One-Time Password Algorithm described in RFC4226:
// http://tools.ietf.org/html/rfc4226
//
// The HOTP algorithm is based on an increasing counter value and a
// static symmetric key known only to the token and the validation
// service.  In order to create the HOTP value, we will use the HMAC-
// SHA-1 algorithm, as defined in RFC 2104.
//
// As the output of the HMAC-SHA-1 calculation is 160 bits, we must
// truncate this value to something that can be easily entered by a
// user.
//
// HOTP(K,C) = Truncate(HMAC-SHA-1(K,C))
//
// Where:
//
// - Truncate represents the function that converts an HMAC-SHA-1
//   value into an HOTP value as defined in Section 5.3 of RFC4226.
//
// The Key (K), the Counter (C), and Data values are hashed high-order
// byte first.
//
// The HOTP values generated by the HOTP generator are treated as big
// endian.
@interface OTPGenerator : NSObject

@property (readonly, nonatomic, copy) NSString *algorithm;
@property (readonly, nonatomic, copy) NSData *secret;
@property (readonly, nonatomic) NSUInteger digits;

// Some default values.
+ (NSString *)defaultAlgorithm;
+ (NSUInteger)defaultDigits;

// Designated initializer.
- (id)initWithSecret:(NSData *)secret
           algorithm:(NSString *)algorithm
              digits:(NSUInteger)digits;

// Instance method to generate an OTP using the |algorithm|, |secret|,
// |counter| and |digits| values configured on the object.
// The return value is an NSString of |digits| length, with leading
// zero-padding as required.
- (NSString *)generateOTPForCounter:(uint64_t)counter;

// Instance method to generate an OTP using the |algorithm|, |secret|,
// |counter| and |digits| values configured on the object.
// The return value is an NSString of |digits| length, with leading
// zero-padding as required.
- (NSString *)generateOTP;

@end

extern NSString *const kOTPGeneratorSHA1Algorithm;
extern NSString *const kOTPGeneratorSHA256Algorithm;
extern NSString *const kOTPGeneratorSHA512Algorithm;
extern NSString *const kOTPGeneratorSHAMD5Algorithm;
