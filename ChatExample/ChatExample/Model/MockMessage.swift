//
//  Created by Alex.M on 27.06.2022.
//

import Foundation
import ExyteChat

struct MockMessage: Sendable {
    let uid: String
    let sender: MockUser
    let createdAt: Date

    let text: String
    let images: [MockImage]
    let videos: [MockVideo]
    let reactions: [Reaction]
    let recording: Recording?
    let replyMessage: ReplyMessage?
}

extension MockMessage {
    func toChatMessage(messageRole: MessageRole) -> ExyteChat.ChatMessage {
        ExyteChat.ChatMessage(
            id: uid,
            messageRole: messageRole,
            content: text,
            createdAt: createdAt,
            attachments: images.map { $0.toChatAttachment() } + videos.map { $0.toChatAttachment() },
            reactions: reactions,
            recording: recording,
            replyMessage: replyMessage
        )
    }
}
