//
//  AutoCoding.m
//
//  Version 2.0.3
//
//  Created by Nick Lockwood on 19/11/2011.
//  Copyright (c) 2011 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/AutoCoding
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

//  The following code is modified by Håvard Fossli (hfossli@agens.no)
//  and only resembles the original code in chunks

#import "AGClassHelper.h"
#import <objc/runtime.h>

@implementation AGClassHelper

+ (NSDictionary *)codablePropertiesForClass:(Class)aClass omit:(NSArray *)omit
{
    @synchronized([NSObject class])
    {
        static NSMutableDictionary *keysByClass = nil;
        if (keysByClass == nil)
        {
            keysByClass = [NSMutableDictionary new];
        }

        NSString *className = NSStringFromClass(aClass);
        NSMutableDictionary *codableProperties = keysByClass[className];
        if (codableProperties == nil)
        {
            codableProperties = [NSMutableDictionary dictionary];
            unsigned int propertyCount;
            objc_property_t *properties = class_copyPropertyList(aClass, &propertyCount);
            for (unsigned int i = 0; i < propertyCount; i++)
            {
                //get property name
                objc_property_t property = properties[i];
                const char *propertyName = property_getName(property);
                NSString *key = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];

                if(![omit containsObject:key])
                {
                    //get property type
                    Class class = nil;
                    char *typeEncoding = property_copyAttributeValue(property, "T");
                    switch (typeEncoding[0])
                    {
                        case '@':
                        {
                            if (strlen(typeEncoding) >= 3)
                            {
                                char *className = strndup(typeEncoding + 2, strlen(typeEncoding) - 3);
                                NSString *name = [NSString stringWithUTF8String:className];
                                NSRange range = [name rangeOfString:@"<"];
                                if (range.location != NSNotFound)
                                {
                                    name = [name substringToIndex:range.location];
                                }
                                class = NSClassFromString(name) ?: [NSObject class];
                                free(className);
                            }
                            break;
                        }
                        case 'c':
                        case 'i':
                        case 's':
                        case 'l':
                        case 'q':
                        case 'C':
                        case 'I':
                        case 'S':
                        case 'f':
                        case 'd':
                        case 'B':
                        {
                            class = [NSNumber class];
                            break;
                        }
                        case '{':
                        {
                            class = [NSValue class];
                            break;
                        }
                    }
                    free(typeEncoding);

                    if (class)
                    {
                        //see if there is a backing ivar
                        char *ivar = property_copyAttributeValue(property, "V");
                        if (ivar)
                        {
                            char *readonly = property_copyAttributeValue(property, "R");
                            if (readonly)
                            {
                                //check if ivar has KVC-compliant name
                                NSString *ivarName = [NSString stringWithFormat:@"%s", ivar];
                                if ([ivarName isEqualToString:key] ||
                                    [ivarName isEqualToString:[@"_" stringByAppendingString:key]])
                                {
                                    //no setter, but setValue:forKey: will still work
                                    codableProperties[key] = class;
                                }
                                free(readonly);
                            }
                            else
                            {
                                //there is a setter method so setValue:forKey: will work
                                codableProperties[key] = class;
                            }
                            free(ivar);
                        }
                    }
                }

            }
            free(properties);
            keysByClass[className] = [NSDictionary dictionaryWithDictionary:codableProperties];
        }
        return codableProperties;
    }
}

+ (NSDictionary *)codablePropertiesForInheritanceOfClass:(Class)topClass omit:(NSArray *)omit
{
    @synchronized([NSObject class])
    {
        static NSMutableDictionary *propertiesByClass = nil;
        if (propertiesByClass == nil)
        {
            propertiesByClass = [[NSMutableDictionary alloc] init];
        }

        NSString *className = NSStringFromClass([topClass class]);
        NSDictionary *codableProperties = propertiesByClass[className];
        if (codableProperties == nil)
        {
            NSMutableDictionary *properties = [NSMutableDictionary dictionary];
            Class class = topClass;
            while (class != [NSObject class])
            {
                [properties addEntriesFromDictionary:[AGClassHelper codablePropertiesForClass:class omit:omit]];
                class = [class superclass];
            }
            codableProperties = [properties copy];
            [propertiesByClass setObject:codableProperties forKey:className];
        }
        return codableProperties;
    }
}

+ (NSDictionary *)dictionaryRepresentationForInstance:(id <NSObject>)instance omit:(NSArray *)omit
{
    NSDictionary *codableProperties = [self codablePropertiesForInheritanceOfClass:[instance class] omit:omit];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:codableProperties.count];
    [codableProperties enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        dictionary[key] = obj;
    }];
    return dictionary;
}

@end


#if AGClassHelperExtendsNSObject

@implementation NSObject (Coding)

+ (NSArray *)uncodableProperties
{
    return nil;
}

- (NSDictionary *)allCodableProperties
{
    return [AGClassHelper codablePropertiesForInheritanceOfClass:[self class] omit:[[self class] uncodableProperties]];
}

- (NSDictionary *)dictionaryRepresentation
{
    return [AGClassHelper dictionaryRepresentationForInstance:self omit:[[self class] uncodableProperties]];
}

@end

#endif