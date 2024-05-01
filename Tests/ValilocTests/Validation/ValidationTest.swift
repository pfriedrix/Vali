//
//  ValidationTest.swift
//
//
//  Created by Pfriedrix on 20.03.2024.
//

import XCTest
@testable import Valiloc

final class ValidationTest: XCTestCase {
    
    func testPerformanceExample() throws {
        let validator = EmptyValidator()
        XCTAssertTrue(validator.validate())
    }
    
    func testGroupValidator() {
        let groupValidator = GroupValidator(validators: [RangeValidator(with: 1...10, for: 5), RangeValidator(with: 1...10, for: 3), RangeValidator(with: 1...10, for: 9)])
        XCTAssertTrue(groupValidator.validate(), "GroupValidator should return true if all included validators return true.")
        
        let failingGroupValidator = GroupValidator(validators: [RangeValidator(with: 1...10, for: 11)])
        XCTAssertFalse(failingGroupValidator.validate(), "GroupValidator should return false if any included validator returns false.")
    }
    
    func testRangeValidator() {
        let rangeValidator = RangeValidator(with: 1...10, for: 5)
        XCTAssertTrue(rangeValidator.validate(), "RangeValidator should return true for a value within the range.")
        
        let outOfRangeValidator = RangeValidator(with: 1...10, for: 11)
        XCTAssertFalse(outOfRangeValidator.validate(), "RangeValidator should return false for a value outside the range.")
    }
    
    func testTupleValidator() {
        let tupleValidator = TupleValidator((EmptyValidator(), RangeValidator(with: 1...10, for: 5)))
        XCTAssertTrue(tupleValidator.validate(), "TupleValidator should return true if all elements validate true.")
        
        let failingTupleValidator = TupleValidator((EmptyValidator(), RangeValidator(with: 1...10, for: 11)))
        XCTAssertFalse(failingTupleValidator.validate(), "TupleValidator should return false if any element validates false.")
    }
    
    func testConditionValidator() {
        let firstConditionValidator = ConditionValidator(first: RangeValidator(with: 1...10, for: 5), second: EmptyValidator())
        XCTAssertTrue(firstConditionValidator.validate(), "ConditionValidator should validate true when the first condition is met.")
        
        let secondConditionValidator = ConditionValidator(first: EmptyValidator(), second: EmptyValidator())
        XCTAssertTrue(secondConditionValidator.validate(), "ConditionValidator should validate true when the second condition exists.")
        
        let failingConditionValidator = ConditionValidator<RangeValidator<Int, ClosedRange<Int>>, EmptyValidator>(first: nil, second: nil)
        XCTAssertTrue(failingConditionValidator.validate(), "ConditionValidator should validate true when both conditions are nil.")
    }
    
    func testSingleValidatorBuilding() {
        let validator = RangeValidator(with: 1...10, for: 5)

        XCTAssertTrue(validator.validate(), "ValidatorBuilder should correctly build and validate a single validator.")
    }
    
    func testMultipleValidatorsBuilding() {
        var validator: some Validator {
            Validate {
                RangeValidator(with: 1...10, for: 5)
                EmptyValidator()
            }
        }
        
        XCTAssertTrue(validator.validate(), "ValidatorBuilder should correctly build and validate multiple validators.")
    }
    
    func testOptionalValidatorBuilding() {
        let optionalRangeValidator: RangeValidator<Int, ClosedRange<Int>> = RangeValidator(with: 1...10, for: 5)
        var validator: some Validator {
            if true {
                optionalRangeValidator
            } else {
                RangeValidator(with: 1...10, for: 11)
            }
        }
        
        XCTAssertTrue(validator.validate(), "ValidatorBuilder should correctly handle optional validators.")
    }
    
    func testConditionalValidatorsBuilding() {
        let condition = true
        var validator: some Validator {
            Validate {
                RangeValidator(with: 1...10, for: 5)
                EmptyValidator()
                if condition {
                    RangeValidator(with: 1...10, for: 5)
                }
            }
        }
        
        XCTAssertTrue(validator.validate(), "ValidatorBuilder should correctly handle conditional validators based on a condition.")
        
        var eitherValidator: some Validator {
            Validate {
                if condition {
                    RangeValidator(with: 1...10, for: 5)
                }
            }
        }
        
        XCTAssertTrue(eitherValidator.validate(), "ValidatorBuilder should correctly handle conditional validators with ConditionValidator.")
    }
    
    func testForEachValidator() {
        let data = [5, 7, 10]
        let forEachValidator = ForEachValidator(data, id: \.self) { value in
            RangeValidator(with: 1...10, for: value)
        }
        
        XCTAssertTrue(forEachValidator.validate(), "ForEachValidator should return true when all elements validate true within the range.")
        
        let failingData = [5, 12, 10]
        let failingForEachValidator = ForEachValidator(failingData, id: \.self) { value in
            RangeValidator(with: 1...10, for: value)
        }
        
        XCTAssertFalse(failingForEachValidator.validate(), "ForEachValidator should return false if any element validates false (outside the range).")
    }
}
