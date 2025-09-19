# ToDoList
> `SwiftUI`를 독학한 뒤 처음으로 만든 앱입니다. `UIKit`으로 구현했던 할 일 관리 앱을 다시 구현한 프로젝트입니다.
## 목차
- [주요 구현사항](#주요-구현사항)
- [트러블슈팅](#트러블슈팅)
## 기술 스택
- `SwiftUI`
- `MVI` Architecture
- `FileManager`로 데이터 저장
- `Combine`
## 프로젝트 구조
```
📦 ToDoList_SwiftUI
├── 📂 App
│   ├── ToDoList_SwiftUIApp.swift
│   └── RootView.swift
├── 📂 Configuration
│   └── Assets.xcassets
├── 📂 Model
│   ├── Category.swift
│   ├── Task.swift
│   ├── DataManager.swift
│   └── TodoRepository.swift
├── 📂 Scene
│   ├── 📂 Main
│   │   ├─ MainView.swift
│   │   ├─ MainIntent.swift
│   │   ├─ MainState.swift
│   │   └─ MainStore.swift
│   ├── 📂 AddCategory
│   │   ├─ AddCategoryView.swift
│   │   ├─ AddCategoryIntent.swift
│   │   └─ AddCategoryStore.swift
│   ├── 📂 TaskList
│   │   ├─ TaskListView.swift
│   │   ├─ TaskListIntent.swift
│   │   ├─ TaskListState.swift
│   │   └─ TaskListStore.swift
│   ├── 📂 TaskEdit
│   │   ├─ TaskEditView.swift
│   │   ├─ TaskEditIntent.swift
│   │   ├─ TaskEditState.swift
│   │   └─ TaskEditStore.swift
```
## 주요 구현사항
### 📌 예약어 고려한 Model 네이밍
`UIKit`에서는 할 일 model인 `Task`의 그룹을 `List`로 관리했지만 `SwiftUI`에는 `List`, `Group`이 UI 컴포넌트로 존재하여 겹치지 않는 이름인 `Category`로 지었습니다.
```swift
struct Category: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var tasks: [Task]
    
    mutating func rename(to name: String) {
        self.name = name
    }
    
    static let defaultImportantCategory: Category = Category(name: "Important", tasks: [])
}
```
### 📌 의존성 주입 패턴
- `TodoRepository`는 `Todo` 데이터 CRUD를 담당하는 객체로, 모든 화면에서 필요합니다. 데이터 일관성 보장을 위해 앱 main에서 최초 생성된 객체를 화면 이동 시 주입합니다.
- 각 `View`에서는 외부에서 주입 받은 `repository`를 `Store`에 전달하기 위해 `init`에서 `wrappedValue`로 `StateObject`를 생성하였습니다.
```swift
struct MainView: View {
    @StateObject private var store: MainStore
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
        _store = StateObject(wrappedValue: MainStore(repository: repository))
    }

    // ... //
}
```
> `@StateObject` : store 내부 `@Published` 프로퍼티 변경 시 `View` 자동 업데이트
> <br>`StateObject(wrappedValue: )`라는 Property Wrapper 컨테이너 자체에 접근하기 위해 언더스코어(`_store`) 사용
### 📌 MVI 아키텍처 준수
`MVI` 아키텍처는 `MVVM`에서 좀더 세밀하게 책임 분리가 된 패턴입니다. `View` ↔ `ViewModel` 양방향 데이터 흐름을 따르는 `MVVM`과 User Action → Intent → Store → New State → View Updates 단방향이라는 특징이 있습니다.
> [MVI 아키텍처에 대해 정리한 포스트](https://velog.io/@emilyj4482/iOS-MVI-Architecture-1n9s8lks)
- Intent : User Event가 의도하는 액션 정의
```swift
enum TaskListIntent {
    case toggleTaskDone(task: Task)
    case toggleTaskImportant(task: Task)
    case deleteTask(task: Task)
    // ... //
}
```
- State : 앱의 현재 상태. UI를 표현할 순수 데이터 포함
```swift
struct TaskListState {
    // ... //

    var category: Category
    
    var doneTasks: [Task] {
        return category.tasks.filter({ $0.isDone })
    }
    
    var undoneTasks: [Task] {
        return category.tasks.filter({ !$0.isDone })
    }
    
    var error: DataError?
    
    var hasError: Bool {
        error != nil
    }
}
```
- Store : `View`로부터 `Intent`를 받아 액션을 처리하고, 그에 따른 상태(`State`) 변경을 관리
```swift
final class TaskListStore: ObservableObject {
    @Published private(set) var state: TaskListState
    private let repository: TodoRepository

    private func bind(with category: Category) {
        Publishers.CombineLatest(
            repository.$categories.compactMap { categories in
                categories.first { $0.id == category.id }
            },
            repository.$error
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] updatedCategory, error in
            self?.state = TaskListState(category: updatedCategory, error: error)
        }
        .store(in: &cancellables)
    }

    func send(_ intent: TaskListIntent) {
        switch intent:
            // ... //
    }
}
```
- View : `Store`를 통해 상태(`State`) 업데이트 및 사용자 상호작용(`Intent`) 전달
```swift
struct TaskListView: View {
    @StateObject var store: TaskListStore

    // ... //

    List {
        Section {
            ForEach(store.state.undoneTasks) { task in
                // ... //
            }
        }
    }

    // ... //

    Button {
        store.send(.toggleTaskDone(task: task))
    } label: {
        // ... //
    }

    // ... //

    .alert("Error", isPresented: .constant(store.state.hasError), actions: {
        Button("OK") {
            if let error = store.state.error {
                print(error.errorDescription)
            }
        }
    }, message: {
        Text("Data could not be loaded. Please try again later.")
    })
}
```
### 📌 DataManager + TodoRepository로 데이터 관리
- DataManager : `FileManager`를 통한 `saveData`와 `loadData`를 담당
```swift
final class DataManager {
    private let fileManager = FileManager.default
    
    init() {
        createDirectoryIfNeeded()
    }

    // ... //

    func loadData<T: Decodable>() throws -> [T] { // ... // }

    func saveData<T: Encodable>(_ data: [T]) throws { // ... // }
```
- TodoRepository : `Todo`의 `CRUD`를 담당. `single source of truth`인 `@Published` 변수 포함
```swift
final class TodoRepository {
    
    private let dataManager = DataManager()
    
    @Published private(set) var categories: [Category] = []
    @Published private(set) var error: DataError?
    
    init() {
        loadCategories()
    }
    
    private func save() {
        do {
            try dataManager.saveData(categories)
            self.error = nil
            print("[TodoRepository] categories are saved successfully.")
        } catch let dataError as DataError {
            self.error = dataError
            print("[TodoRepository] Save failed: \(dataError)")
        } catch {
            self.error = DataError.etc(error)
            print("[TodoRepository] Save failed: \(error)")
        }
    }

    private func loadCategories() {
        do {
            let loadedCategories: [Category] = try dataManager.loadData()
            self.categories = loadedCategories.isEmpty ? [Category.defaultImportantCategory] : loadedCategories
            self.error = nil
            print("[TodoRepository] \(loadedCategories.count) categories loaded successfully.")
        } catch { // ... // }
    }

    // ... //
}
```
### 📌 Combine을 통한 데이터 바인딩
각 `Store`는 `single source of truth`인 `TodoRepository`의 `categories`와 `error`를 구독하여 `View`와 바인딩합니다.
```swift
import Combine

final class MainStore: ObservableObject {
    private let repository: TodoRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: TodoRepository) {
        self.repository = repository
        bind()
    }
    
    @Published private(set) var state = MainState()
    
    private func bind() {
        Publishers.CombineLatest(
            repository.$categories,
            repository.$error
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] categories, error in
            self?.state = MainState(categories: categories, error: error)
        }
        .store(in: &cancellables)
    }

    // ... //
}
```
## 트러블슈팅
### ⚠️ 제스쳐 충돌 문제
#### ☹️ 문제
<img src="https://github.com/user-attachments/assets/65b8c29b-aad5-4e04-97e4-98a182a29aeb" width=400>

`swipeActions`에 추가한 `Button`을 탭해도 액션이 실행되지 않는 현상
#### 🧐 원인
`TextField`의 focus를 해제하기 위해 뷰에 `onTapGesture` 추가 - 탭 제스쳐가 스와이프 제스쳐와 충돌
> 탭 제스쳐가 스와이프 액션보다 먼저 인식되어 버튼 탭 동작이 전달되지 않음
#### 😇 해결
`onTapGesture`를 제거하고, `TextField`를 포함한 뷰를 분리하여 `sheet`로 present
> `sheet`는 시스템이 키보드 및 화면 dismiss 동작을 기본 제공하므로, 외부 영역을 탭할 때 자동으로 키보드와 뷰가 함께 닫히게 됨
#### 😎 성과
- 제스쳐 충돌이 사라져 `swipeAction`이 정상적으로 작동
- `sheet`는 외부 화면을 탭하면 자연스럽게 dismiss 되므로 UX 개선
- 탭 제스쳐와 스와이프 제스쳐가 우선순위에 따라 충돌할 수 있음을 학습
- 단순히 "탭 제스쳐 제거"에서 그치지 않고 view 구조 변경이라는 의외의 접근을 통해 문제를 해결하는 능력 향상
### ⚠️ confirmationDialog를 거친 데이터 삭제 문제
#### ☹️ 문제
<img src="https://github.com/user-attachments/assets/3f4459c4-29d6-4b15-88c6-9ce222c4eaa0" width=400>

- 스와이프 액션으로 `Category` 삭제 버튼을 탭하면 사용자에게 재확인 메시지를 띄우는 `confirmationDialog` 구현
- dialog 내 `Delete` 버튼을 눌렀을 때 swipe 한 아이템이 아닌 엉뚱한 아이템이 삭제되고, `confirmationDialog`가 짧게 다시 나타났다가 사라지는 현상
#### 🧐 원인
```swift
@State private var showActionSheet: Bool = false

// Categories List
List {
    ForEach(store.state.categories) { category in
        NavigationLink(value: category) {
            HStack {
                // ... //
            }
            .swipeActions(allowsFullSwipe: false) {
                Button {
                    showActionSheet.toggle()
                } label: {
                    Image(systemName: "trash")
                }
            }
            .confirmationDialog("Are you sure you want to delete this category?", isPresented: $showActionSheet) {
                Button("Delete", role: .destructive) {
                    store.send(.deleteCategory(id: category.id))
                }
                // ... //
            }
        }
    }
}

```
- Category List를 `ForEach`문으로 구현 - `swipeAction`, `confirmationDialog`가 반복문 내에 존재
- `ForEach`로 인해 `confirmationDialog`가 여러번 호출되며 삭제 category 값에 대한 추적이 꼬임
#### 😇 해결
```swift
@State private var showActionSheet: Bool = false
@State private var categoryIDToDelete: UUID?

List {
    // ... //
    .swipeActions(allowsFullSwipe: false) {
        Button {
            categoryIDToDelete = category.id
            showActionSheet.toggle()
        } label: {
            Image(systemName: "trash")
        }
    }
}
.confirmationDialog("Are you sure you want to delete this category?", isPresented: $showActionSheet) {
    Button("Delete", role: .destructive) {
        if let categoryID = categoryIDToDelete {
            store.send(.deleteCategory(id: categoryID))
        }
        categoryIDToDelete = nil
    }
    // ... //
}
```
`confirmationDialog`를 반복문 밖으로 빼고, 삭제할 `Category` 정보를 `@State` 변수에 저장하도록 구현
#### 😎 성과
- `confirmationDialog`를 `ForEach` 내부에 구현하면 안된다는 것 학습
- 쉽고 편한 해결을 위해 `confirmationDialog` 자체를 삭제할까도 고민했지만, 좋은 `UX` 유지를 위해 포기하지 않고 타개법을 찾아냄
