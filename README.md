# ToDoList
> `SwiftUI`를 독학한 뒤 처음으로 만든 앱입니다. `UIKit`으로 구현했던 할 일 관리 앱을 다시 구현한 프로젝트입니다.
## 목차
- [주요 구현사항](#-주요-구현사항)
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
