# ToDoList - Оптимизированное приложение для управления задачами

## Описание

ToDoList - это iOS приложение для управления списком задач с использованием Core Data для хранения данных. Приложение полностью соответствует требованиям по функциональности и предоставляет удобный пользовательский интерфейс.

## Функциональность

### ✅ Реализованные требования:

1. **Список задач**
   - Отображение списка задач на главном экране
   - Каждая задача содержит: название, описание, дату создания и статус (выполнена/не выполнена)
   - Возможность добавления новой задачи
   - Возможность редактирования существующей задачи
   - Возможность удаления задачи

### 🚀 Дополнительные возможности:

- **Поиск задач** - поиск по названию и описанию
- **Фильтрация** - фильтр по статусу (все/выполненные/не выполненные)
- **Сортировка** - автоматическая сортировка (не выполненные сначала, затем по дате создания)
- **Визуальные индикаторы** - зачеркивание выполненных задач, цветовые индикаторы статуса
- **Пустое состояние** - красивое отображение при отсутствии задач
- **Свайп-действия** - быстрый доступ к редактированию и удалению

## Архитектура

### CoreDataManager
Оптимизированный менеджер для работы с Core Data, предоставляющий:

```swift
// Основные операции
func createTask(title: String, description: String?) -> UserTask?
func fetchAllTasks(sortedBy sortDescriptors: [NSSortDescriptor]?) -> [UserTask]
func updateTask(_ task: UserTask, title: String?, description: String?, isCompleted: Bool?)
func deleteTask(_ task: UserTask)
func toggleTaskCompletion(_ task: UserTask)

// Фильтрация
func fetchCompletedTasks() -> [UserTask]
func fetchIncompleteTasks() -> [UserTask]

// Управление контекстом
func saveContext()
func rollbackContext()
```

### TaskManager
Высокоуровневый менеджер для работы с задачами:

```swift
// Операции с задачами
func addTask(title: String, description: String?) -> Bool
func updateTask(_ task: UserTask, title: String?, description: String?) -> Bool
func deleteTask(_ task: UserTask) -> Bool
func toggleTaskCompletion(_ task: UserTask) -> Bool

// Получение данных
func getAllTasks() -> [UserTask]
func getCompletedTasks() -> [UserTask]
func getIncompleteTasks() -> [UserTask]
func searchTasks(with query: String) -> [UserTask]
```

### UserTask Extensions
Удобные расширения для работы с задачами:

```swift
// Вычисляемые свойства
var displayTitle: String
var displayDescription: String
var formattedCreationDate: String
var statusText: String
var statusIcon: String

// Методы
func toggleCompletion()
func markAsCompleted()
func markAsIncomplete()
func matches(searchText: String) -> Bool
```

## Модель данных

### UserTask Entity
```swift
- id: UUID (уникальный идентификатор)
- title: String (название задачи)
- taskDescription: String? (описание задачи)
- creationDate: Date (дата создания)
- isCompleted: Bool (статус выполнения)
- serverID: Int64 (для будущей синхронизации)
```

## Использование

### Создание задачи
```swift
let taskManager = TaskManager()
taskManager.addTask(title: "Новая задача", description: "Описание задачи") { success in
    if success {
        print("Задача создана успешно")
    } else {
        print("Ошибка создания задачи")
    }
}
```

### Получение задач
```swift
taskManager.getAllTasks { tasks in
    print("Загружено \(tasks.count) задач")
}

taskManager.getCompletedTasks { tasks in
    print("Выполненных задач: \(tasks.count)")
}

taskManager.getIncompleteTasks { tasks in
    print("Не выполненных задач: \(tasks.count)")
}
```

### Поиск задач
```swift
taskManager.searchTasks(with: "поисковый запрос") { results in
    print("Найдено \(results.count) задач")
}
```

### Обновление задачи
```swift
taskManager.updateTask(existingTask, title: "Новое название", description: "Новое описание") { success in
    if success {
        print("Задача обновлена")
    }
}
```

### Переключение статуса
```swift
taskManager.toggleTaskCompletion(task) { success in
    if success {
        print("Статус изменен")
    }
}
```

### Использование TaskOperationManager
```swift
let operationManager = TaskOperationManager(viewController: self)

operationManager.addTask(title: "Новая задача", description: nil) {
    // Успешное создание
    self.loadTasks()
} onError: { error in
    // Показать ошибку пользователю
    self.showErrorAlert(message: error)
}
```

## Особенности реализации

### 1. Фоновые операции с GCD
Все операции с Core Data выполняются в фоновых потоках для обеспечения отзывчивости UI:

```swift
// CoreDataManager использует background context
private lazy var backgroundContext: NSManagedObjectContext = {
    let context = persistentContainer.newBackgroundContext()
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return context
}()

// Операции выполняются в backgroundContext.perform
backgroundContext.perform {
    // Операции с данными
    DispatchQueue.main.async {
        // Обновление UI
    }
}
```

### 2. Асинхронные операции
Все методы используют completion handlers для асинхронного выполнения:

```swift
func createTask(title: String, description: String?, completion: @escaping (UserTask?) -> Void)
func fetchAllTasks(sortedBy sortDescriptors: [NSSortDescriptor]?, completion: @escaping ([UserTask]) -> Void)
func updateTask(_ task: UserTask, title: String?, description: String?, isCompleted: Bool?, completion: @escaping (Bool) -> Void)
```

### 3. TaskOperationManager
Дополнительный слой для управления операциями с индикаторами загрузки:

```swift
let operationManager = TaskOperationManager(viewController: self)
operationManager.addTask(title: "Новая задача", description: nil) {
    // Успешное выполнение
} onError: { error in
    // Обработка ошибки
}
```

### 4. Singleton Pattern
CoreDataManager использует паттерн Singleton для обеспечения единственного экземпляра:
```swift
static let shared = CoreDataManager()
```

### 5. Protocol-Oriented Design
Все основные компоненты используют протоколы для лучшей тестируемости и гибкости:
- `CoreDataManagerType`
- `TaskManagerType`
- `TaskOperationManagerType`

### 6. Error Handling
Реализована обработка ошибок с информативными сообщениями для пользователя.

### 7. Memory Management
Правильное управление памятью с использованием weak references в замыканиях.

### 8. UI/UX
- Современный дизайн с использованием системных цветов
- Адаптивный интерфейс
- Анимации и переходы
- Поддержка Dark Mode
- Индикаторы загрузки для длительных операций

## Структура проекта

```
ToDoList/
├── Sources/
│   ├── CoreDataManager.swift         # Основной менеджер Core Data с фоновыми операциями
│   ├── TaskManager.swift             # Высокоуровневый менеджер задач
│   ├── TaskOperationManager.swift    # Менеджер операций с индикаторами загрузки
│   ├── UserTask+Extensions.swift     # Расширения для UserTask
│   ├── ViewController.swift          # Главный экран
│   └── TaskTableViewCell.swift       # Кастомная ячейка
├── Resources/
│   └── Assets.xcassets/              # Ресурсы приложения
└── ToDoList.xcdatamodeld/            # Модель данных Core Data
```

## Требования

- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## Установка и запуск

1. Клонируйте репозиторий
2. Откройте `ToDoList.xcodeproj` в Xcode
3. Выберите симулятор или устройство
4. Нажмите Run (⌘+R)

## Тестирование

Приложение включает базовые тесты в папке `ToDoListTests/`. Для запуска тестов используйте ⌘+U в Xcode.

