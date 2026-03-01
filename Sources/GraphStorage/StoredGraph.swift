//
//  StoredGraph.swift
//
//  Created by Ilya Belenkiy on 2/25/26.
//

import Foundation

public enum StoredGraphError: Error, Equatable {
    case missingMetadata(key: String)
    case duplicateMetadata(key: String, count: Int)
    case missingNode(id: String)
    case duplicateNodes(id: String, count: Int)
}

public struct StoredGraph: Codable, Equatable {
    public struct Metadata: Codable, Equatable {
        public let key: String
        public let value: String

        public init(
            key: String,
            value: String
        ) {
            self.key = key
            self.value = value
        }
    }

    public struct EmptyPayload: Codable, Equatable {
        public init() {}
    }

    public struct Node: Codable, Equatable {
        public let id: String
        public let kind: String
        public let order: Int
        public let payloadType: String
        public let payload: Data

        public init(
            id: String,
            kind: String,
            order: Int,
            payloadType: String,
            payload: Data
        ) {
            self.id = id
            self.kind = kind
            self.order = order
            self.payloadType = payloadType
            self.payload = payload
        }

        public init<Value: Encodable>(
            id: String,
            kind: String,
            order: Int,
            payloadType: String,
            payload: Value,
            encoder: JSONEncoder = JSONEncoder()
        ) throws {
            self.init(
                id: id,
                kind: kind,
                order: order,
                payloadType: payloadType,
                payload: try encoder.encode(payload)
            )
        }

        public func decodePayload<Value: Decodable>(
            as valueType: Value.Type,
            decoder: JSONDecoder = JSONDecoder()
        ) throws -> Value {
            try decoder.decode(valueType, from: payload)
        }
    }

    public struct Edge: Codable, Equatable {
        public let id: String
        public let kind: String
        public let order: Int
        public let fromNodeId: String
        public let toNodeId: String
        public let payloadType: String
        public let payload: Data

        public init(
            id: String,
            kind: String,
            order: Int,
            fromNodeId: String,
            toNodeId: String,
            payloadType: String,
            payload: Data
        ) {
            self.id = id
            self.kind = kind
            self.order = order
            self.fromNodeId = fromNodeId
            self.toNodeId = toNodeId
            self.payloadType = payloadType
            self.payload = payload
        }

        public init<Value: Encodable>(
            id: String,
            kind: String,
            order: Int,
            fromNodeId: String,
            toNodeId: String,
            payloadType: String,
            payload: Value,
            encoder: JSONEncoder = JSONEncoder()
        ) throws {
            self.init(
                id: id,
                kind: kind,
                order: order,
                fromNodeId: fromNodeId,
                toNodeId: toNodeId,
                payloadType: payloadType,
                payload: try encoder.encode(payload)
            )
        }

        public func decodePayload<Value: Decodable>(
            as valueType: Value.Type,
            decoder: JSONDecoder = JSONDecoder()
        ) throws -> Value {
            try decoder.decode(valueType, from: payload)
        }
    }

    public let metadata: [Metadata]
    public let nodes: [Node]
    public let edges: [Edge]

    public init(
        metadata: [Metadata],
        nodes: [Node],
        edges: [Edge]
    ) {
        self.metadata = metadata
        self.nodes = nodes
        self.edges = edges
    }

    public func metadataValues(
        key: String
    ) -> [String] {
        metadata
            .filter { $0.key == key }
            .map(\.value)
    }

    public func requiredSingleMetadataValue(
        key: String
    ) throws -> String {
        let matchingValues = metadataValues(key: key)
        guard !matchingValues.isEmpty else {
            throw StoredGraphError.missingMetadata(key: key)
        }

        guard matchingValues.count == 1 else {
            throw StoredGraphError.duplicateMetadata(key: key, count: matchingValues.count)
        }

        return matchingValues[0]
    }

    public func requiredSingleNode(
        id: String
    ) throws -> Node {
        let matchingNodes = nodes.filter { $0.id == id }
        guard !matchingNodes.isEmpty else {
            throw StoredGraphError.missingNode(id: id)
        }

        guard matchingNodes.count == 1 else {
            throw StoredGraphError.duplicateNodes(id: id, count: matchingNodes.count)
        }

        return matchingNodes[0]
    }
}
