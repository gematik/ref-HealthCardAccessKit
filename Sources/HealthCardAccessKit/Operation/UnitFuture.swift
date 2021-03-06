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

import Foundation

/// UnitFuture that holds a FutureEvent as FutureType
public class UnitFuture<T>: Future<T> {
    private let _event: FutureEvent<T>

    public convenience init(_ value: T) {
        self.init(event: .completed(value))
    }

    public required init(event: FutureEvent<T>) {
        self._event = event
        super.init()
        self.done = true
    }

    override public func on(event block: @escaping Consumer<FutureEvent<T>>) {
        block(_event)
    }

    override public func cancel(mayInterruptIfRunning: Bool = false) -> Bool {
        return false
    }
}
