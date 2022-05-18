# Plant Monitor App

At MSc Connected Environment, CASA, UCL, each student had built a plant monitor to measure real-time temperature, humidity and soil moisture for their given plant and sent these data to MQTT continuously. This app is designed to provide a live view of the MQTT data on mobile devices so that users can view real-time plant information without using the MQTT Explorer on a laptop. 

## Use this README File 

The Plant Monitor App has two functions, visualize real-time plant data and trigger a notification of watering when soil moisture is below a pre-set value. By opening the app, MQTT connections are established subscribing to the moisture levels of each plant and triggering corresponding notifications of watering if the plant’s moisture is below 100. Users can also select which plant they want to browse on the homepage, and when a plant is chosen, users will be redirected to the detail page, where a picture of the chosen plant, as well as the plant’s name, id,  owner, real-time temperature, humidity, moisture will be listed to view.

![Simulator Screen Shot - iPhone 13 - 2022-05-18 at 14 09 40](https://user-images.githubusercontent.com/91919718/169058650-3904ee42-8616-46cd-8c61-db3b801dc4b2.png)
Figure 1. Homepage

![Simulator Screen Shot - iPhone 13 - 2022-05-10 at 18 22 20](https://user-images.githubusercontent.com/91919718/169058918-6bbf640d-a556-4e5a-82fa-f0e77c1f3e10.png)
Figure 2. Detail Page while waiting for MQTT

![Simulator Screen Shot - iPhone 13 - 2022-05-10 at 18 24 04](https://user-images.githubusercontent.com/91919718/169059109-da4c83a4-a466-436e-9815-053fa00e21f5.png)
Figure 3. Detail Page with real time data





At the moment only three plants are listed for browsing, they are ucfnmsm, ucfnaka and ucfnxxx. This is due to a change of CE-Hub SSID so that the monitors which did not update their onboard Wi-Fi password can no longer publish MQTT messages. In the future, more plants could be added to this app by simply replicating the file /app/lib/ucfnmsm.dart and replacing the specific plant names/pictures/owners/id/MQTT topics. Future implementations also include developing a “society” on a separate page for users’ entertainment and discussion. 


## How To Install The App

1. Install flutter at https://docs.flutter.dev/get-started/install

2. Clone this project and open the folder with any IDE (ie. Android Studio, VSCode, IntelliJ, etc)
3. You will need to install dependencies mqtt_client by run flutter pub get from the command line running from your project directory.

##  Contact Details

    Drop an email to me if you are also interested in this app! 
    dongyi.ma.21@ucl.ac.uk
