# restaurant_flutter
## Deploy :  
  * FE : https://dynamite-tnt-1.github.io/
  * BE : https://restaurantbe-production.up.railway.app/
  * DATABASE MYSQL : Deploy to clever service
## Overview
`Firestaurant is a website that helps users book tables online quickly, conveniently and without wasting much time and helps managers automate all processes for recording requests to book tables/change tables from clients.`

This is a Frontend source code to help develop a restaurant reservation website - an academic project of the subject "Object-oriented programming techniques" - taught by lecturer Huynh Trung Tru.

Made by:
  * Le Mau Anh Duc - N19DCCN038
  * Tran Thu Dat - N19DCCN036
## Related Source
  * [Backend](https://github.com/DyNamite-TNT-1/nodejs_be_restaurant)
  * [Document](https://github.com/DyNamite-TNT-1/doc-restaurant-project)
## Techniques
  * Language: Dart
  * Framework: Flutter
  * State Management: BLoC
## Main features:
### Common:
  * For manager roles:
    * Add several information of dish, drink, service..., includes: name, description, image, price, type...
    * Manage client reservation history: view, change status(ex: reject for some reasons) or add notes to it.
  * For client roles:
     * View all information about restaurant: basic information and restaurant's products: dish, drink, service... clearly.
     * Make a reservation.
### Special:
  * Automatically reservation: Based on the number of guests, event time, menu, drinks, and services provided by client, the system `automatically arranges tables(without manager intervention) and notifies prepaid fees(if any)`. In case there is a prepaid fee, the person booking the table is required to pay before the specified time. Otherwise, the system will no longer hold the reservation.
  * Messenger-lite: Our website `allows clients to message the manager and vice versa`. This helps the restaurant easily connect and better understand clients' requests as well as make clients express their opinions more clearly to the restaurant.
## How to run this code?
### Editor
Firstly, need an IDE/Editor where build and compile code. Highly recommend to using [VSCode](https://docs.flutter.dev/get-started/editor). Because it's very popular, easy to use and have many extension that make coding more funny and easier.
### Flutter SDK and Dart SDK
See this [original document](https://docs.flutter.dev/get-started/install/windows) to more information.
### Check version
Run `flutter doctor -v` to check version of Flutter and if any missing related to Flutter.
### Now, run it
If you have VSCode and all of above things, now run this.

Step 1: Run `flutter pub get` to get all package/dependency is used in source code.

Step 2: Check the bottom right corner, you can see available devices (maybe IDE needs a few seconds to load it). Click on it and select any browser you have.

<img width="516" alt="Screen Shot 2023-10-26 at 10 23 14 AM" src="https://github.com/DyNamite-TNT-1/restaurant_flutter/assets/104590526/215ab7e1-974f-4f8c-a2d5-b6f5fccdee9a">

Step 3: Check the bar on top, you can see a button called "Run". Click on it. After that, click on "Run without debugging", or "Start debugging" if you want debug code.

<img width="277" alt="Screen Shot 2023-10-26 at 10 31 40 AM" src="https://github.com/DyNamite-TNT-1/restaurant_flutter/assets/104590526/eae487fd-a44f-477b-b3e7-d92e947f141b">

Step 4: Check the result.

Step 5: Make a coffee and fix bug. :coffee: :hammer_and_wrench: :lady_beetle:
