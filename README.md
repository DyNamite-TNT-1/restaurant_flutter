# restaurant_flutter
## Overview
This is a Frontend source code to help develop a restaurant reservation website - an academic project of the subject "Object-oriented programming techniques" - taught by lecturer Huynh Trung Tru.

Made by:
  * Le Mau Anh Duc - N19DCCN038
  * Tran Thu Dat - N19DCCN036

`Firestaurant is a website that helps users book tables online quickly, conveniently and without wasting much time and helps managers automate all processes for recording requests to book tables/change tables from clients.`
## Related Source
  * [Backend](https://github.com/DyNamite-TNT-1/nodejs_be_restaurant)
  * [Document](https://github.com/DyNamite-TNT-1/doc-restaurant-project)
## Techniques
  * Language: Dart
  * Framework: Flutter
  * State Management: BLoC
## Main features:
  * For manager roles:
    * Add several information of dish, drink, service..., includes: name, description, image, price, type...
    * Manage client reservation history: view, change status(ex: reject for some reasons) or add notes to it.
  * For client roles:
     * View all information about restaurant: basic information and restaurant's products: dish, drink, service... clearly.
     * Make a reservation.
  * Based on the number of guests, event time, menu, drinks, and services provided by client, the system `automatically arranges tables and notifies prepaid fees(if any)`. In case there is a prepaid fee, the person booking the table is required to pay before the specified time. Otherwise, the system will no longer hold the reservation.
  * In particular, our website `allows customers to message the manager and vice versa`. This helps the restaurant easily connect and better understand clients' requests as well as make customers express their opinions more clearly to the restaurant.
