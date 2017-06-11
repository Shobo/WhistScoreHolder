//
//  String+LocalizedError.swift
//  WhistScoreHolder
//
//  Created by Octav Florescu on 11/06/2017.
//  Copyright © 2017 WSHGmbH. All rights reserved.
//

import UIKit

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
