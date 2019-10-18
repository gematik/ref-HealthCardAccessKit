//
//  Copyright (c) 2019 gematik - Gesellschaft für Telematikanwendungen der Gesundheitskarte mbH
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//     http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import XCTest

#if !os(macOS) && !os(iOS)
/// Runs all tests in HealthCardAccessKit
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ApplicationIdentifierTest.allTests),
        testCase(FileControlParameterTest.allTests),
        testCase(FileIdentifierTest.allTests),
        testCase(Format2PinTest.allTests),
        testCase(KeyTest.allTests),
        testCase(ShortFileIdentifierTest.allTests),
        testCase(PasswordTest.allTests),
        testCase(HealthCardCommandBuilderTest.allTests),
        testCase(HCCExtAccessStructuredDataTest.allTests),
        testCase(HCCBuilderExtAccessTransparentDataTest.allTests),
        testCase(HCCExtObjectSystemManagementTest.allTests),
        testCase(HCCExtPerformSecurityOperationTest.allTests),
        testCase(ExecutableTest.allTests),
        testCase(FutureEventTest.allTests),
        testCase(FutureTypeTest.allTests),
        testCase(UnitFutureTest.allTests),
        testCase(ExecutorTest.allTests),
        testCase(ECCurveInfoTest.allTests),
        testCase(HCCExtUserVerificationTest.allTests),
        testCase(HCCExtMiscTest.allTests),
        testCase(HCCExtAuthenticationTest.allTests),
        testCase(HCCExtManageSETest.allTests),
        testCase(CardGenerationTest.allTests),
        testCase(CANTest.allTests),
        testCase(HealthCardPropertyTypeTest.allTests),
        testCase(SelectCommandIntegrationTest.allTests)
    ]
}
#endif
