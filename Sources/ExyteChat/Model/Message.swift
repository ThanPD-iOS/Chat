//
//  Message.swift
//  Chat
//
//  Created by Alisa Mylnikova on 20.04.2022.
//

import SwiftUI

public enum MessageRole: Int, Codable, Sendable {
    case user
    case assistant
}

class ChatMessage: Identifiable, Equatable, ObservableObject {
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: String = UUID().uuidString
    var conversationId: UUID
    let messageRole: MessageRole
    
    var content: String
    var isLoading: Bool = false
    var isFailedToSend: Bool = false
    var isGenerating: Bool = false
    
    init(id: String = UUID().uuidString, content: String, messageRole: MessageRole,
         isLoading: Bool = false, conversationId: UUID, isGenerating: Bool = false) {
        self.id = id
        self.content = content
        self.messageRole = messageRole
        self.isLoading = isLoading
        self.conversationId = conversationId
        self.isGenerating = isGenerating
    }
}

public struct Message: Identifiable, Hashable, Sendable {
    public var id: String
    public let messageRole: MessageRole
    public var createdAt: Date

    public var text: String
    public var attachments: [Attachment]
    public var reactions: [Reaction]
    public var giphyMediaId: String?
    public var recording: Recording?
    public var replyMessage: ReplyMessage?

    public init(id: String,
                messageRole: MessageRole,
                createdAt: Date = Date(),
                text: String = "",
                attachments: [Attachment] = [],
                giphyMediaId: String? = nil,
                reactions: [Reaction] = [],
                recording: Recording? = nil,
                replyMessage: ReplyMessage? = nil) {

        self.id = id
        self.messageRole = messageRole
        self.createdAt = createdAt
        self.text = text
        self.attachments = attachments
        self.giphyMediaId = giphyMediaId
        self.reactions = reactions
        self.recording = recording
        self.replyMessage = replyMessage
    }
}

extension Message: Equatable {
    public static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id &&
        lhs.messageRole == rhs.messageRole &&
        lhs.createdAt == rhs.createdAt &&
        lhs.text == rhs.text &&
        lhs.giphyMediaId == rhs.giphyMediaId &&
        lhs.attachments == rhs.attachments &&
        lhs.reactions == rhs.reactions &&
        lhs.recording == rhs.recording &&
        lhs.replyMessage == rhs.replyMessage
    }
}

public struct Recording: Codable, Hashable, Sendable {
    public var duration: Double
    public var waveformSamples: [CGFloat]
    public var url: URL?

    public init(duration: Double = 0.0, waveformSamples: [CGFloat] = [], url: URL? = nil) {
        self.duration = duration
        self.waveformSamples = waveformSamples
        self.url = url
    }
}

public struct ReplyMessage: Codable, Identifiable, Hashable, Sendable {
    public static func == (lhs: ReplyMessage, rhs: ReplyMessage) -> Bool {
        lhs.id == rhs.id &&
        lhs.messageRole == rhs.messageRole &&
        lhs.createdAt == rhs.createdAt &&
        lhs.text == rhs.text &&
        lhs.attachments == rhs.attachments &&
        lhs.recording == rhs.recording
    }

    public var id: String
    public var messageRole: MessageRole
    public var createdAt: Date

    public var text: String
    public var attachments: [Attachment]
    public var recording: Recording?

    public init(id: String,
                messageRole: MessageRole,
                createdAt: Date,
                text: String = "",
                attachments: [Attachment] = [],
                recording: Recording? = nil) {

        self.id = id
        self.messageRole = messageRole
        self.createdAt = createdAt
        self.text = text
        self.attachments = attachments
        self.recording = recording
    }

    func toMessage() -> Message {
        Message(id: id, messageRole: messageRole, createdAt: createdAt, text: text, attachments: attachments, recording: recording)
    }
}

public extension Message {

    func toReplyMessage() -> ReplyMessage {
        ReplyMessage(id: id, messageRole: messageRole, createdAt: createdAt, text: text, attachments: attachments, recording: recording)
    }
}
