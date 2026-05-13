# 📊 History System - Visual Guide & Data Flow

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     ENJOY APP HISTORY SYSTEM                 │
│                   (JSON-Based Storage)                       │
└─────────────────────────────────────────────────────────────┘

┌────────────────────────────────┐
│  SessionModel (Dart Object)    │
├────────────────────────────────┤
│ • start: int                   │
│ • type: String                 │
│ • duration: int                │
│ • index: int                   │
│ • price: double                │
│ • name: String                 │
│ • orders: List<OrderModel>     │
│ • notes: String? (optional)    │
└────────────────────────────────┘
          │
          │ toJson()
          ▼
┌────────────────────────────────┐
│  JSON Map (Dictionary)         │
├────────────────────────────────┤
│ {                              │
│   "start": 1234567890,         │
│   "type": "playstation",       │
│   "orders": [...]              │
│ }                              │
└────────────────────────────────┘
          │
          │ jsonEncode()
          ▼
┌────────────────────────────────┐
│  JSON String                   │
├────────────────────────────────┤
│ '[{"start": 1234567890, ...}]' │
└────────────────────────────────┘
          │
          │ SharedPreferences
          ▼
┌────────────────────────────────┐
│  Device Storage                │
├────────────────────────────────┤
│ Key: "history_json"            │
│ Value: JSON array string       │
└────────────────────────────────┘
```

---

## Complete Data Flow Example

### 1️⃣ CREATE SESSION

```
User plays PlayStation for 1 hour
    ↓
Session ends → Create SessionModel
    ↓
SessionModel(
  start: 1715423456789,
  type: "playstation",
  duration: 3600000,
  index: 1,
  price: 5.0,
  name: "PS-01",
  orders: [
    OrderModel(name: "Pepsi", price: 2.5),
    OrderModel(name: "Snacks", price: 1.5)
  ]
)
```

### 2️⃣ CONVERT TO JSON

```
SessionModel.toJson()
    ↓
{
  "start": 1715423456789,
  "type": "playstation",
  "duration": 3600000,
  "index": 1,
  "price": 5.0,
  "name": "PS-01",
  "orders": [
    {
      "name": "Pepsi",
      "price": 2.5,
      "note": null
    },
    {
      "name": "Snacks",
      "price": 1.5,
      "note": null
    }
  ],
  "notes": null
}
```

### 3️⃣ ENCODE & SAVE

```
jsonEncode(jsonMap)
    ↓
'[{"start":1715423456789,"type":"playstation",...}]'
    ↓
SharedPreferences.setString("history_json", jsonString)
    ↓
Stored in device storage
```

### 4️⃣ LOAD FROM STORAGE

```
SharedPreferences.getString("history_json")
    ↓
'[{"start":1715423456789,...}]'
    ↓
jsonDecode(jsonString)
    ↓
List<Map<String, dynamic>>
```

### 5️⃣ CONVERT BACK TO OBJECTS

```
List<Map> → SessionModel.fromJson(map)
    ↓
SessionModel(
  start: 1715423456789,
  type: "playstation",
  duration: 3600000,
  index: 1,
  price: 5.0,
  name: "PS-01",
  orders: [OrderModel(...), OrderModel(...)],
  notes: null
)
    ↓
Display in history screen ✓
```

---

## File Dependencies

```
main.dart
  ├── imports SharedPrefService
  └── calls migrateOldHistory()
        ↓
SharedPrefService
  ├── imports SessionModel
  ├── imports OrderModel
  └── uses jsonEncode/jsonDecode
        ↓
SessionModel
  ├── imports OrderModel
  └── implements toJson/fromJson
        ↓
OrderModel
  └── implements toJson/fromJson
```

---

## Method Call Chain Example

```
User Action: End Session
    ↓
Call: await SharedPrefService.saveToHistory(session)
    ↓
SessionModel.toJson() → Map
    ↓
jsonEncode(map) → String
    ↓
SharedPreferences.setString("history_json", jsonString)
    ↓
Data saved to device ✓
```

---

## Data Retrieval Chain

```
User Action: Open History
    ↓
Call: List<SessionModel> history = SharedPrefService.getHistory()
    ↓
SharedPreferences.getString("history_json") → jsonString
    ↓
jsonDecode(jsonString) → List<Map>
    ↓
For each map: SessionModel.fromJson(map)
    ↓
Returns: List<SessionModel> ✓
    ↓
Display in UI
```

---

## Error Handling Flow

```
Load History
    ↓
Try to decode JSON
    ├─ Success → Process each entry
    │           ├─ Valid? → Add to list
    │           └─ Invalid? → Log warning & skip
    │
    └─ Fail? → Log error & return []
    ↓
Return: List<SessionModel> (may be partial or empty)
    ↓
Display safely ✓
```

---

## Orders in Session

```
SessionModel
  └─ orders: List<OrderModel>
       ├─ OrderModel 1 (Pepsi)
       ├─ OrderModel 2 (Snacks)
       └─ OrderModel 3 (Juice)

getTotalPrice() = 
  basePrice (5.0)
  + Pepsi (2.5)
  + Snacks (1.5)
  + Juice (3.0)
  = 12.0 ✓
```

---

## Migration Flow (Old → New)

```
App Startup
    ↓
Check: Old format exists? (key="history")
    ├─ No → Done, skip migration
    │
    └─ Yes → Check if already migrated?
             ├─ Yes → Done, skip
             │
             └─ No → Migrate
                   ├─ Parse old string format
                   ├─ Convert to SessionModels
                   ├─ Save as JSON
                   └─ Migration complete ✓
```

---

## Comparison: Old vs New

```
OLD SYSTEM:
String → split(",") → List<String> → Manual parsing
Risk: Crashes on special chars, complex logic

NEW SYSTEM:
JSON String → jsonDecode() → SessionModel.fromJson()
Benefit: Safe, structured, scalable
```

---

## User Interface Integration Points

```
Home Screen
  ├─ Session starts
  └─ Save in-progress: saveSession()

Session Running
  └─ Add orders: Add to orders list

Session Ends
  ├─ Show summary
  └─ Save to history: saveToHistory()

History Screen
  ├─ Load: getHistory()
  ├─ Display sessions
  └─ Show calculations

Settings Screen
  └─ Clear: clearHistory()
```

---

## Sequence Diagram

```
Timeline:
─────────────────────────────────

T0: App Startup
    ├─ SharedPrefService.init()
    └─ migrateOldHistory()

T1: User starts session
    └─ saveSession("current_session", ...)

T2: User adds order
    └─ Add to orders list

T3: User ends session
    ├─ Create SessionModel
    └─ saveToHistory(session)
          └─ jsonEncode & save

T4: User opens history
    └─ getHistory()
          ├─ getString("history_json")
          ├─ jsonDecode()
          └─ Return SessionModels

T5: User clears history
    └─ clearHistory()
```

---

## JSON Structure Tree

```
history_json (SharedPreferences Key)
  │
  └─ Array of Sessions [...]
      │
      ├─ Session 0
      │   ├─ start: 1715423456789
      │   ├─ type: "playstation"
      │   ├─ duration: 3600000
      │   ├─ index: 1
      │   ├─ price: 5.0
      │   ├─ name: "PS-01"
      │   ├─ orders: [...]
      │   │   ├─ Order 0
      │   │   │   ├─ name: "Pepsi"
      │   │   │   ├─ price: 2.5
      │   │   │   └─ note: "Large"
      │   │   └─ Order 1
      │   │       ├─ name: "Snacks"
      │   │       ├─ price: 1.5
      │   │       └─ note: null
      │   └─ notes: null
      │
      └─ Session 1
          ├─ start: 1715423556789
          ├─ type: "ping"
          ├─ duration: 1800000
          ├─ ...
```

---

## Memory Usage

```
OLD: String parsing required multiple splits/joins
     Memory spikes during parsing

NEW: Direct JSON deserialization  
     More efficient memory usage
     Automatic cleanup by Dart GC
```

---

## Benefits Summary

```
✅ Clear structure      (Not string soup)
✅ Easy to debug        (Human-readable JSON)
✅ Error handling       (Won't crash)
✅ Scalable             (Add fields easily)
✅ Future-proof         (Standard format)
✅ Type-safe            (Dart objects)
✅ Fast                 (Built-in JSON support)
```

---

## Testing Checklist with This Diagram

- [ ] Understand data flow (top to bottom)
- [ ] Verify models have toJson/fromJson
- [ ] Test save path (Create → toJson → encode → save)
- [ ] Test load path (load → decode → fromJson → display)
- [ ] Test error path (corrupt → skip → continue)
- [ ] Test migration (old format → new format)
- [ ] Verify calculations (getTotalPrice works)
- [ ] Check orders nested properly
- [ ] Confirm notes optional field works

