//
//  APIServerResponse.swift
//  YouTVDemo
//
//  Created by Farshad Mousalou on 4/29/21.
//  Copyright © 2021 iFarshad. All rights reserved.
//

import Foundation

/**
 The `APIServerResponse` is corresponding to decoding the API Server Response.

 The `APIServerResponse` work around the Server Response. it also make the response more generic and readable.
 It also redude the code that we should create every single response.
 */
struct APIServerResponse <T> where T: Decodable {

    /// The `APIServerResponseStatus` value indicate the response data is success or not.
    var status: APIServerResponseStatus = .success

    /// The `String` value that is passed by server response.
    /// whether the result is success or not.
    var message: String?

    /// The generic type for `T`. this is corresponding to hold the response data.
    var data: T?

    /// The `CodingKey`s to be used in decoding process
    enum CodingKeys: String, CodingKey {
        case status = "success"
        case code = "status_code"
        case message = "status_message"
    }

    /// Default initializer
    /// - Parameter status: `APIServerResponseStatus`
    init(status: APIServerResponseStatus) {
        self.status = status
    }

}

/**
 The `Decodable` implementation.
 */
extension APIServerResponse: Decodable {

    /// The `Decodable` initializer for `APIServerResponse`
    /// - Parameter decoder: the `Decoder` container to be used to extract the server data
    /// - Throws: `APIServerResponseError`, if process meet error.
    public init(from decoder: Decoder) throws {

        if let valuesContainer = try? decoder.container(keyedBy: CodingKeys.self) {
            self.status = try valuesContainer.decodeIfPresent(APIServerResponseStatus.self, forKey: .status) ?? .success

            do {
                self.message = try valuesContainer.decodeIfPresent(String.self, forKey: .message)
            }catch {
                self.message = nil
            }

            guard status == .success else {

                if let errorType = try? valuesContainer.decodeIfPresent(Int.self, forKey: .code) {

                    if let message = try? valuesContainer.decodeIfPresent(String.self, forKey: .message) {
                        self.message = message
                        throw APIServerResponseError.message(code: "\(errorType)",message: message)
                    }else {
                        throw APIServerResponseError.code("\(errorType)")
                    }

                } else {
                    throw APIServerResponseError.unknown
                }

            }
        }else {
            self.status = .success
        }

        do {
            self.data = try T(from: decoder)
        }catch {
            self.data = nil
            throw APIServerResponseError.message(code: "Decoding", message: "\(error.localizedDescription)")
        }

    }

}

extension APIServerResponse: CustomDebugStringConvertible {

    /// :nodoc:
    var debugDescription: String {
        let message = self.message ?? "no message"
        return "[Server-Response] status = \(status) message= \(message) error = empty data = \(data)"
    }
}
