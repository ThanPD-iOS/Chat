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

public struct ChatMessage: Identifiable, Hashable, Sendable {
    public var id: String
    public var conversationId: UUID
    public let messageRole: MessageRole
    
    public var content: String
    public var isLoading: Bool = false
    public var isFailedToSend: Bool = false
    public var isGenerating: Bool = false
    
    // Not use
    public var createdAt: Date
    public var attachments: [Attachment]
    public var reactions: [Reaction]
    public var giphyMediaId: String?
    public var recording: Recording?
    public var replyMessage: ReplyMessage?

    public init(id: String = UUID().uuidString,
                messageRole: MessageRole,
                conversationId: UUID = UUID(),
                content: String = "",
                isLoading: Bool = false,
                isFailedToSend: Bool = false,
                isGenerating: Bool = false,
                createdAt: Date = Date(),
                attachments: [Attachment] = [],
                giphyMediaId: String? = nil,
                reactions: [Reaction] = [],
                recording: Recording? = nil,
                replyMessage: ReplyMessage? = nil) {

        self.id = id
        self.conversationId = conversationId
        self.messageRole = messageRole
        self.content = content
        self.isLoading = isLoading
        self.isFailedToSend = isFailedToSend
        self.isGenerating = isGenerating
        
        self.createdAt = createdAt
        self.attachments = attachments
        self.giphyMediaId = giphyMediaId
        self.reactions = reactions
        self.recording = recording
        self.replyMessage = replyMessage
    }
}

extension ChatMessage: Equatable {
    public static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.id == rhs.id &&
        lhs.conversationId == rhs.conversationId &&
        lhs.isLoading == rhs.isLoading &&
        lhs.isFailedToSend == rhs.isFailedToSend &&
        lhs.isGenerating == rhs.isGenerating &&
        lhs.messageRole == rhs.messageRole &&
        lhs.createdAt == rhs.createdAt &&
        lhs.content == rhs.content &&
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

    func toMessage() -> ChatMessage {
        ChatMessage(id: id, messageRole: messageRole, content: text, createdAt: createdAt, attachments: attachments, recording: recording)
    }
}

public extension ChatMessage {

    func toReplyMessage() -> ReplyMessage {
        ReplyMessage(id: id, messageRole: messageRole, createdAt: createdAt, text: content, attachments: attachments, recording: recording)
    }
}
