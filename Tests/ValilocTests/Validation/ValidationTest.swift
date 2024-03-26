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
    
    func testRangeValidator() {
        let rangeValidator = RangeValidator(with: 1...10, for: 5)
        XCTAssertTrue(rangeValidator.validate(), "RangeValidator should return true for a value within the range.")
        
        let outOfRangeValidator = RangeValidator(with: 1...10, for: 11)
        XCTAssertFalse(outOfRangeValidator.validate(), "RangeValidator should return false for a value outside the range.")
    }
    
    func testTupleValidator() {
        let tupleValidator = TupleValidator(value: (EmptyValidator(), RangeValidator(with: 1...10, for: 5)))
        XCTAssertTrue(tupleValidator.validate(), "TupleValidator should return true if all elements validate true.")
        
        let failingTupleValidator = TupleValidator(value: (EmptyValidator(), RangeValidator(with: 1...10, for: 11)))
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
        let validator: Validate = Validate {
            RangeValidator(with: 1...10, for: 5)
        }
        
        XCTAssertTrue(validator.validate(), "ValidatorBuilder should correctly build and validate a single validator.")
    }

    func testMultipleValidatorsBuilding() {
        let validator: Validate = Validate {
            RangeValidator(with: 1...10, for: 5)
            EmptyValidator()
        }
        
        XCTAssertTrue(validator.validate(), "ValidatorBuilder should correctly build and validate multiple validators.")
    }
    
    func testOptionalValidatorBuilding() {
        let optionalRangeValidator: RangeValidator<Int, ClosedRange<Int>> = RangeValidator(with: 1...10, for: 5)
        let validator: Validate = Validate {
            if true {
                optionalRangeValidator
            } else {
                RangeValidator(with: 1...10, for: 5)
            }
        }
        
        XCTAssertTrue(validator.validate(), "ValidatorBuilder should correctly handle optional validators.")
    }
    
    func testConditionalValidatorsBuilding() {
        let condition = true
        let validator: Validate = Validate {
            RangeValidator(with: 1...10, for: 5)
            EmptyValidator()
            if condition {
                RangeValidator(with: 1...10, for: 5)
            }
        }
        
        XCTAssertTrue(validator.validate(), "ValidatorBuilder should correctly handle conditional validators based on a condition.")
        
        let eitherValidator: Validate = Validate {
            if condition {
                RangeValidator(with: 1...10, for: 5)
            }
        }
        
        XCTAssertTrue(eitherValidator.validate(), "ValidatorBuilder should correctly handle conditional validators with ConditionValidator.")
    }

}
