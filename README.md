# SpeedcubeTimer
Speedcubing timer built with SwiftUI and Redux pattern.

First approach was MVVM which code is still available to see in 'mvvm' branch. I decided to change architecture because it's seems more natural and easier to mantain this particular app where screens are strongly dependent on each other with Redux approach.

## Table of contents
* [About](#about)
* [Screenshots](#screenshots)
* [Features](#features)
* [Future plans](#future-plans)

## About

Project was started to learn more about SwiftUI and applying MVVM pattern to it.

I decided not to share common data using global variables, so it is shared between screens by passing it to appropriate view models when views are created.
With addition of whole logic being moved to view models, it was possible to write unit tests for every functionality.

App is always in dark mode, so it use less energy on devices with OLED screens.

## Screenshots

Results View | Timer View | Settings View
:---:|:-----:|:---:
![Simulator Screen Shot - iPhone 11 - 2022-04-03 at 18 01 49](https://user-images.githubusercontent.com/63157451/161436974-ad09e77f-3063-4c54-a786-e9af341245ec.png) | ![Simulator Screen Shot - iPhone 11 - 2022-04-03 at 18 00 39](https://user-images.githubusercontent.com/63157451/161436969-dacd95f8-fb46-4066-9b81-368b8971e9b8.png) | ![Simulator Screen Shot - iPhone 11 - 2022-04-03 at 21 46 33](https://user-images.githubusercontent.com/63157451/161445457-1a6b34f8-91ec-4da3-b87f-f664902bcae7.png)

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
