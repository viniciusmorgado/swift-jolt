//
//  JoltBindings.swift
//  swift-jolt
//
//  Created by Vinicius Donatto Morgado on 07/11/26.
//

internal import CJolt

func initializeJolt() -> Bool {
    JPH_Init()
}

func shutdownJolt() {
    JPH_Shutdown()
}
