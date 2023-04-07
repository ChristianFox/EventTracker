import Foundation

/// `EventTracker` tracks the occurrences of multiple named `event`s and can be queried to find out if an event's `condition` has been met.
open class EventTracker {

	// ------------------------------------
	// MARK: Error
	// ------------------------------------
	public enum Error: LocalizedError {
		case conditionCanNotBeChangedForAnEventThatIsNotBeingTracked
		case eventCountCanNotBeChangedForAnUntrackedEvent
		case eventCountCanNotBeResetForAnUntrackedEvent

		public var errorDescription: String? {
			String(describing: self)
		}
	}

	// ------------------------------------
	// MARK: Properties
	// ------------------------------------
	// # Public/Internal/Open
	/// If `true` then log messages will be printed out
	public var isLoggingEnabled: Bool

	// # Private/Fileprivate
	/// UserDefaults key for the events dictionary
	static private let kEventsKEY: String = "EventTracker_Events"

	/// UserDefaults key for the conditions dictionary
	static private let kConditionsKEY: String = "EventTracker_Conditions"

	// =======================================
	// MARK: Public Methods
	// =======================================
	// ------------------------------------
	// MARK: Initilisers
	// ------------------------------------
	/// Initialise an instance
	/// - Parameter isLoggingEnabled: If set to `true` then log messages will be printed out. Defaults to `false`
	public init(isLoggingEnabled: Bool = false){
		self.isLoggingEnabled = isLoggingEnabled
	}

	// ------------------------------------
	// MARK: Tracking
	// ------------------------------------
	/// Begin tracking an event with a given identifier and condition.
	///
	/// The method registers a new event with its associated condition and initializes the event count to zero.
	///
	/// - Parameters:
	///   - identifier: The identifier of the event
	///   - condition: How many occurences of the event are required to consider the condition met
	open func trackEvent(forIdentifier identifier: String, withCondition condition: Int) {

		guard !isTrackingEvent(forIdentifier: identifier) else {
			if isLoggingEnabled {
				print("<EventTracker> Event already being tracked with identifier:\(identifier)")
			}
			return
		}

		var events = self.events()
		var conditions = self.conditions()
		events[identifier] = 0
		if isLoggingEnabled {
			print("<EventTracker> New Event being tracked with identifier:\(identifier)")
		}
		conditions[identifier] = condition
		if isLoggingEnabled {
			print("<EventTracker> New Condition being monitored with identifier:\(identifier)")
		}
		UserDefaults.standard.set(events, forKey: EventTracker.kEventsKEY)
		UserDefaults.standard.set(conditions, forKey: EventTracker.kConditionsKEY)
	}

	/// Change the `condition` of an `Event` to a new value
	/// - Parameters:
	///   - condition: How many occurences of the event are required to consider the condition met
	///   - identifier: The identifier of the event
	open func changeCondition(_ condition: Int, forIdentifier identifier: String) throws {

		guard isTrackingEvent(forIdentifier: identifier) else{
			throw Self.Error.conditionCanNotBeChangedForAnEventThatIsNotBeingTracked
		}

		var conditions = self.conditions()
		conditions[identifier] = condition
		UserDefaults.standard.set(conditions, forKey: EventTracker.kConditionsKEY)
		if isLoggingEnabled {
			print("<EventTracker> Condition updated to \(condition) for identifier:\(identifier)")
		}
	}

	/// Add one to the current Event count for the event with the given `identifier`
	/// - Parameter identifier: The identifier of the event
	open func increaseEventCount(forIdentifier identifier: String) throws {

		guard isTrackingEvent(forIdentifier: identifier) else{
			throw Self.Error.eventCountCanNotBeChangedForAnUntrackedEvent
		}

		var events = self.events()
		if let count = events[identifier] {

			events[identifier] = count + 1
			UserDefaults.standard.set(events, forKey: EventTracker.kEventsKEY)

			if isLoggingEnabled {
				print("<EventTracker> Event count increased to \(count+1) for identifier:\(identifier)")
			}
		}
	}

	// ------------------------------------
	// MARK: Resetting
	// ------------------------------------
	/// Reset the event count to 0 the event with the given `identifier`
	/// - Parameter identifier: The identifier of the event
	open func resetEventCount(forIdentifier identifier: String) throws {

		guard isTrackingEvent(forIdentifier: identifier) else{
			throw Self.Error.eventCountCanNotBeResetForAnUntrackedEvent
		}

		var events = self.events()
		events[identifier] = 0
		UserDefaults.standard.set(events, forKey: EventTracker.kEventsKEY)

		if isLoggingEnabled {
			print("<EventTracker> Event count reset to 0 for identifier:\(identifier)")
		}
	}

	/// Stop tracking the event with the given `identifier` and delete any record of it's count and condition
	/// - Parameter identifier: The identifier of the event
	open func stopTrackingEvent(forIdentifier identifier: String) {

		var events = self.events()
		events[identifier] = nil
		UserDefaults.standard.set(events, forKey: EventTracker.kEventsKEY)

		var conditions = self.conditions()
		conditions[identifier] = nil
		UserDefaults.standard.set(conditions, forKey: EventTracker.kConditionsKEY)

		if isLoggingEnabled {
			print("<EventTracker> Stopped tracking Event for identifier:\(identifier)")
		}
	}

	// ------------------------------------
	// MARK: Evaluating
	// ------------------------------------
	/// Has the event occurences matched the condition yet
	/// - Parameter identifier: The identifier of the event
	/// - Returns: True if the number of events is greater or equal to the event's condition
	open func hasEventMetCondition(forIdentifier identifier: String) -> Bool {
		eventCount(forIdentifier: identifier) >= condition(forIdentifier: identifier)
	}

	// ------------------------------------
	// MARK: Querying
	// ------------------------------------
	/// Is the event for the given `identifier` a recognised and tracked event
	/// - Parameter identifier: The identifier of the event
	/// - Returns: True if the event is being tracked
	open func isTrackingEvent(forIdentifier identifier: String) -> Bool {
		events()[identifier] != nil
	}

	/// The number of occurences of the event with the given `identifier`
	/// - Parameter identifier: The identifier of the event
	/// - Returns: The number of occurences of the event
	open func eventCount(forIdentifier identifier: String) -> Int {
		events()[identifier] ?? 0
	}

	/// The condition value of the event with the given `identifier`
	/// - Parameter identifier: The identifier of the event
	/// - Returns: The condition value
	open func condition(forIdentifier identifier:String) -> Int {
		conditions()[identifier] ?? 0
	}

	// =======================================
	// MARK: Private Methods
	// =======================================
	/// Get the events dictionary from UserDefaults, an empty dictionary will be returned if there is none stored
	private func events() -> [String: Int] {
		if let events = UserDefaults.standard.object(forKey: EventTracker.kEventsKEY) as? [String: Int] {
			return events
		}
		return [:]
	}

	/// Get the conditions dictionary from UserDefaults, an empty dictionary will be returned if there is none stored
	private func conditions() -> [String: Int] {
		if let conditions = UserDefaults.standard.object(forKey: EventTracker.kConditionsKEY) as? [String: Int] {
			return conditions
		}
		return [:]
	}
}
