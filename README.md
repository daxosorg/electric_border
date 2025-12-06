# Electric Border

This Flutter project demonstrates a simple but visually appealing UI with an "electric" border effect. The project has been refactored from a single file into a more organized and scalable structure.

## Project Structure

The project follows a standard Flutter project structure, with the code organized into the following directories:

- `lib/`: This is the main directory for the project's Dart code.
  - `main.dart`: The entry point of the application.
  - `app.dart`: The root widget of the application (`MyApp`).
  - `core/`: This directory contains the core application logic, such as constants.
    - `constants.dart`: This file contains all the constants used in the application.
  - `features/`: This directory contains the different features of the application. Each feature has its own directory, which contains the presentation, business logic, and data layers.
    - `electric_card/`: This directory contains the "electric card" feature.
      - `presentation/`: This directory contains the UI of the feature, such as screens and widgets.
        - `electric_card_screen.dart`: The main screen of the feature.
        - `widgets/`: This directory contains the widgets used in the feature.
          - `electric_border_card.dart`: The card widget.
          - `electric_border_painter.dart`: The custom painter for the electric border effect.

## How to Run

To run the project, simply execute the following command:

```
flutter run
```