# SpeedcubeTimer
Speedcubing timer built with SwiftUI and Redux pattern.

## Table of contents
* [About](#about)
* [Screenshots](#screenshots)
* [Features](#features)
* [Future plans](#future-plans)

## About

Project was started to learn more about SwiftUI and applying MVVM pattern to it. I decided to change architecture to Redux because it's seems more natural and easier to mantain this particular app where screens are strongly dependent on each other with this approach. MVVM which code is still available to see in 'mvvm' branch.

I decided not to share common data using global variables, so it is shared between screens by passing it to appropriate view models when views are created.
With addition of whole logic being moved to view models, it was possible to write unit tests for every functionality.

App is always in dark mode, so it use less energy on devices with OLED screens.

## Screenshots

Results View | Timer View | Settings View
:---:|:-----:|:---:
![IMG_1548](https://user-images.githubusercontent.com/63157451/168847927-4cbfe3bb-2149-45c8-9be9-df20c28805b9.PNG) | ![IMG_1547](https://user-images.githubusercontent.com/63157451/168847889-3990bf66-8b5b-411a-9f7b-324ab360d63a.PNG) | ![IMG_1546](https://user-images.githubusercontent.com/63157451/168847752-44325757-0c66-496c-b022-185e7bae77b4.PNG)


## Features

* Measure your time solving Rubik's cube starting with randomly generated scramble.
* Get new scramble automatically after you finish solve.
* Access details about your previous results by tapping on the list.
* Remove unwanted solves with "edit" button or swipe gesture on row.
* Change cube scramble by selecting different cube in settings (suported: 3x3 and 2x2).
* Store your results on 10 different session for each cube (ex. one hand, bld)
* Turn on preinspection in settings if you need.

### Future plans:

* Add storing data in user defaults.
* Add support for more cubes.
* Add possibility to use own identifier insetad of number of session.
* Add records section above all results.
