# Yoga Cue Notes — Design to Dev Spec v2

## 0. Product Summary

**App Type:** Korean-only mobile app for yoga sequence and cue note management  
**Platform:** Flutter (iOS-first visual tone, but cross-platform capable)  
**Storage:** Local-first, offline-only for MVP  
**Backend/Auth:** None  
**Core Goal:** Let yoga instructors or practitioners create, organize, and share structured cue notes for each pose in a sequence.

### Core Principles
- Korean-only UI
- Minimal and premium wellness aesthetic
- Fast note entry
- Structured cue editor, not a generic memo app
- Share as plain text to KakaoTalk or other apps
- Local-first UX with smooth interactions and no blocking flows

---

## 1. Recommended Technical Stack

### App Architecture
- Feature-based Flutter project structure
- Local-first persistence
- Reusable UI components
- Screen-by-screen incremental implementation

### Recommended Packages
- **Local DB:** Isar
- **State Management:** Riverpod
- **Routing:** go_router or standard Navigator + CupertinoPageRoute
- **Sharing:** share_plus
- **Haptics:** Flutter built-in `HapticFeedback`
- **Animations:** Flutter built-in implicit animations first

### Routing Rule
- Use **CupertinoPageRoute-style forward navigation** for all push transitions
- Right-to-left push animation for forward routes
- Native swipe-back behavior where possible

---

## 2. Screen List & Navigation Flow

### App Flow
- **Splash / Init**
  - Checks local storage for theme selection and onboarding completion
  - Routes to `ThemeSelection` on first launch, otherwise `Home`

- **ThemeSelection**
  - First launch theme selection
  - Also accessible from Settings
  - On complete → `Home`

- **Main App Shell**
  - Bottom Navigation with 3 tabs:
    - `Home`
    - `Favorites`
    - `Settings`

### Navigation Map

#### Home
- Recent sequences
- Quick create
- Recent edited cue notes
- Actions:
  - → `SequenceList`
  - → `SequenceEditor`
  - → `SequenceDetail`

#### Favorites
- Favorite sequences list
- Tap item → `SequenceDetail`

#### Settings
- Theme selection
- Text size
- Default share format
- Export / backup
- Theme edit → `ThemeSelection`

#### SequenceList
- Shows all sequences
- Actions:
  - → `SequenceDetail`
  - → `SequenceEditor` (Create New)

#### SequenceDetail
- Sequence metadata
- List of steps
- Actions:
  - → `SequenceEditor` (Edit sequence metadata)
  - → `StepEditor` (Add/Edit one pose)
  - → `StepReorder`
  - → `SharePreview` (Bottom Sheet)
  - Favorite toggle

#### StepEditor
- Structured cue editor for a single sequence step
- Save / Delete / Cancel

#### StepReorder
- Reorder step list with drag-and-drop
- Save updated order

#### SharePreview
- Opened as bottom sheet from `SequenceDetail`
- Shows generated share text
- Allows editing before native share

---

## 3. Local Data Model Suggestions

### Recommended Local DB
**Isar**

**Reason:**
- Better fit for structured local-first data
- Good performance for nested models and sequence-step relationships
- Easier to scale than flat key-value storage

---

## 4. Data Models

### 4.1 Sequence

```text
Sequence
- id: Id
- title: String
- description: String?
- level: SequenceLevel
  - beginner
  - intermediate
  - advanced
- tags: List<String>
- isFavorite: bool
- createdAt: DateTime
- updatedAt: DateTime
```

#### Notes
- `title` is required
- `description` is optional
- `tags` are optional
- `isFavorite` default is false

---

### 4.2 SequenceStep

```text
SequenceStep
- id: Id
- sequenceId: Id
- orderIndex: int
- poseName: String
- sanskritName: String?
- sideType: SideType
  - none
  - left
  - right
  - both
- isBalancePose: bool
- breathCount: int
- preparationCue: String
- breathCues: List<BreathCueEntry>
- releaseCue: String
- cautionNote: String?
- beginnerModificationNote: String?
- createdAt: DateTime
- updatedAt: DateTime
```

#### Notes
- `poseName` is required
- `breathCount` is required for MVP
- `breathCues.length` must always match `breathCount`
- `preparationCue`, `releaseCue` can be empty, but structure must exist
- `sideType` is required
- `isBalancePose` default is false

---

### 4.3 BreathCueEntry

```text
BreathCueEntry
- breathIndex: int   // 1-based
- text: String
```

#### Rule
- Example:
  - `1호흡`
  - `2호흡`
  - `3호흡`
- Must be generated dynamically based on selected `breathCount`

---

### 4.4 UserSettings

```text
UserSettings
- selectedTheme: AppThemeType
  - sage
  - sand
- textSize: AppTextSize
  - small
  - medium
  - large
- defaultShareFormat: ShareFormatType
  - full
  - cues
  - short
- onboardingCompleted: bool
```

---

## 5. Core Screen Detail

### 5.1 Cue Note Editor (StepEditor)

#### Purpose
Edit one yoga pose / one sequence step using a **structured cue writing flow**.

#### Data Shown
- Pose name input
- Sanskrit name input (optional)
- Breath count selector
- Side selector
- Balance pose selector
- Preparation cue section
- Breath cue section
- Release cue section
- Caution note
- Beginner modification note
- Save button
- Delete button (edit mode only)

#### Required UI Fields
- `poseName`
- `breathCount`
- `sideType`
- `isBalancePose`
- `preparationCue`
- `breathCues[]`
- `releaseCue`

#### Optional UI Fields
- `sanskritName`
- `cautionNote`
- `beginnerModificationNote`

#### Detailed Interaction Rules

##### Breath Count
- User selects breath count from a clean segmented selector, stepper, or picker
- Allowed range: **1 to 10**
- When breath count changes:
  - If increased, append new empty breath cue fields
  - If decreased, remove extra fields only after confirmation if removed fields contain text

##### Side Selector
Options:
- 없음
- 왼쪽
- 오른쪽
- 양쪽

##### Balance Pose Selector
- Boolean toggle
- Label in Korean only
- If enabled, caution section may be visually emphasized

##### Cue Sections
The cue editor must always be visually divided into:

1. **준비동작 큐잉**
   - Multiline text area
   - Used for entering and setting up the pose

2. **호흡 큐잉**
   - Dynamically generated list based on selected breath count
   - Each row labeled:
     - `1호흡`
     - `2호흡`
     - `3호흡`
   - Each row has a separate editable text input

3. **동작 푸는 큐잉**
   - Multiline text area
   - Used for release / exit instructions

#### UX Rules
- Use `TextFormField`
- Multiline fields use `maxLines: null`
- Use scrollable parent with keyboard drag-dismiss behavior
- Keep layout distraction-free
- Large readable text areas
- Bottom fixed save button
- Autosave draft in local screen state to prevent accidental loss

#### Save Behavior
- Save validates required fields
- Save writes into local DB
- On successful save:
  - show subtle success feedback
  - pop back to previous screen
- If unsaved changes exist and user attempts to leave:
  - show confirmation sheet/dialog

#### Delete Behavior
- Available only in edit mode
- Requires confirmation before delete
- On delete:
  - remove step from DB
  - re-normalize `orderIndex` if needed
  - return to previous screen

---

### 5.2 Sequence Detail (SequenceDetail)

#### Purpose
Display one sequence and its ordered step list in a readable format.

#### Data Shown
- Sequence title
- Description
- Level
- Tags
- Favorite state
- Total step count
- Ordered list of steps
- Step preview cards

#### User Actions
- Edit sequence metadata
- Toggle favorite
- Add step
- Edit step
- Reorder steps
- Open share preview
- Enter read/play mode later if added

#### Implementation Focus
- Use `CustomScrollView`
- Use `SliverAppBar` to collapse metadata
- Show `StepCard` preview with:
  - pose name
  - side tag if applicable
  - truncated cue preview
- Add `동작 추가` action as FAB or persistent bottom CTA

#### StepCard Preview Rules
- Pose name required
- Notes preview:
  - max 3 lines
  - `TextOverflow.ellipsis`
- Show balance badge if `isBalancePose == true`

---

### 5.3 Share Preview (Bottom Sheet)

#### Purpose
Preview and edit generated plain-text share content before sending to KakaoTalk or other apps.

#### Data Shown
- Share format selector
- Generated text preview
- Copy button
- Share button

#### User Actions
- Switch format
- Edit generated text manually
- Copy
- Native share

#### Implementation Focus
- Use `showModalBottomSheet(isScrollControlled: true)`
- Use `TextEditingController` for editable preview
- On confirm:
  - pass final text to `Share.share(text)`

#### UX Rules
- Bottom sheet supports swipe-down dismiss
- No image sharing
- Text only
- Sharing should feel fast and lightweight

---

## 6. Share Format Rules

### 6.1 Full Format
Include:
- Sequence title
- Sequence description if available
- For each step:
  - pose name
  - side if applicable
  - breath count
  - preparation cue
  - breath cues
  - release cue
  - caution note if not empty
  - beginner modification note if not empty

### 6.2 Cues Format
Include:
- Sequence title
- For each step:
  - pose name
  - preparation cue
  - breath cues
  - release cue

### 6.3 Short Format
Include:
- Sequence title
- For each step:
  - pose name
  - one or two key cue lines only
  - optionally one short caution if important

### Shared Formatting Rules
- Empty sections are omitted
- If `sideType == both`, show:
  - `좌/우 반복`
  - or equivalent concise Korean wording
- If `isBalancePose == true`, optional prefix:
  - `[균형]`
- Use clean line breaks for readability
- Final text must remain editable before share

---

## 7. Input Validation Rules

### Sequence

#### Title
- Required
- Max 30 characters
- Save disabled if empty

#### Description
- Optional
- Max 300 characters

---

### SequenceStep

#### Pose Name
- Required
- Max 20 characters

#### Sanskrit Name
- Optional
- Max 40 characters

#### Breath Count
- Required
- Integer between 1 and 10

#### Preparation Cue
- Optional
- Max 500 characters

#### Each Breath Cue
- Optional
- Max 300 characters

#### Release Cue
- Optional
- Max 500 characters

#### Caution Note
- Optional
- Max 300 characters

#### Beginner Modification Note
- Optional
- Max 300 characters

#### Validation Behavior
- Use `Form` + `GlobalKey<FormState>`
- Validate live after first failed submission
- Character counter shown only when field exceeds 80% of limit

---

## 8. Empty, Loading, and Error States

### 8.1 Empty States
Use the dashed-border **GhostActionCard** component.

#### Sequence List
`아직 작성된 시퀀스가 없습니다. 새로운 시퀀스를 만들어보세요.`

#### Sequence Detail
`아직 추가된 동작이 없습니다. 동작 추가하기`

#### Favorites
`즐겨찾기한 시퀀스가 없습니다.`

---

### 8.2 Loading States
- No full blocking spinner
- Use subtle shimmer or skeleton cards only when helpful
- Local DB loading is expected to be very fast

---

### 8.3 Error States
- Use SnackBar
- Keep copy short and clear

Examples:
- `저장에 실패했습니다. 다시 시도해주세요.`
- `삭제에 실패했습니다. 다시 시도해주세요.`
- `공유할 내용이 없습니다.`

#### Error Color
- Use semantic error color:
  - `#E89D91`
- Text should remain readable on top

---

## 9. Theme Tokens (Flutter ThemeData)

### 9.1 Theme A — Sage

```text
primary: #8FA88E
scaffoldBackgroundColor: #F5F7F5
cardColor: #FFFFFF
textPrimary: #2C3E2E
textSecondary: #6B7A6D
error: #E89D91
success: #86A89B
```

### 9.2 Theme B — Sand

```text
primary: #C9B5A0
scaffoldBackgroundColor: #F7F5F2
cardColor: #FFFFFF
textPrimary: #3E3632
textSecondary: #7A716B
error: #E89D91
success: #86A89B
```

---

## 10. Typography (TextTheme)

```text
Display
- fontSize: 28
- fontWeight: w700
- letterSpacing: -0.5

Title
- fontSize: 20
- fontWeight: w600
- letterSpacing: -0.3

Subtitle
- fontSize: 16
- fontWeight: w500

Body
- fontSize: 15
- fontWeight: w400
- height: 1.6
```

### Typography Direction
- Prioritize Korean readability
- Generous line-height for notes
- Calm editorial feeling
- Avoid overly playful visual treatment

---

## 11. Spacing / Radius / Visual Rules

### Spacing Scale
- 4
- 8
- 12
- 16
- 20
- 24
- 32

### Recommended Usage
- Screen horizontal padding: 20
- Card padding: 16
- Section gap: 24
- Small element gap: 8 or 12

### Radius Scale
- Input fields: 14
- Buttons: 16
- Cards: 20
- Bottom sheet top radius: 24

### Shadows
- Very subtle only
- Prefer clean surfaces over heavy elevation

---

## 12. Component List (Custom Widgets)

### Buttons
- `PrimaryButton` — solid main CTA
- `BrandButton` — theme-colored emphasis CTA
- `SecondaryButton` — outline / soft fill
- `GhostButton` — text only

### Cards
- `SequenceCard`
- `StepCard`
- `GhostActionCard`

### Inputs
- `MinimalTextField`
- `MultilineCueField`
- `SearchField`
- `BreathCountSelector`
- `SideTypeSelector`
- `BalanceToggle`

### Navigation
- `CustomBottomNavBar`

### Chips / Tags
- `FilterChipWidget`
- `ShareFormatChip`

### Bottom Sheet
- `SharePreviewSheet`

---

## 13. Interaction Rules

### Haptics
Use `HapticFeedback.lightImpact()` on:
- Save
- Delete
- Theme selection
- Reorder pick-up
- Reorder drop
- Share sheet open

### Button Press Behavior
- Scale down to `0.98` on tap-down
- Prefer no heavy Material ripple
- Maintain iOS-like premium touch feel

### List Animations
- Fade / subtle slide on first render
- Keep motion short and understated

### Gesture Rules
- Edge swipe right to pop route
- Swipe down to dismiss bottom sheet
- Drag-and-drop for step reorder

---

## 14. Draft / Autosave Behavior

### StepEditor Draft
- Keep unsaved edits in local screen state
- If user accidentally back-swipes:
  - detect dirty state
  - prompt before discard

### Dirty State
A screen is considered dirty if any field differs from the loaded step snapshot.

### Discard Confirmation Copy
- `저장하지 않은 변경사항이 있습니다. 나가시겠어요?`

---

## 15. MVP Scope

### Include in MVP
- Theme selection
- Bottom navigation
- Sequence list
- Sequence detail
- Step editor
- Step reorder
- Favorites
- Local persistence
- Share preview
- Native text sharing
- Copy to clipboard

### Exclude from MVP
- Cloud sync
- User account
- Collaboration
- Audio guidance
- Calendar/session planner
- Image-based sharing

---

## 16. OpenCode Implementation Order

### Phase 1 — Foundation
1. App theme structure
2. Routing shell
3. Shared components
4. Data models
5. Local DB scaffold

### Phase 2 — Core UI
6. Sequence list
7. Sequence detail
8. Step editor
9. Step reorder

### Phase 3 — Sharing
10. Share preview sheet
11. Text generation logic
12. Native share integration

### Phase 4 — Polish
13. Favorites
14. Empty/error states
15. Haptics and subtle motion
16. Settings screen

---

## 17. Notes for Implementation

- This is **not** a generic note app
- The key differentiator is the **structured cue flow per pose**
- Step data must remain structured for:
  - editing
  - display
  - sharing
  - future expansion
- Do not collapse all cue sections into one plain text field
