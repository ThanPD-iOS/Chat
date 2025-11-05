//
//  ReactionDelegate.swift
//  Chat
//

/// A delegate for responding to Message Reactions and optionally configuring the Reaction Menu
///
/// ```swift
/// func didReact(to message: Message, reaction: DraftReaction)
///
/// // Optional configuration methods
/// func shouldShowOverview(for message: Message) -> Bool
/// func canReact(to message: Message) -> Bool
/// func reactions(for message: Message) -> [ReactionType]?
/// func allowEmojiSearch(for message: Message) -> Bool
/// ```
public protocol ReactionDelegate {
    
    /// Called when the sender reacts to a message
    /// - Parameters:
    ///   - message: The `Message` they reacted to
    ///   - reaction: The `DraftReaction` that should be sent / applied to the `Message`
    func didReact(to message: ChatMessage, reaction: DraftReaction) -> Void
    
    /// Determines whether or not the Sender can react to a given `Message`
    /// - Parameter message: The `Message` the Sender is interacting with
    /// - Returns: A Bool indicating whether or not the Sender should be able to react to the given `Message`
    ///
    /// - Note: Optional, defaults to `true`
    /// - Note: Called when Chat is preparing to show the Message Menu
    func canReact(to message:ChatMessage) -> Bool
    
    /// Allows for the configuration of the Reactions available to the Sender for a given `Message`
    /// - Parameter message: The `Message` the Sender is interacting with
    /// - Returns: A list of `ReactionTypes` available for the Sender to use
    ///
    /// - Note: Optional, defaults to a standard set of emojis
    /// - Note: Called when Chat is preparing to show the Message Menu
    func reactions(for message:ChatMessage) -> [ReactionType]?
    
    /// Whether or not the Sender should be able to search for an emoji using the Keyboard for a given `Message`
    /// - Parameter message: The `Message` the Sender is interacting with
    /// - Returns: Whether or not the Sender can search for a custom emoji.
    ///
    /// - Note: Optional, defaults to `true`
    /// - Note: Called when Chat is preparing to show the Message Menu
    func allowEmojiSearch(for message:ChatMessage) -> Bool
    
    /// Whether or not the Message Menu should include a reaction overview at the top of the screen
    /// - Parameter message: The `Message` the Sender is interacting with
    /// - Returns: Whether the overview is shown or not
    ///
    /// - Note: Optional, defaults to `true` when the message has one or more reactions.
    /// - Note: Called when Chat is preparing to show the Message Menu
    func shouldShowOverview(for message:ChatMessage) -> Bool
}

public extension ReactionDelegate {
    func canReact(to message: ChatMessage) -> Bool { true }
    func reactions(for message: ChatMessage) -> [ReactionType]? { nil }
    func allowEmojiSearch(for message: ChatMessage) -> Bool { true }
    func shouldShowOverview(for message:ChatMessage) -> Bool { !message.reactions.isEmpty }
}

/// We use this implementation of ReactionDelegate for when the user wants to use the callback modifier instead of providing us with a dedicated delegate
struct DefaultReactionConfiguration: ReactionDelegate {
    // Non optional didReact handler
    var didReact: (ChatMessage, DraftReaction) -> Void
    
    // Optional handlers for further configuration
    var canReact: ((ChatMessage) -> Bool)? = nil
    var reactions: ((ChatMessage) -> [ReactionType]?)? = nil
    var allowEmojiSearch: ((ChatMessage) -> Bool)? = nil
    var shouldShowOverview: ((ChatMessage) -> Bool)? = nil
    
    init(
        didReact: @escaping (ChatMessage, DraftReaction) -> Void,
        canReact: ((ChatMessage) -> Bool)? = nil,
        reactions: ((ChatMessage) -> [ReactionType]?)? = nil,
        allowEmojiSearch: ((ChatMessage) -> Bool)? = nil,
        shouldShowOverview: ((ChatMessage) -> Bool)? = nil
    ) {
        self.didReact = didReact
        self.canReact = canReact
        self.reactions = reactions
        self.allowEmojiSearch = allowEmojiSearch
        self.shouldShowOverview = shouldShowOverview
    }
    
    func didReact(to message: ChatMessage, reaction: DraftReaction) {
        didReact(message, reaction)
    }
    
    func shouldShowOverview(for message: ChatMessage) -> Bool {
        if let shouldShowOverview { return shouldShowOverview(message) }
        else { return !message.reactions.isEmpty }
    }
    
    func canReact(to message: ChatMessage) -> Bool {
        if let canReact { return canReact(message) }
        else { return true }
    }
    
    func reactions(for message: ChatMessage) -> [ReactionType]? {
        if let reactions { return reactions(message) }
        else { return nil }
    }
    
    func allowEmojiSearch(for message: ChatMessage) -> Bool {
        if let allowEmojiSearch { return allowEmojiSearch(message) }
        else { return true }
    }
}
