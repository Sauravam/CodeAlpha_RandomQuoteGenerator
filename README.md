
# Random Quote Generator

The Random Quote Generator is a minimal Flutter application. Its primary purpose is to display a random quote to the user upon launch, and allow them to fetch subsequent random quotes via a dedicated button. The app emphasizes a clean aesthetic, focusing entirely on the content (the quote and author) without unnecessary UI clutter.


## Tech Stack

**Framework::** Flutter

**Language:** Dart

**State Management:** Built-in StatefulWidget (Local State)

**Networking:** http package
## Key Features

**Dynamic Content Fetching:** Retrieves a random quote and author on app startup.

**On-Demand Updates:** A "New Quote" button to fetch and display a new quote instantly.

**Responsive Animations:** Smooth fade and slide transitions between quotes using AnimatedSwitcher to prevent abrupt text replacements.

**Adaptive Theming:** Full support for both system Light Mode and Dark Mode out-of-the-box.

**Minimalist UI:** Clean typography and spacious layout prioritizing readability.

## API Integration

The app relies on the free, open-source DummyJSON Quotes API (https://dummyjson.com/quotes/random).

The **fetchQuote()** asynchronous method handles the network request using the **http.get** function.

The response is decoded using **dart:convert** (JSON decoder).

Robust error handling is implemented. If the API fails or the device is offline, the app gracefully updates the state to show an error message instead of crashing.
