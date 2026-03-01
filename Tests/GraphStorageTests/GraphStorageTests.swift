import Foundation
import Testing
@testable import GraphStorage

@Suite
struct GraphStorageTests {
    struct TestPayload: Codable, Equatable {
        let message: String
        let count: Int
    }

    @Test
    func nodeRoundTripsTypedPayload() throws {
        let payload = TestPayload(message: "trace", count: 2)
        let node = try StoredGraph.Node(
            id: "n1",
            kind: "action",
            order: 1,
            payloadType: "ReducerArchitecture.SessionGraph",
            payload: payload
        )

        let decoded = try node.decodePayload(as: TestPayload.self)
        #expect(decoded == payload)
    }

    @Test
    func edgeRoundTripsTypedPayload() throws {
        let payload = TestPayload(message: "edge", count: 3)
        let edge = try StoredGraph.Edge(
            id: "e1",
            kind: "applied",
            order: 2,
            fromNodeId: "n1",
            toNodeId: "n2",
            payloadType: "ReducerArchitecture.SessionGraph.AppliedEdge",
            payload: payload
        )

        let decoded = try edge.decodePayload(as: TestPayload.self)
        #expect(decoded == payload)
    }

    @Test
    func requiredSingleMetadataValueThrowsWhenMissing() {
        let graph = StoredGraph(metadata: [], nodes: [], edges: [])

        #expect(throws: StoredGraphError.missingMetadata(
            key: "trace.title"
        )) {
            _ = try graph.requiredSingleMetadataValue(key: "trace.title")
        }
    }

    @Test
    func requiredSingleMetadataValueThrowsWhenDuplicate() {
        let graph = StoredGraph(
            metadata: [
                .init(key: "trace.title", value: "a"),
                .init(key: "trace.title", value: "b")
            ],
            nodes: [],
            edges: []
        )

        #expect(throws: StoredGraphError.duplicateMetadata(
            key: "trace.title",
            count: 2
        )) {
            _ = try graph.requiredSingleMetadataValue(key: "trace.title")
        }
    }

    @Test
    func compressedCodecRoundTripsStoredGraph() throws {
        let payload = TestPayload(message: "graph", count: 3)
        let graph = StoredGraph(
            metadata: [
                .init(key: "trace.title", value: "Session Trace")
            ],
            nodes: [
                try .init(
                    id: "n1",
                    kind: "action",
                    order: 1,
                    payloadType: "ReducerArchitecture.SessionGraph",
                    payload: payload
                )
            ],
            edges: []
        )

        let compressedData = try GraphStorageCodec.encodeCompressed(graph)
        let decoded = try GraphStorageCodec.decodeCompressed(
            StoredGraph.self,
            from: compressedData
        )
        #expect(decoded == graph)
    }
}
