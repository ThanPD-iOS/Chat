//
//  Created by Alex.M on 27.06.2022.
//

import Foundation
import ExyteChat
import ExyteMediaPicker

final actor MockChatInteractor {
    
    private lazy var chatData = MockChatData()

    @Published private(set) var messages: [Message] = []

    private let isActive: Bool
    private var isLoading = false
    private var lastDate = Date()
    
    var senders: [MockUser] {
        var members = [chatData.steve, chatData.tim]
        if isActive { members.append(chatData.bob) }
        return members
    }
    
    init(isActive: Bool = false) {
        self.isActive = isActive
        Task { await self.generateFirstPage() }
    }

    func generateFirstPage() async {
        self.messages = generateStartMessages()
    }

    /// TODO: Generate error with random chance
    /// TODO: Save images from url to files. Imitate upload process
    func send(draftMessage: ExyteChat.DraftMessage) {
//        if draftMessage.id != nil {
//            guard let index = messages.firstIndex(where: { $0.uid == draftMessage.id }) else {
//                // TODO: Create error
//                return
//            }
//            messages.remove(at: index)
//        }
//
//        Task {
//            let message = await toMockMessage(draftMessage: draftMessage, user: chatData.tim)
//            //DispatchQueue.main.async { [message] in
//                self.messages.append(message)
//           // }
//        }
    }

    func remove(messageID: String) {
//        messages.removeAll(where: { $0.uid == messageID })
    }
    
    /// Adds a reaction to an existing message
//    func add(draftReaction: ExyteChat.DraftReaction, to messageID: String) {
//        if let matchIndex = self.messages.firstIndex(where: { $0.uid == messageID }) {
//            let originalMessage = self.messages[matchIndex]
//            let reaction = Reaction(user: self.chatData.tim.toChatUser(), type: draftReaction.type)
//            let newMessage = MockMessage(
//                uid: originalMessage.uid,
//                sender: originalMessage.sender,
//                createdAt: originalMessage.createdAt,
//                text: originalMessage.text,
//                images: originalMessage.images,
//                videos: originalMessage.videos,
//                reactions: originalMessage.reactions + [reaction],
//                recording: originalMessage.recording,
//                replyMessage: originalMessage.replyMessage
//            )
//            print("Setting Reaction")
//            self.messages[matchIndex] = newMessage
//
//            // Update our message reaction status after a random delay...
//            delayUpdateReactionStatus(messageID: messageID, reactionID: reaction.id)
//
//        } else {
//            print("No Match for Reaction")
//        }
//    }

    /// Updates a reaction's status after a random amount of time
//    func delayUpdateReactionStatus(messageID: String, reactionID: String) {
//        Task {
//            let delay = UInt64.random(in: 1000...3500) * 1_000_000
//            try? await Task.sleep(nanoseconds: delay)
//            updateReactionStatus(messageID: messageID, reactionID: reactionID)
//        }
//    }

//    func updateReactionStatus(messageID: String, reactionID: String) {
//        if let matchIndex = self.messages.firstIndex(where: { $0.uid == messageID }) {
//            let originalMessage = self.messages[matchIndex]
//            if let reactionIndex = originalMessage.reactions.firstIndex(where: { $0.id == reactionID }) {
//                let originalReaction = originalMessage.reactions[reactionIndex]
//
//                var reactions = originalMessage.reactions
//                var status:Reaction.Status = .sent
//                if Int.random(min: 0, max: 20) == 0 {
//                    status = .error(.init(id: originalReaction.id, messageID: originalMessage.uid, createdAt: originalReaction.createdAt, type: originalReaction.type))
//                }
//                reactions[reactionIndex] = .init(id: originalReaction.id, user: originalReaction.user, createdAt: originalReaction.createdAt, type: originalReaction.type, status: status)
//
//                let newMessage = MockMessage(
//                    uid: originalMessage.uid,
//                    sender: originalMessage.sender,
//                    createdAt: originalMessage.createdAt,
//                    text: originalMessage.text,
//                    images: originalMessage.images,
//                    videos: originalMessage.videos,
//                    reactions: reactions,
//                    recording: originalMessage.recording,
//                    replyMessage: originalMessage.replyMessage
//                )
//
//                self.messages[matchIndex] = newMessage
//            } else {
//                print("No Match for Reaction")
//            }
//        } else {
//            print("No Match for Message")
//        }
//    }

    func timerTick() {
        if isActive {
            generateNewMessage()
        }
    }

    func loadNextPage() async {
        guard !isLoading else { return }

        isLoading = true
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds

        messages.append(contentsOf: generateStartMessages())
        isLoading = false
    }
}

private extension MockChatInteractor {
    func generateStartMessages() -> [Message] {
//        defer {
//            lastDate = lastDate.addingTimeInterval(-(60*60*24))
//        }
//        return (0...10)
//            .map { index in
//                // Generate a random message
////                var msg = chatData.randomMessage(senders: senders, date: lastDate.randomTime())
//                // 20% of the time, generate a random reaction to the message
////                if Int.random(in: 0...4) == 0 { msg = chatData.reactToMessage(msg, senders: senders) }
//                // Return the message
//                
//                
//                return msg
//            }
//            .sorted { lhs, rhs in
//                lhs.createdAt < rhs.createdAt
//            }
        
        return [Message(id: UUID().uuidString, messageRole: .assistant)]
    }

    func generateNewMessage() {
        let idx = Int.random(min: 1, max: 30)
        // 30% of the time, lets react to a previous and recent message
        if idx <= 3, messages.count >= idx {
//            let msgIndex = messages.count - idx
//            let message = chatData.reactToMessage(messages[msgIndex], senders: otherSenders)
//            messages[msgIndex] = message
        } else {
            // 70% of the time just create a new random message
//            let message = chatData.randomMessage(senders: otherSenders)
//            messages.append(message)
        }
    }
}

extension MockChatInteractor {
    func toMockMessage(draftMessage: ExyteChat.DraftMessage, user: MockUser) async -> MockMessage {
        MockMessage(
            uid: draftMessage.id ?? UUID().uuidString,
            sender: user,
            createdAt: draftMessage.createdAt,
            text: draftMessage.text,
            images: await makeMockImages(draftMessage),
            videos: await makeMockVideos(draftMessage),
            reactions: [],
            recording: draftMessage.recording,
            replyMessage: draftMessage.replyMessage
        )
    }

    func makeMockImages(_ draftMessage: ExyteChat.DraftMessage) async -> [MockImage] {
        await draftMessage.medias
            .filter { $0.type == .image }
            .asyncMap { (media : Media) -> (Media, URL?, URL?) in
                (media, await media.getThumbnailURL(), await media.getURL())
            }
            .filter { (media: Media, thumb: URL?, full: URL?) -> Bool in
                thumb != nil && full != nil
            }
            .map { media, thumb, full in
                MockImage(id: media.id.uuidString, thumbnail: thumb!, full: full!)
            }
    }

    func makeMockVideos(_ draftMessage: ExyteChat.DraftMessage) async -> [MockVideo] {
        await draftMessage.medias
            .filter { $0.type == .video }
            .asyncMap { (media : Media) -> (Media, URL?, URL?) in
                (media, await media.getThumbnailURL(), await media.getURL())
            }
            .filter { (media: Media, thumb: URL?, full: URL?) -> Bool in
                thumb != nil && full != nil
            }
            .map { media, thumb, full in
                MockVideo(id: media.id.uuidString, thumbnail: thumb!, full: full!)
            }
    }
}
