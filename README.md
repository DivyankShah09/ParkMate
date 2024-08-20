# CSCI 5193 - ParkMate

- _Last Modification Date_: 07 / 08 / 2024
- Android Apk File: [ParkMate](https://dalu-my.sharepoint.com/:f:/g/personal/am839007_dal_ca/EtSLrShgLX1IjUIbPkUNh90BjHhCj0d4WCUD8hylYQIZtg?e=ly2d6e) - Accessible to anyone with the link (Expires on 06th September 2024)

## Introduction

ParkMate is an innovative mobile application designed to revolutionize the way you find and utilize parking spaces. Whether you're a car owner in need of a spot, a homeowner with extra space, or a fleet manager, ParkMate offers a comprehensive solution that caters to all parking needs, enhancing convenience and sustainability.

## Team Roles

- [Aman Desai](amandesai@dal.ca) - B00965752 - Developer
- [Akshat Shah](akshat.shah@dal.ca) - B00971354 - Product Designer
- [Divyank Shah](dv491067@dal.ca) - B00966377 - Developer
- [Dharmil Shah](dharmilnshah@dal.ca) - B00965853 - Product Designer
- [Nikunj Hudka](nk856850@dal.ca) - B00959783 - Developer
- [Shyamal Prajapati](sgp@dal.ca) - B00958501 - Product Designer

## Problem

- Difficulty finding right parking spaces.
- Lack of awareness about no-parking zones.
- Time wasted searching for parking.
- Traffic congestion around busy areas like shopping centers and public places.

## Solution

- **Scouting Safe Parking Spots:** Easily find and reserve safe parking spots through the app.
- **Pre-Booking Feature:** Book your parking spot in advance to save time and avoid hassle.
- **Earn Extra Money:** List your own parking space and generate passive income.

## Unique Value Proposition

- **Income Generation:** Users can list their available parking spaces to earn extra money.
- **Sustainability:** By optimizing parking, ParkMate helps reduce carbon emissions and promote environmental sustainability.

## Tech Stack

- [Flutter](https://flutter.dev/): Cross-platform mobile app development framework
- [MongoDB](https://www.mongodb.com/): NoSQL database
- [mongo_dart](https://pub.dev/packages/mongo_dart): Server side library package used for querying data from MongoDB through Flutter

## Functionalities

_As on 07th August 2024_

**Login**

- Users can login to their account using their email and password.
- Includes validation checks for both the email and password.
- Users can log in as either a Spot Seeker or a Spot Host, with each type having access to different functionalities.

**Signup**

- Users can create a new account by providing their email, password, and name.
- It does have a validation check for the name (name cannot be empty), email, password and confirm password.
- During the signup process, users must select their user type (Spot Seeker or Spot Host).

**Dashboard**
- Displays data for parking spots with brief information in the form of cards.
- Users can click on a card to view the details of the spot.
- Cards are displayed in a grid view.
- Includes a search bar to search for parking spots based on location.

**Navigation Drawer**
- A navigation drawer on the dashboard provides options based on the user type:
  - **Spot Seekers**: Navigate to the booking history page or the spot maps page.
  - **Spot Hosts**: Navigate to the current bookings page, spot maps page, and profile page.

**Spot Details & Spot Booking Confirmation**
- Detailed information about the spot is displayed when a card on the Dashboard page is clicked.
- Includes the spot's name, address, price, and availability.
- Users can reserve the spot by clicking the Reserve button.
- A confirmation screen is displayed after the spot is reserved.

**Spot Search Functionality**
- Users can search for parking spots by name on the dashboard.
- A pull-to-refresh functionality is provided to update the list of available spots on dashboard.

**Spot Map**
- Parking spots are displayed on a map using the [flutter_map](https://pub.dev/packages/flutter_map) package.
- Users can see spots near their location, detected using the [location](https://pub.dev/packages/location) package.
- The [geocoding](https://pub.dev/packages/geocoding) package converts coordinates into readable addresses.
- Users can view spot details and reserve a spot directly from the map.

**Booking History**

- Users can view a history of their booked spots, including booking time and cost.

**Host Dashboard**

- Spot Hosts can view a list of their parking spots.
- Includes the option to add a new spot or view the details of an existing spot.
- Spot Hosts can view the current bookings for each spot.

**Spot Registration**
- Spot Hosts can register a new parking spot by providing details such as name, address, price and image.
- The spot's location is detected using the [geocoding](https://pub.dev/packages/geocoding) and [location](https://pub.dev/packages/location) packages.
- Spot Hosts can upload an image of the parking spot.

**Host Profile**
- Host can see their total earnings and other details in the profile screen.

**Seeker Profile - Share Feature**
- Seeker can see their name and total fuel saved in the profile screen. They can also see their total money saved in relation to the fuel/gasoline saved.
- The users can share this information on any social media platform using the share option. The details also include the application download link.
- To implement sharing we have utiilized [screenshot](https://pub.dev/packages/screenshot), for clicking the widget screenshot, [share_plus](https://pub.dev/packages/share_plus), and for storing the image temporarily in the device, [path_provider](https://pub.dev/packages/path_provider) is used.

## Google Analytics

In this project, Google Analytics is integrated to track and analyze user interactions. The setup includes the following steps:

- **Firebase Project Creation:** A Firebase project was created using the [`flutterfire_cli`](https://pub.dev/packages/flutterfire_cli) to enable Google Analytics.
- **Firebase Initialization:** The `FirebaseAnalytics` instance was initialized in the application to start capturing analytics data.
- **Event Tracking:** Integrated the [`firebase_analytics`](https://pub.dev/packages/firebase_analytics) package to facilitate event logging and tracking within the application.

This setup helps in monitoring user behavior and application performance by collecting and analyzing usage data.


## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [MongoDB](https://www.mongodb.com/try/download/community)

### Installation

1. **Clone the repository:**

   ```sh
   git clone https://git.cs.dal.ca/ahdesai/parkmate
   cd parkmate
   ```

2. **Install dependencies:**

   ```sh
   flutter pub get
   ```

3. **Set up environment variables:**
   Create a `.env` file in the root directory and add your MongoDB connection details.

   ```env
   MONGODB_PASSWORD=mongodb_password
   ```

4. **Run the application:**
   For running the application, you need to have an android emulator running or a physical device connected.
   ```sh
   flutter run
   ```

## References

- "Free Photo | Hallway of a garage," Freepik. [Online]. Available: https://www.freepik.com/free-photo/hallway-garage_26189434.htm#fromView=search&page=1&position=2&uuid=cbec4399-fa6c-4f17-a073-eee3970b502e. [Accessed Jul. 17, 2024]

- "Free Photo | Horizontal picture of car parking," Freepik. [Online]. Available: https://www.freepik.com/free-photo/horizontal-picture-car-parking-underground-garage-interior-with-neon-lights-autocars-parked-buildings-urban-constructions-space-transportation-vehicle-night-city-concept_11284626.htm#fromView=search&page=1&position=39&uuid=7c67473c-15c8-486b-8633-3c513ddb66dc. [Accessed Jul. 17, 2024]

- "Free Photo | Blurred nightlights in the city," Freepik. [Online]. Available: https://www.freepik.com/free-photo/blurred-nightlights-city_16694296.htm#fromView=search&page=2&position=33&uuid=7c67473c-15c8-486b-8633-3c513ddb66dc. [Accessed Jul. 17, 2024]

- "Car park in the mall," Unsplash. [Online]. Available: https://unsplash.com/photos/white-and-yellow-train-station-rCZQCbUAQvg. [Accessed Jul. 17, 2024]

- “Geocoding: Flutter Package,” Dart packages [Online]. Available: https://pub.dev/packages/geocoding. [Accessed Jul. 17, 2024]
- “Location: Flutter package,” Dart packages [Online]. Available: https://pub.dev/packages/location. [Accessed Jul. 17, 2024].
- “Flutter_map: Flutter Package,” Dart packages [Online]. Available: https://pub.dev/packages/flutter_map. [Accessed Jul. 17, 2024].
- “Figma: The Collaborative Interface Design Tool,” Figma. [Online]. Available:
http://figma.com [Accessed Jul. 17, 2024]
- “flutterfire_cli | Dart Package,” Dart packages [Online]. Available: https://pub.dev/packages/flutterfire_cli. [Accessed Aug. 7, 2024].
- “firebase_core | Dart Package,” Dart packages [Online]. Available: https://pub.dev/packages/firebase_core. [Accessed Aug. 7, 2024].
- “screenshot | Dart Package,” Dart packages [Online]. Available: https://pub.dev/packages/screenshot. [Accessed Aug. 7, 2024].
- “path_provider | Dart Package,” Dart packages [Online]. Available: https://pub.dev/packages/path_provider. [Accessed Aug. 7, 2024].
- “share_plus | Dart Package,” Dart packages [Online]. Available: https://pub.dev/packages/share_plus. [Accessed Aug. 7, 2024].
