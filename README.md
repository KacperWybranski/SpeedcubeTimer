# SpeedcubeTimer
Speedcubing timer built with SwiftUI and Redux pattern.

## Table of contents
* [About](#about)
* [Screenshots](#screenshots)
* [Features](#features)
* [Future plans](#future-plans)

## About

Project was started to learn more about SwiftUI and applying MVVM pattern to it. I decided to change architecture to Redux because it's seems more natural and easier to mantain this particular app where screens are strongly dependent on each other with this approach. MVVM which code is still available to see in 'mvvm' branch.

I decided not to share common data using global variables, so it is shared between screens by passing it to appropriate states when views are created.
Redux architecture with any logic happening in reducers make it really easy to write tests for every step when app state is changed.

App is always in dark mode, so it use less energy on devices with OLED screens.

## Screenshots

Results View | Timer View | Settings View
:---:|:-----:|:---:
 ![IMG_3772](https://user-images.githubusercontent.com/63157451/187084945-5c0323d1-5389-4a36-b27e-575e483da7f9.PNG) | ![IMG_3768](https://user-images.githubusercontent.com/63157451/187084985-c31cfaf2-e3be-4c61-be1a-f2a3265dfb41.PNG) | ![IMG_3867](https://user-images.githubusercontent.com/63157451/189527589-8907638a-eb62-46db-9ae9-982e55b36285.PNG)
![IMG_3769](https://user-images.githubusercontent.com/63157451/187084962-267fc55d-4855-465c-9e88-5b4217fce249.PNG) | ![IMG_3774](https://user-images.githubusercontent.com/63157451/187084966-b828f0cb-3196-4c0f-8d0b-f5c78dfeb12a.PNG) | ![IMG_3771](https://user-images.githubusercontent.com/63157451/187084980-27cd8852-73c4-4a17-b0f5-8e0b51616a2f.PNG)





## Features

* Measure your time solving Rubik's cube starting with randomly generated scramble.
* Get new scramble automatically after you finish solve.
* Access details about your previous results by tapping on the list.
* Remove unwanted solves with "edit" button or swipe gesture on row.
* Change cube scramble by selecting different cube in settings (suported: 2x2, 3x3, 4x4).
* Store your results on 10 different session for each cube (ex. one hand, bld)
* Turn on preinspection in settings if you need.
* Keep track of your records.

### Future plans:

* Add storing data in user defaults.
* Add support for more cubes.
* Add possibility to use own identifier insetad of number of session.
