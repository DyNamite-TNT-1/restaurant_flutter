# Firestaurant
<p align="center" style="background-color:#282C34">
  <img src="./assets/images/logo_website.png" width="300px">
</p>
<h1 align="center">A reservation Website</h1>

`Firestaurant is a website that helps users book tables online quickly, conveniently and without wasting much time and helps managers automate all processes for recording requests to book tables/change tables from clients.`

---

This is a Frontend source code to help develop a restaurant reservation website - an academic project of the subject "Object-oriented programming techniques" - taught by lecturer Huynh Trung Tru.

Made by:
  * Le Mau Anh Duc - N19DCCN038
  * Tran Thu Dat - N19DCCN036
## Deploy  
  * FE: https://dynamite-tnt-1.github.io/
  * BE: https://restaurantbe-production.up.railway.app/
  * DATABASE MYSQL: Deploy to clever service
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
     * Change schedule of reservation or cancel it.
### Special:
  * Automatically reservation: Based on the number of guests, event time, menu, drinks, and services provided by client, the system `automatically arranges tables(without manager intervention) and notifies prepaid fees(if any)`. In case there is a prepaid fee, the person booking the table is required to pay before the specified time. Otherwise, the system will no longer hold the reservation.
  * Messenger-lite: Our website `allows clients to message the manager and vice versa`. This helps the restaurant easily connect and better understand clients' requests as well as make clients express their opinions more clearly to the restaurant.
  * Multi-language: Our website currently supports 2 languages: ENGLISH and VIETNAMESE. Because backend technology is still limited, the data in the database cannot support multiple languages, so some data is only displayed in Vietnamese.
## How to use website?
Visit [Firestaurant](https://dynamite-tnt-1.github.io/)

### Change Language
* In case the current languages don't work for you, you can change them in Setting Tab.

![image](https://github.com/DyNamite-TNT-1/restaurant_flutter/assets/104590526/32f3338e-3c0c-4092-886d-01310ac46159)

* Click on "Change Language".

![image](https://github.com/DyNamite-TNT-1/restaurant_flutter/assets/104590526/ac421bba-af44-4a49-8dca-4769fadade86)

* Change language what you want and "Apply" it.

![image](https://github.com/DyNamite-TNT-1/restaurant_flutter/assets/104590526/3fdf06f2-ca6c-4d7d-831b-7dca9f68704b)

### Reservation Tab
This tab helps you prepare a table reservation request by entering information such as the number of guests, date and time of the event, seating location, and a list of dishes, drinks, services, and notes you want to send to the restaurant.
* Click on "Booking" Button on the right top corner.

![image](https://github.com/DyNamite-TNT-1/restaurant_flutter/assets/104590526/47ec7279-e23c-439f-bf16-01d5e9e3f2d5)
 
* Click on add/subtract button to increase/descrease quantity. Or change order of item by drag and drop button shaped like an equal sign.

![image](https://github.com/DyNamite-TNT-1/restaurant_flutter/assets/104590526/d060670e-97aa-4629-9092-d6ed43629187)

![image](https://github.com/DyNamite-TNT-1/restaurant_flutter/assets/104590526/e4a83d25-991f-4294-b18a-3399099edec3)

* Click on "Ghi chú" Tab to add your note.

* Click on "Reservation Confirmation" to make a reservation(need Sign In).

### View dishes, drinks, services
* Simalar to Setting Tab, you click on Dish, Drink, Service tab to view list of each.

![image](https://github.com/DyNamite-TNT-1/restaurant_flutter/assets/104590526/688aca50-7f68-4100-8ecf-e013940748a0)

* For example, in the dish tab, a list of dishes appears with the following interface for each dish

![image](https://github.com/DyNamite-TNT-1/restaurant_flutter/assets/104590526/62bf5262-6b1d-4484-98e0-39b35496980a)

* You can filter by Type, order Price by the top bar

![image](https://github.com/DyNamite-TNT-1/restaurant_flutter/assets/104590526/9612364e-6a39-4c07-9b84-3e5a9b1c1520)

* Pagination on the bottom.

![image](https://github.com/DyNamite-TNT-1/restaurant_flutter/assets/104590526/2a5025d4-06cc-4142-9653-15e16bd6b2ad)

* To add what you want to Reservation Tab, just click on a specific item.
### View history
This function need to Sign In.
* Click History Tab to see all your reservation history. Have filter bar and pagination on this screen.

![image](https://github.com/DyNamite-TNT-1/restaurant_flutter/assets/104590526/2362a908-2d9a-457a-a0a0-b41b3f60773f)

* Click on "three dot" button to view detail of specific reservation.

![image](https://github.com/DyNamite-TNT-1/restaurant_flutter/assets/104590526/afef7469-fce6-4e2e-ad3d-509d8e3d5cf7)

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
