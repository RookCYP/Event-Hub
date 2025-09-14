# Архитектура модуля авторизации EventHub

## Структура модуля

```
Modules/Authentication/
├── AuthenticationView.swift          # Главный контейнер с навигацией
├── AuthenticationManager.swift       # Менеджер авторизации (ViewModel)
├── Views/
│   ├── SignInView.swift             # Экран входа
│   ├── SignUpView.swift             # Экран регистрации
│   ├── ForgotPasswordView.swift     # Экран сброса пароля (email)
│   └── ResetPasswordView.swift      # Экран сброса пароля (новый пароль)
└── Components/
    ├── AuthTextField.swift          # Переиспользуемое поле ввода
    └── AuthButton.swift             # Переиспользуемая кнопка
```

## Основные компоненты

### 1. AuthenticationView
- **Назначение**: Главный контейнер модуля авторизации
- **Функции**: 
  - Управление навигацией между экранами
  - Переключение между SignIn, SignUp, ForgotPassword, ResetPassword
- **Состояние**: `currentScreen: AuthScreen`

### 2. AuthenticationManager
- **Назначение**: Центральный менеджер авторизации
- **Функции**:
  - Управление состоянием авторизации
  - Интеграция с Firebase Auth
  - Google Sign-In
  - Remember Me логика
  - Обработка ошибок
- **Состояние**: 
  - `isAuthenticated: Bool`
  - `isLoading: Bool`
  - `errorMessage: String?`
  - `user: User?`

### 3. Экраны авторизации

#### SignInView
- **Функции**:
  - Вход по email/паролю
  - Google Sign-In
  - Remember Me переключатель
  - Переход к регистрации и сбросу пароля

#### SignUpView
- **Функции**:
  - Регистрация нового пользователя
  - Валидация паролей
  - Google Sign-In
  - Переход к входу

#### ForgotPasswordView
- **Функции**:
  - Отправка письма для сброса пароля
  - Валидация email
  - Обратная навигация

#### ResetPasswordView
- **Функции**:
  - Ввод нового пароля
  - Подтверждение пароля
  - Обновление пароля в Firebase
  - Обратная навигация

### 4. Переиспользуемые компоненты

#### AuthTextField
- **Функции**:
  - Унифицированное поле ввода
  - Поддержка иконок
  - Secure/обычный режим
  - Настройка клавиатуры

#### AuthButton
- **Функции**:
  - Унифицированная кнопка
  - Разные стили (primary, secondary, google)
  - Состояние загрузки
  - Иконки

## Поток данных

1. **Инициализация**: `Event_HubApp` создает `AuthenticationManager`
2. **Проверка авторизации**: При запуске проверяется статус авторизации
3. **Remember Me**: Если включен, пользователь автоматически входит
4. **Навигация**: `AuthenticationView` управляет переключением экранов
5. **Действия**: Пользователь выполняет действия (вход, регистрация, сброс)
6. **Firebase**: `AuthenticationManager` взаимодействует с Firebase
7. **Обновление UI**: Состояние обновляется и UI реагирует

## Интеграция с Firebase

### Настройка
- `GoogleService-Info.plist` - конфигурация Firebase
- `FirebaseApp.configure()` - инициализация в App
- Зависимости: FirebaseAuth, FirebaseCore, GoogleSignIn

### Функции
- Email/Password авторизация
- Google Sign-In
- Сброс пароля
- Управление сессией
- Remember Me через UserDefaults

## Безопасность

- Валидация email и паролей
- Минимальная длина пароля (6 символов)
- Secure поля для паролей
- Обработка ошибок Firebase
- Безопасное хранение Remember Me настройки

## Навигация

- **SignIn** ↔ **SignUp**: Взаимные переходы
- **SignIn** → **ForgotPassword**: Сброс пароля
- **ForgotPassword** → **SignIn**: Возврат назад
- **ResetPassword** → **SignIn**: После смены пароля
- Все экраны имеют кнопку "Назад" (кроме SignIn)

## Состояния загрузки

- Глобальный индикатор загрузки
- Блокировка UI во время операций
- Обработка ошибок с отображением пользователю
- Автоматическое скрытие ошибок при новых действиях
