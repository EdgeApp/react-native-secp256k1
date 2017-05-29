
#import "RNMyFancyLibrary.h"
#import <Secp256k1/Secp256k1.h>
#import <Foundation/Foundation.h>
#import "RCTConvert.h"

@implementation RNMyFancyLibrary

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

- (NSData *)publicKeyFromKey:(NSData *)privateKey compressed:(BOOL)compressed {
    @autoreleasepool {
        secp256k1_pubkey pubKey;
        const unsigned char *privKey = (unsigned char *)[privateKey bytes];
        
        if (![privateKey isKindOfClass:[NSData class]]) return NULL;
        if (![privateKey bytes] || privateKey.length != 32) return NULL;
        secp256k1_context *ctx = secp256k1_context_create(SECP256K1_CONTEXT_SIGN);
        if(secp256k1_ec_pubkey_create(ctx, &pubKey, privKey) != 1) {
            NSLog(@"Failed to create public key!");
            return NULL;
        } else {
            if(!compressed){
                unsigned char serializedChar[65];
                size_t pubKeyLength = 65;
                if(secp256k1_ec_pubkey_serialize(ctx, &serializedChar, &pubKeyLength, &pubKey, SECP256K1_EC_UNCOMPRESSED) == 1){
                    
                    NSData* data = [NSData dataWithBytes:(const void *)serializedChar length:sizeof(unsigned char)*pubKeyLength];
                    
                    return data;
                }
                NSLog(@"Failed to serialize public key!");
                return NULL;
                
            } else {
                unsigned char serializedChar[33];
                size_t pubKeyLength = 33;
                if(secp256k1_ec_pubkey_serialize(ctx, &serializedChar, &pubKeyLength, &pubKey, SECP256K1_EC_COMPRESSED) == 1){
                    
                    NSData* data = [NSData dataWithBytes:(const void *)serializedChar length:sizeof(unsigned char)*pubKeyLength];
                    
                    return data;
                }
                NSLog(@"Failed to serialize public key!");
                return NULL;
            }
        }
    }
}

-(NSData *) generate32byteKey {
    
    NSString *letters  = @"ABCDEF0123456789";
    NSMutableString *randomString = @"".mutableCopy;
    
    for(int i = 0; i < 64; i++){
        UInt32 length =  letters.length;
        int rand = arc4random_uniform(length);
        [randomString appendFormat:@"%C", [letters characterAtIndex:rand]];
    }
    NSData *key = [self dataWithHexString:randomString];
    
    return key;
}

- (NSDictionary *)generateKeyPair
{
    NSData *privateKey = [self generate32byteKey];
    
    NSData *publicKey = [self publicKeyFromKey:privateKey compressed:NO];
    
    return @{@"private" : privateKey, @"public" : publicKey};
}


-(NSData *)dataWithHexString:(NSString *)hex
{
    char buf[3];
    buf[2] = '\0';
    NSAssert(0 == [hex length] % 2, @"Hex strings should have an even number of digits (%@)", hex);
    unsigned char *bytes = malloc([hex length]/2);
    unsigned char *bp = bytes;
    for (CFIndex i = 0; i < [hex length]; i += 2) {
        buf[0] = [hex characterAtIndex:i];
        buf[1] = [hex characterAtIndex:i+1];
        char *b2 = NULL;
        *bp++ = strtol(buf, &b2, 16);
        NSAssert(b2 == buf + 2, @"String should be all hex digits: %@ (bad digit around %d)", hex, i);
    }
    
    return [NSData dataWithBytesNoCopy:bytes length:[hex length]/2 freeWhenDone:YES];
}

- (NSString *)hexadecimalStringFromData:(NSData *)data {
    
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(generareKeyPair:(RCTResponseSenderBlock)callback)
{
    NSDictionary *keyPair = [self generateKeyPair];
    NSString *privateKeyString = [self hexadecimalStringFromData:keyPair[@"private"]];
    NSString *publicKeyString = [self hexadecimalStringFromData:keyPair[@"public"]];
    
    NSDictionary *resultDictionary = @{@"private" : privateKeyString,
                                       @"public" : publicKeyString
                                       };
    if ([resultDictionary isKindOfClass:[NSDictionary class]] && privateKeyString != nil && publicKeyString != nil) {
        callback(@[[NSNull null], resultDictionary]);
    } else {
        NSDictionary *error = RCTMakeError(@"Can't generate key pair", nil, nil);
        callback(@[error, [NSNull null]]);
    }
    
}

RCT_EXPORT_METHOD(publicForPrivate:(NSString *)private
                  callback:(RCTResponseSenderBlock)callback)
{
    if(private.length != 64){
        NSDictionary *error = RCTMakeError(@"Public key must be 64 digit.", nil, nil);
        callback(@[error, [NSNull null]]);
    }
    NSData *data =[self dataWithHexString:private];
    NSData *pubKey = [self publicKeyFromKey:data compressed:NO];
    NSString *pubKeyString = [self hexadecimalStringFromData:pubKey];
    if ([pubKeyString isKindOfClass:[NSString class]] && [pubKeyString length] > 0) {
        callback(@[[NSNull null], pubKeyString]);
    } else {
        NSDictionary *error = RCTMakeError(@"Can't generate private key", nil, nil);
        callback(@[error, [NSNull null]]);
    }
}

RCT_EXPORT_METHOD(test:(RCTResponseSenderBlock)callback)
{
    NSArray *events = @[@"one", @"two"];
    callback(@[[NSNull null], events]);
}

@end
