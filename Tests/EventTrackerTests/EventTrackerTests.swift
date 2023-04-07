import XCTest
@testable import EventTracker

final class EventTrackerTests: XCTestCase {

	// ------------------------------------
	// MARK: Properties
	// ------------------------------------
	// # Public/Internal/Open

	// # Private/Fileprivate
	private var sut: EventTracker!
	private let identifier: String = "testEvent"

	// =======================================
	// MARK: Setup / Teardown
	// =======================================
	override func setUpWithError() throws {
		try super.setUpWithError()
		// enable logging to get fuller code coverage
		sut = EventTracker(isLoggingEnabled: true)
	}

	override func tearDownWithError() throws {
		sut.stopTrackingEvent(forIdentifier: identifier)
		sut = nil
		try super.tearDownWithError()
	}

	// =======================================
	// MARK: Tests
	// =======================================
	// ------------------------------------
	// MARK: trackEvent(forIdentifier: withCondition:)
	// ------------------------------------
	func testTrackEvent_NotTracked_BeingsTracking() {

		// GIVEN

		// WHEN
		sut.trackEvent(forIdentifier: identifier, withCondition: 1)

		// THEN
		XCTAssertTrue(sut.isTrackingEvent(forIdentifier: identifier))
		XCTAssertEqual(sut.condition(forIdentifier: identifier), 1)
	}

	func testTrackEvent_EventAlreadyBeingTracked_NoOp() {

		// GIVEN
		sut.trackEvent(forIdentifier: identifier, withCondition: 1)

		// WHEN
		sut.trackEvent(forIdentifier: identifier, withCondition: 10)

		// THEN
		XCTAssertTrue(sut.isTrackingEvent(forIdentifier: identifier))
		XCTAssertEqual(sut.condition(forIdentifier: identifier), 1)
	}

	// ------------------------------------
	// MARK: changeCondition(_: forIdentifier:)
	// ------------------------------------
	func testChangeCondition_IsTracked_ChangesCondition() throws {

		// GIVEN
		sut.trackEvent(forIdentifier: identifier, withCondition: 1)

		// WHEN
		try sut.changeCondition(2, forIdentifier: identifier)

		// THEN
		XCTAssertTrue(sut.isTrackingEvent(forIdentifier: identifier))
		XCTAssertEqual(sut.condition(forIdentifier: identifier), 2)
	}

	func testChangeCondition_UntrackedEvent_Throws() {

		XCTAssertThrowsError(try sut.changeCondition(99, forIdentifier: "none")) { error in
			XCTAssertTrue(error is EventTracker.Error)
			XCTAssertEqual(error as! EventTracker.Error, EventTracker.Error.conditionCanNotBeChangedForAnEventThatIsNotBeingTracked)
			XCTAssertEqual((error as! EventTracker.Error).errorDescription, EventTracker.Error.conditionCanNotBeChangedForAnEventThatIsNotBeingTracked.errorDescription)
		}
	}

	// ------------------------------------
	// MARK: increaseEventCount(forIdentifier:)
	// ------------------------------------
	func testIncreaseEventCount_IsTracked_IncreasesCount() throws {

		// GIVEN
		sut.trackEvent(forIdentifier: identifier, withCondition: 3)

		// WHEN
		try sut.increaseEventCount(forIdentifier: identifier)
		try sut.increaseEventCount(forIdentifier: identifier)

		// THEN
		XCTAssertEqual(sut.eventCount(forIdentifier: identifier), 2)
	}

	func testIncreaseEventCount_UntrackedEvent_Throws() {

		XCTAssertThrowsError(try sut.increaseEventCount(forIdentifier: "none")) { error in
			XCTAssertTrue(error is EventTracker.Error)
			XCTAssertEqual(error as! EventTracker.Error, EventTracker.Error.eventCountCanNotBeChangedForAnUntrackedEvent)
			XCTAssertEqual((error as! EventTracker.Error).errorDescription, EventTracker.Error.eventCountCanNotBeChangedForAnUntrackedEvent.errorDescription)
		}
	}

	//------------------------------------
	// MARK: resetEventCount(forIdentifier:)
	//------------------------------------
	func testResetEventCount_IsTracked_Resets() throws {

		// GIVEN
		sut.trackEvent(forIdentifier: identifier, withCondition: 3)
		try sut.increaseEventCount(forIdentifier: identifier)
		try sut.increaseEventCount(forIdentifier: identifier)

		// WHEN
		try sut.resetEventCount(forIdentifier: identifier)

		// THEN
		XCTAssertEqual(sut.eventCount(forIdentifier: identifier), 0)
	}

	func testResetEventCount_UntrackedEvent_Throws() {

		XCTAssertThrowsError(try sut.resetEventCount(forIdentifier: "none")) { error in
			XCTAssertTrue(error is EventTracker.Error)
			XCTAssertEqual(error as! EventTracker.Error, EventTracker.Error.eventCountCanNotBeResetForAnUntrackedEvent)
			XCTAssertEqual((error as! EventTracker.Error).errorDescription, EventTracker.Error.eventCountCanNotBeResetForAnUntrackedEvent.errorDescription)
		}
	}

	//------------------------------------
	// MARK: Evaluating
	//------------------------------------
	func testHasEventMetCondition_ItHas_ReturnsTrue() throws {

		// GIVEN
		sut.trackEvent(forIdentifier: identifier, withCondition: 3)
		try sut.increaseEventCount(forIdentifier: identifier)
		try sut.increaseEventCount(forIdentifier: identifier)
		XCTAssertFalse(sut.hasEventMetCondition(forIdentifier: identifier))

		// WHEN
		try sut.increaseEventCount(forIdentifier: identifier)

		// THEN
		XCTAssertTrue(sut.hasEventMetCondition(forIdentifier: identifier))
	}

	//------------------------------------
	// MARK: Querying
	//------------------------------------
	func testQueries_ForTrackedEvent() throws {

		// GIVEN
		sut.trackEvent(forIdentifier: identifier, withCondition: 3)

		// WHEN, THEN
		XCTAssertTrue(sut.isTrackingEvent(forIdentifier: identifier))
		try sut.increaseEventCount(forIdentifier: identifier)
		XCTAssertEqual(sut.eventCount(forIdentifier: identifier), 1)
		XCTAssertEqual(sut.condition(forIdentifier: identifier), 3)
	}

	func testQueries_ForUntrackedEvent() throws {

		// GIVEN
		let id = "NotTracked"

		// WHEN, THEN
		XCTAssertFalse(sut.isTrackingEvent(forIdentifier: id))
		XCTAssertEqual(sut.eventCount(forIdentifier: id), 0)
		XCTAssertEqual(sut.condition(forIdentifier: id), 0)
	}
}

