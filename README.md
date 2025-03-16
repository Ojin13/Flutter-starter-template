# flutter_starter_template

An easy starter template for you next Flutter application

## Folder structure
To get started, please fill the firebase_options.dart file in the configuration folder with your Firebase configuration.

```dart

## Folder structure
- **/common** - This folder serves as a hub for all components that are reused across the application
- **/common/enums** - This folder servers to store all used enum types
- **/common/model** - This folder servers to store all data models
- **/common/theme** - This folder servers to store all app-wide theme related settings
- **/common/ui_functions** - This folder servers to store all Flutter functions that are interacting with UI, such as "showConfirmationDialog"
- **/common/utils** - This folder servers to store all utility functions
- **/common/widget** - This folder servers to store all Flutter widgets

- **/assets** - This is for your resources like images, icons and fonts
- **/configuration** - This folder servers to store all app-wide configurations such as Firebase config
- **/database** - This folder servers to store all database related functions such as connection and queries and data serialization
- **/extensions** - This folder servers to store all flutter extensions
- **/ioc** - This folder servers to store and register Dependency Injection files
- **/pages** - This folder servers to store all individual pages
- **/service** - This folder servers to store and register all app-wide services
