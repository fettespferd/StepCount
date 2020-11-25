# Architecture

The app consists of multiple so-called modules. Our main modules correspond to the direct subfolders of `stepCalc/lib/`.

Existing modules:
- `app`: Provides common things for other modules (like brand variables, utility methods, etc.), defines the main application widget & main screen, and combines all other modules via its routing.
- `auth`: contains sign-in/-out pages and the `AuthService` managing the current user
- `calc`: retrieves & displays the main content of the step calculator
- `profile`: displays the user choice to set personal settings  like theme and weight/height
- `settings`: displays the possibility to set the theme

## Modules

Structure of `my_module`:

- `my_module`
  - `module.dart`:
    - exports everything that is required by other modules
    - declares all routes as a final variable (`myModuleRoutes`)
    - may contain initialization code (`initMyModule()`)
  - `cubit.dart`: contains `MyModuleCubit` and `MyModuleState`s
  - `widgets`: holds generic widgets that can be reused
  - `pages`: displays the UI
  - `utils.dart`: contains utilities used throughout this module

## Persistence

We use different kinds of persistence for different kinds of data:

- Firestore: Stores our main entities and is also cached locally.
- Shared Preferences: Configuration data like local settings.
