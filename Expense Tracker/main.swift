//
//  main.swift
//  Expense Tracker
//
//  Created by madi on 3/28/19.
//  Copyright © 2019 com.madi.budget. All rights reserved.
//

import UIKit

CommandLine.unsafeArgv.withMemoryRebound(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
{    argv in
    _ = UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, NSStringFromClass(TimerApplication.self), NSStringFromClass(AppDelegate.self))
}
