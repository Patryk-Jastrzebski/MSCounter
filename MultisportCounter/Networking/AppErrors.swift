//
//  AppErrors.swift
//  TravelApp
//
//  Created by Patryk Jastrzębski on 10/06/2023.
//

import Foundation

enum AppError: Error {
    case invalidURL
    case httpError
    case urlError
    case imageError
    case apiError(code: Int, data: Data?)
}
