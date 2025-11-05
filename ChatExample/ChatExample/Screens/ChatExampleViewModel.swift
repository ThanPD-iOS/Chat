//
//  Created by Alex.M on 23.06.2022.
//

import Foundation
import ExyteChat

@MainActor
final class ChatExampleViewModel: ObservableObject, ReactionDelegate {

    @Published var messages: [ChatMessage] = []

    @Published var chatTitle: String = ""
    @Published var chatStatus: String = ""
    @Published var chatCover: URL?

    private let interactor: MockChatInteractor
    private var timer: Timer?

    init(interactor: MockChatInteractor = MockChatInteractor()) {
        self.interactor = interactor
        messages = [
            ChatMessage(id: UUID().uuidString, messageRole: .assistant, content: "thanduc"),
            ChatMessage(id: UUID().uuidString, messageRole: .user, content: "ducthan"),
            ChatMessage(id: UUID().uuidString, messageRole: .assistant, content: "thanduc"),
            ChatMessage(id: UUID().uuidString, messageRole: .user, content: "ducthan"),
            ChatMessage(id: UUID().uuidString, messageRole: .assistant, content: "thanduc"),
            ChatMessage(id: UUID().uuidString, messageRole: .user, content: "ducthan"),
            ChatMessage(id: UUID().uuidString, messageRole: .assistant, content: "thanduc"),
            ChatMessage(id: UUID().uuidString, messageRole: .user, content: "ducthan"),
            ChatMessage(id: UUID().uuidString, messageRole: .assistant, content: "thanduc"),
            ChatMessage(id: UUID().uuidString, messageRole: .user, content: "ducthan"),
        ]
    }

    func send(draft: DraftMessage) {
        Task {
            await interactor.send(draftMessage: draft)
            self.updateMessages()
        }
    }
    
    func remove(messageID: String) {
        Task {
            await interactor.remove(messageID: messageID)
            self.updateMessages()
        }
    }

    nonisolated func didReact(to message: ChatMessage, reaction draftReaction: DraftReaction) {
        Task {
//            await interactor.add(draftReaction: draftReaction, to: draftReaction.messageID)
        }
    }

    func onStart() {
        Task {
            self.updateMessages()
            connect()
        }
    }

    func connect() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            Task {
                await self.interactor.timerTick()
                await self.updateMessages()
            }
        }
    }

    func onStop() {
        timer?.invalidate()
    }

    func loadMoreMessage(before message: ChatMessage) {
        Task {
            await interactor.loadNextPage()
            updateMessages()
        }
    }

    func updateMessages() {
        let number = Int.random(in: 0..<100)
        print("phungducthan \(number)")
        Task {
//            self.messages = await interactor.messages
        }
    }
}
