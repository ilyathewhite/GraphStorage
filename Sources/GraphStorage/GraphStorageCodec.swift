//
//  GraphStorageCodec.swift
//
//  Created by Ilya Belenkiy on 2/25/26.
//

import Foundation

public enum GraphStorageCodec {
    public static let compressedDataExtension = "lzma"

    public static func encodeCompressed<Value: Encodable>(
        _ value: Value,
        encoder: JSONEncoder = JSONEncoder()
    ) throws -> Data {
        let data = try encoder.encode(value)
        return try compress(data)
    }

    public static func decodeCompressed<Value: Decodable>(
        _ valueType: Value.Type,
        from compressedData: Data,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> Value {
        let data = try decompress(compressedData)
        return try decoder.decode(valueType, from: data)
    }

    public static func saveCompressed<Value: Encodable>(
        _ value: Value,
        to url: URL,
        encoder: JSONEncoder = JSONEncoder()
    ) throws {
        let data = try encodeCompressed(value, encoder: encoder)
        try data.write(to: url)
    }

    public static func loadCompressed<Value: Decodable>(
        _ valueType: Value.Type,
        from url: URL,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> Value {
        let compressedData = try Data(contentsOf: url)
        return try decodeCompressed(valueType, from: compressedData, decoder: decoder)
    }

    public static func compress(_ data: Data) throws -> Data {
        try (data as NSData).compressed(using: .lzma) as Data
    }

    public static func decompress(_ data: Data) throws -> Data {
        try (data as NSData).decompressed(using: .lzma) as Data
    }
}
