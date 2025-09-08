# Настройка Firebase для EventHub

## Шаги настройки:

### 1. Создание проекта Firebase
1. Перейдите на [Firebase Console](https://console.firebase.google.com/)
2. Создайте новый проект или выберите существующий
3. Включите Authentication и выберите Email/Password и Google провайдеры

### 2. Добавление iOS приложения
1. В консоли Firebase нажмите "Add app" и выберите iOS
2. Введите Bundle ID: `ordos.Event-Hub`
3. Скачайте файл `GoogleService-Info.plist`
4. Замените существующий файл `GoogleService-Info.plist` в проекте

### 3. Настройка Google Sign-In
1. В консоли Firebase перейдите в Authentication > Sign-in method
2. Включите Google провайдер
3. Добавьте iOS Bundle ID: `ordos.Event-Hub`
4. Скачайте файл `GoogleService-Info.plist` (если еще не скачали)

### 4. Настройка URL Schemes
1. В Xcode откройте проект
2. Выберите таргет приложения
3. Перейдите в Info > URL Types
4. Добавьте новый URL Type:
   - Identifier: `GoogleSignIn`
   - URL Schemes: значение `REVERSED_CLIENT_ID` из `GoogleService-Info.plist`

### 5. Добавление зависимостей
1. В Xcode выберите File > Add Package Dependencies
2. Добавьте следующие пакеты:
   - `https://github.com/firebase/firebase-ios-sdk.git` (версия 10.0.0+)
   - `https://github.com/google/GoogleSignIn-iOS.git` (версия 7.0.0+)

### 6. Настройка Info.plist
Добавьте в Info.plist следующие ключи:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>GoogleSignIn</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

### 7. Инициализация Firebase
Firebase уже настроен в `Event_HubApp.swift` с вызовом `FirebaseApp.configure()`

## Тестирование
После настройки вы сможете:
- Регистрироваться с email/паролем
- Входить с email/паролем
- Входить через Google
- Сбрасывать пароль
- Использовать функцию "Remember Me"

## Важные замечания
- Убедитесь, что все ключи в `GoogleService-Info.plist` заполнены корректно
- Проверьте, что Bundle ID в Firebase совпадает с Bundle ID в Xcode
- Для продакшена обязательно настройте правильные домены в Firebase Console
