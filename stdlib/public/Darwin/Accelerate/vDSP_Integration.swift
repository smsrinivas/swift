//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2019 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

extension vDSP {
  
    @available(iOS 9999, OSX 9999, tvOS 9999, watchOS 9999, *)
    public enum IntegrationRule {
        case runningSum
        case simpson
        case trapezoidal
    }
    
    /// Integrates source vector using specified rule, single-precision.
    ///
    /// - Parameter vector: The vector to integrate.
    /// - Parameter rule: The integration rule.
    /// - Parameter stepSize: The integration step size (weighting factor for running sum).
    /// - Returns: The integration result.
    @inline(__always)
    @available(iOS 9999, macOS 9999, tvOS 9999, watchOS 9999, *)
    public static func integrate<U>(_ vector: U,
                                    using rule: IntegrationRule,
                                    stepSize: Float = 1) -> [Float]
        where
        U: AccelerateBuffer,
        U.Element == Float {
            
            let result = Array<Float>(unsafeUninitializedCapacity: vector.count) {
                buffer, initializedCount in
                
                integrate(vector,
                          using: rule,
                          result: &buffer)
                
                initializedCount = vector.count
            }
            
            return result
    }
    
    /// Integrates source vector using specified rule, single-precision.
    ///
    /// - Parameter vector: The vector to integrate.
    /// - Parameter rule: The integration rule.
    /// - Parameter stepSize: The integration step size (weighting factor for running sum).
    /// - Parameter result: The destination vector to receive the result.
    @inline(__always)
    @available(iOS 9999, macOS 9999, tvOS 9999, watchOS 9999, *)
    public static func integrate<U, V>(_ vector: U,
                                       using rule: IntegrationRule,
                                       stepSize: Float = 1,
                                       result: inout V)
        where
        U: AccelerateBuffer,
        V: AccelerateMutableBuffer,
        U.Element == Float, V.Element == Float {
            
            let n = vDSP_Length(min(vector.count,
                                    result.count))
            
            result.withUnsafeMutableBufferPointer { output in
                vector.withUnsafeBufferPointer { input in
                    switch rule {
                    case .runningSum:
                        vDSP_vrsum(input.baseAddress!, 1,
                                   [stepSize],
                                   output.baseAddress!, 1,
                                   n)
                    case .simpson:
                        vDSP_vsimps(input.baseAddress!, 1,
                                    [stepSize],
                                    output.baseAddress!, 1,
                                    n)
                    case .trapezoidal:
                        vDSP_vtrapz(input.baseAddress!, 1,
                                    [stepSize],
                                    output.baseAddress!, 1,
                                    n)
                    }
                }
            }
    }
    
    /// Integrates source vector using specified rule, double-precision.
    ///
    /// - Parameter vector: The vector to integrate.
    /// - Parameter rule: The integration rule.
    /// - Parameter stepSize: The integration step size (weighting factor for running sum).
    /// - Returns: The integration result.
    @inline(__always)
    @available(iOS 9999, macOS 9999, tvOS 9999, watchOS 9999, *)
    public static func integrate<U>(_ vector: U,
                                    using rule: IntegrationRule,
                                    stepSize: Double = 1) -> [Double]
        where
        U: AccelerateBuffer,
        U.Element == Double {
            
            let result = Array<Double>(unsafeUninitializedCapacity: vector.count) {
                buffer, initializedCount in
                
                integrate(vector,
                          using: rule,
                          result: &buffer)
                
                initializedCount = vector.count
            }
            
            return result
    }
    
    /// Integrates source vector using specified rule, double-precision.
    ///
    /// - Parameter vector: The vector to integrate.
    /// - Parameter rule: The integration rule.
    /// - Parameter stepSize: The integration step size (weighting factor for running sum).
    /// - Parameter result: The destination vector to receive the result.
    @inline(__always)
    @available(iOS 9999, macOS 9999, tvOS 9999, watchOS 9999, *)
    public static func integrate<U, V>(_ vector: U,
                                       using rule: IntegrationRule,
                                       stepSize: Double = 1,
                                       result: inout V)
        where
        U: AccelerateBuffer,
        V: AccelerateMutableBuffer,
        U.Element == Double, V.Element == Double {
            
            let n = vDSP_Length(min(vector.count,
                                    result.count))
            
            result.withUnsafeMutableBufferPointer { output in
                vector.withUnsafeBufferPointer { input in
                    switch rule {
                    case .runningSum:
                        vDSP_vrsumD(input.baseAddress!, 1,
                                    [stepSize],
                                    output.baseAddress!, 1,
                                    n)
                    case .simpson:
                        vDSP_vsimpsD(input.baseAddress!, 1,
                                     [stepSize],
                                     output.baseAddress!, 1,
                                     n)
                    case .trapezoidal:
                        vDSP_vtrapzD(input.baseAddress!, 1,
                                     [stepSize],
                                     output.baseAddress!, 1,
                                     n)
                    }
                }
            }
    }
}
