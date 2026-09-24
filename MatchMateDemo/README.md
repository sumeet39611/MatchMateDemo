# MatchMateDemo

A small SwiftUI matrimonial-style app using Random User API, SwiftData, MVVM + Repository, async/await, pagination and offline persistence.

## Requirements covered

- SwiftUI profile list and profile detail
- Random User API with `page`, `results=10`, `seed=matchmate`
- Stable profile identity from `login.uuid`
- Real pagination when the last visible card appears
- Accept / Decline on list and detail
- Status persisted in SwiftData
- List and detail use the same persisted entity/source of truth
- Cached profiles available offline
- Accept / Decline continue to work offline
- URLSession + async/await
- Network/database error handling
- ViewModel/repository boundaries
- Unit tests for persistence and pagination

## Architecture

```text
SwiftUI Views
     |
     v
ViewModels/MatchStore  <---- shared observable state
     |
     v
ProfileRepository
     |              \
     v               v
 SwiftData        NetworkClient
     |               |
     v               v
 Local DB       Random User API
```

The UI observes the same `ProfileEntity` instances exposed by `MatchStore`. A status change writes to SwiftData and reloads the cached collection, so navigating from list to detail or back does not require a manual refresh.

## Why SwiftData?

SwiftData keeps the persistence layer concise for a SwiftUI application, provides a type-safe model, and integrates naturally with Apple's modern persistence APIs. The assignment allows either Core Data or SwiftData.

## Offline behavior

Previously fetched profiles are stored locally. The app loads the cache at startup. When the device is offline, pagination is skipped, but status changes are still written to the local database.

## Pagination

The repository starts at page 1 and requests 10 results with `seed=matchmate`. When the last visible profile appears, the store asks the repository for the next page. Existing profiles are matched by `login.uuid`.

## Status synchronization

`login.uuid` is the single stable identity. There is one persisted `status` for each profile. List and detail both update the same repository/database record.

## Testing

The test target verifies:
1. Status changes persist.
2. Pagination requests page 1 then page 2 and stores both pages.
