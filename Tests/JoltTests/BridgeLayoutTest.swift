//
//  BridgeLayoutTest.swift
//  swift-jolt
//
//  Created by Vinicius Donatto Morgado on 07/11/26.
//


import CJolt
import Testing

@Test func positionUseDoublePrecisionAcrossTheBridge() {
    #expect(MemoryLayout<JPH_RVec3>.size == 24)
}
