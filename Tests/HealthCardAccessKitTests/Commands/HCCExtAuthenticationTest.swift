//
//  Copyright (c) 2020 gematik GmbH
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

import ASN1Kit
import Foundation
@testable import HealthCardAccessKit
import Nimble
import XCTest

class HCCExtAuthenticationTest: XCTestCase {
    //swiftlint:disable:previous type_body_length
    func testExternalAuthenticateWithoutResponse() {
        let cmdData = Data(repeating: 0x7f, count: 104)
        let expected = Data([0x0, 0x82, 0x0, 0x0, 0x68] + cmdData)
        let responseCodes: [UInt16] = [0x9000, 0x6300, 0x6982, 0x6983, 0x6985, 0x6a81, 0x6a88]

        let command = try? HealthCardCommand.Authentication
                .externalMutualAuthentication(cmdData)
        expect {
            command?.bytes
        } == expected

        expect {
            command?.responseStatuses.keys
        }.to(contain(responseCodes))
    }

    func testExternalAuthenticateWithResponse() {
        let cmdData = Data(repeating: 0x7f, count: 104)
        let expected = Data([0x0, 0x82, 0x0, 0x0, 0x68] + cmdData + [0x0])
        let responseCodes: [UInt16] = [0x9000, 0x6300, 0x6982, 0x6983, 0x6985, 0x6a81, 0x6a88]

        let command = try? HealthCardCommand.Authentication
                .externalMutualAuthentication(cmdData, expectResponse: true)
        expect {
            command?.bytes
        } == expected

        expect {
            command?.responseStatuses.keys
        }.to(contain(responseCodes))
    }

    func testInternalAuthentication() {
        let token = Data(repeating: 0x7f, count: 32)
        let expected = Data([0x0, 0x88, 0x0, 0x0, 0x20] + token + [0x0])
        let responseCodes: [UInt16] = [0x9000, 0x6400, 0x6982, 0x6985, 0x6a80, 0x6a81, 0x6a88]

        let command = try? HealthCardCommand.Authentication.internalAuthenticate(token)
        expect {
            command?.bytes
        } == expected

        expect {
            command?.responseStatuses.keys
        }.to(contain(responseCodes))
    }

    func testPaceStep1a() {
        let expected = Data([0x10, 0x86, 0x0, 0x0, 0x2, 0x7c, 0x0, 0x0])
        let responseCodes: [UInt16] = [0x9000]

        let command = HealthCardCommand.PACE.step1a()
        expect {
            command.bytes
        } == expected

        expect {
            command.responseStatuses.keys
        }.to(contain(responseCodes))
    }

    func testPaceStep2a() {
        let publicKey = Data(repeating: 0xef, count: 33)
        let expected = Data([0x10, 0x86, 0x0, 0x0, 0x25, 0x7c, 0x23, 0x81, 0x21] + publicKey + [0x0])
        let responseCodes: [UInt16] = [0x9000]

        let command = try? HealthCardCommand.PACE.step2a(publicKey: publicKey)
        expect {
            command?.bytes
        } == expected

        expect {
            command?.responseStatuses.keys
        }.to(contain(responseCodes))
    }

    func testPaceStep3a() {
        let publicKey = Data(repeating: 0xef, count: 33)
        let expected = Data([0x10, 0x86, 0x0, 0x0, 0x25, 0x7c, 0x23, 0x83, 0x21] + publicKey + [0x0])
        let responseCodes: [UInt16] = [0x9000]

        let command = try? HealthCardCommand.PACE.step3a(publicKey: publicKey)
        expect {
            command?.bytes
        } == expected

        expect {
            command?.responseStatuses.keys
        }.to(contain(responseCodes))
    }

    func testPaceStep4a() {
        let token = Data(repeating: 0xef, count: 8)
        let expected = Data([0x00, 0x86, 0x0, 0x0, 0xc, 0x7c, 0xa, 0x85, 0x8] + token + [0x0])
        let responseCodes: [UInt16] = [0x9000]

        let command = try? HealthCardCommand.PACE.step4a(token: token)
        expect {
            command?.bytes
        } == expected

        expect {
            command?.responseStatuses.keys
        }.to(contain(responseCodes))

        expect {
            try HealthCardCommand.PACE.step4a(token: Data(repeating: 0x3d, count: 3))
        }.to(throwError(HealthCardCommandBuilder.InvalidArgument.illegalSize(3, expected: 8)))
    }

    func testPaceStep1b() {
        let expected = Data([0x10, 0x86, 0x0, 0x0, 0x2, 0x7c, 0x0, 0x0])
        let responseCodes: [UInt16] = [0x9000]

        let command = HealthCardCommand.PACE.step1b()
        expect {
            command.bytes
        } == expected

        expect {
            command.responseStatuses.keys
        }.to(contain(responseCodes))
    }

    func testPaceStep2b() {
        let z = Data(repeating: 0x1, count: 0x10) //swiftlint:disable:this identifier_name
        let can = try! CAN.from(Data([0x1, 0x23])) //swiftlint:disable:this force_try
        let expected = Data([0x10, 0x86, 0x0, 0x0, 0x18, 0x7c, 0x16, 0x80, 0x10] + z + [0xc0, 0x2] + can.rawValue)
        let responseCodes: [UInt16] = [0x9000]

        let command = try? HealthCardCommand.PACE.step2b(z: z, can: can)
        expect {
            command?.bytes
        } == expected

        expect {
            command?.responseStatuses.keys
        }.to(contain(responseCodes))

        expect {
            try HealthCardCommand.PACE.step2b(z: Data(), can: can)
        }.to(throwError(HealthCardCommandBuilder.InvalidArgument.illegalSize(0, expected: 0x10)))
    }

    func testPaceStep3b() {
        let publicKey = Data(repeating: 0xef, count: 33)
        let expected = Data([0x10, 0x86, 0x0, 0x0, 0x25, 0x7c, 0x23, 0x82, 0x21] + publicKey + [0x0])
        let responseCodes: [UInt16] = [0x9000]

        let command = try? HealthCardCommand.PACE.step3b(publicKey: publicKey)
        expect {
            command?.bytes
        } == expected

        expect {
            command?.responseStatuses.keys
        }.to(contain(responseCodes))
    }

    func testPaceStep4b() {
        let publicKey = Data(repeating: 0xef, count: 33)
        let expected = Data([0x10, 0x86, 0x0, 0x0, 0x25, 0x7c, 0x23, 0x84, 0x21] + publicKey + [0x0])
        let responseCodes: [UInt16] = [0x9000]

        let command = try? HealthCardCommand.PACE.step4b(publicKey: publicKey)
        expect {
            command?.bytes
        } == expected

        expect {
            command?.responseStatuses.keys
        }.to(contain(responseCodes))
    }

    func testPaceStep5b() {
        let token = Data(repeating: 0xef, count: 8)
        let expected = Data([0x00, 0x86, 0x0, 0x0, 0xc, 0x7c, 0xa, 0x86, 0x8] + token + [0x0])
        let responseCodes: [UInt16] = [0x9000]

        let command = try? HealthCardCommand.PACE.step5b(token: token)
        expect {
            command?.bytes
        } == expected

        expect {
            command?.responseStatuses.keys
        }.to(contain(responseCodes))

        expect {
            try HealthCardCommand.PACE.step5b(token: Data(repeating: 0x3d, count: 3))
        }.to(throwError(HealthCardCommandBuilder.InvalidArgument.illegalSize(3, expected: 8)))
    }

    func testELCstep1() {
        let keyRef = Data(repeating: 0x7b, count: 12)
        let expected = Data([0x10, 0x86, 0x0, 0x0, 0x10, 0x7c, 0xe, 0xc3, 0xc] + keyRef + [0x0])
        let responseCodes: [UInt16] = [0x9000]

        let command = try? HealthCardCommand.ELC.step1a(keyRef: keyRef)
        expect {
            command?.bytes
        } == expected

        expect {
            command?.responseStatuses.keys
        }.to(contain(responseCodes))

        expect {
            try HealthCardCommand.ELC.step1a(keyRef: Data([0x0]))
        }.to(throwError(HealthCardCommandBuilder.InvalidArgument.illegalSize(1, expected: 12)))
    }

    func testELCstep2() {
        let ePK = Data(repeating: 0x7b, count: 8)
        let expected = Data([0x10, 0x86, 0x0, 0x0, 0xc, 0x7c, 0xa, 0x85, 0x8] + ePK)
        let responseCodes: [UInt16] = [0x9000]

        let command = try? HealthCardCommand.ELC.step2a(ephemeralPK: ePK)
        expect {
            command?.bytes
        } == expected

        expect {
            command?.responseStatuses.keys
        }.to(contain(responseCodes))
    }

    func testELCstep1b() {
        let expected = Data([0x10, 0x86, 0x0, 0x0, 0x4, 0x7c, 0x2, 0x81, 0x0, 0x0])
        let responseCodes: [UInt16] = [0x9000]

        let command = HealthCardCommand.ELC.step1b()
        expect {
            command.bytes
        } == expected

        expect {
            command.responseStatuses.keys
        }.to(contain(responseCodes))
    }

    func testELCstep2b() {
        let data = Data(repeating: 0x56, count: 76)
        let expected = Data([0x0, 0x86, 0x0, 0x0, 0x50, 0x7c, 0x4e, 0x82, 0x4c] + data)
        let responseCodes: [UInt16] = [0x9000]

        let command = try? HealthCardCommand.ELC.step2b(cmd: data)
        expect {
            command?.bytes
        } == expected

        expect {
            command?.responseStatuses.keys
        }.to(contain(responseCodes))

        expect {
            try HealthCardCommand.ELC.step2b(cmd: Data([0x0]))
        }.to(throwError(HealthCardCommandBuilder.InvalidArgument.illegalSize(1, expected: 76)))
    }

    func testReadStatusForSymKey() {
        let key = try! Key(0x8) //swiftlint:disable:this force_try
        let expected = Data([0x80, 0x82, 0x80, 0x0, 0x3, 0x83, 0x1, 0x88])
        let responseCodes: [UInt16] = [0x9000, 0x63cf, 0x6982, 0x6a88]

        let command = try? HealthCardCommand.SecurityStatus.readStatusFor(symmetricKey: key, dfSpecific: true)
        expect {
            command?.bytes
        } == expected

        expect {
            command?.responseStatuses.keys
        }.to(contain(responseCodes))
    }

    func testReadStatusForAsymKey() {
        let cha = Data([0x7f, 0x6f, 0x5f, 0x4f, 0x3f, 0x2f, 0x1f])
        let expected = Data([0x80, 0x82, 0x80, 0x0, 0xa, 0x5f, 0x4c, 0x7] + cha)
        let responseCodes: [UInt16] = [0x9000, 0x63cf, 0x6982, 0x6a88]

        let command = try? HealthCardCommand.SecurityStatus.readStatusFor(rsaCvc: cha)
        expect {
            command?.bytes
        } == expected

        expect {
            command?.responseStatuses.keys
        }.to(contain(responseCodes))

        expect {
            try HealthCardCommand.SecurityStatus.readStatusFor(rsaCvc: Data([0x0]))
        }.to(throwError(HealthCardCommandBuilder.InvalidArgument.illegalSize(1, expected: 7)))
    }

    func testReadStatusForOID() {
        let bitList = Data([0x7f, 0x6f, 0x5f, 0x4f, 0x3f, 0x2f, 0x1f])
        let oid = try! ObjectIdentifier.from(string: "{1.2.276.0.76.4.153}") //swiftlint:disable:this force_try
        let expected = Data([0x80, 0x82, 0x80, 0x0, 0x16, 0x7f, 0x4c, 0x13, 0x6, 0x8] +
                [0x2A, 0x82, 0x14, 0x00, 0x4C, 0x04, 0x81, 0x19] + [0x53, 0x7] + bitList)
        let responseCodes: [UInt16] = [0x9000, 0x63cf, 0x6982, 0x6a88]

        let command = try? HealthCardCommand.SecurityStatus.readStatusFor(bitList: bitList, oid: oid)
        expect {
            command?.bytes
        } == expected

        expect {
            command?.responseStatuses.keys
        }.to(contain(responseCodes))

        expect {
            try HealthCardCommand.SecurityStatus.readStatusFor(bitList: Data([0x0]), oid: oid)
        }.to(throwError(HealthCardCommandBuilder.InvalidArgument.illegalSize(1, expected: 7)))

        let invalidOid = try! ObjectIdentifier.from(string: "{1.2.276.0}") //swiftlint:disable:this force_try
        expect {
            try HealthCardCommand.SecurityStatus.readStatusFor(
                            bitList: bitList,
                            oid: invalidOid
                    )
        }.to(throwError(HealthCardCommandBuilder.InvalidArgument.illegalOid(invalidOid)))
    }

    static let allTests = [
        ("testExternalAuthenticateWithoutResponse", testExternalAuthenticateWithoutResponse),
        ("testExternalAuthenticateWithResponse", testExternalAuthenticateWithResponse),
        ("testInternalAuthentication", testInternalAuthentication),
        ("testPaceStep1a", testPaceStep1a),
        ("testPaceStep2a", testPaceStep2a),
        ("testPaceStep3a", testPaceStep3a),
        ("testPaceStep4a", testPaceStep4a),
        ("testPaceStep4a", testPaceStep1b),
        ("testPaceStep4a", testPaceStep2b),
        ("testPaceStep4a", testPaceStep3b),
        ("testPaceStep4a", testPaceStep4b),
        ("testPaceStep4a", testPaceStep5b),
        ("testELCstep1", testELCstep1),
        ("testELCstep2", testELCstep2),
        ("testReadStatusForSymKey", testReadStatusForSymKey),
        ("testReadStatusForAsymKey", testReadStatusForAsymKey),
        ("testReadStatusForOID", testReadStatusForOID)
    ]
}
