//
//  Copyright (c) 2019 gematik GmbH
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

import Foundation
@testable import HealthCardAccessKit
import Nimble
import XCTest

final class SelectCommandIntegrationTest: HCATerminalTestCase {

    func testSelectCommandIntegration() {

        expect {
            HealthCardCommand.Select.selectRoot()
                    .execute(on: HCATerminalTestCase.healthCard)
                    .run(on: Executor.trampoline)
                    .test().value?.responseStatus
        } == ResponseStatus.success

        expect {
            HealthCardCommand.Select.selectParent()
                    .execute(on: HCATerminalTestCase.healthCard)
                    .run(on: Executor.trampoline)
                    .test().value?.responseStatus
        } == ResponseStatus.fileNotFound
    }

    static let allTests = [
        ("testSelectCommandIntegration", testSelectCommandIntegration)
    ]
}
