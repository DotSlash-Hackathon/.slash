# Suraksha
In today's world, women safety has become the major issue that needs to be looked into as soon as possible.
Around **70%** of woman/girls/child face certain incidents that make a great impact in their life. 
Looking forward to this problem, we, **Team DevNet** has made an app for women's help whenever they are in emergency.

Suraksha is a kind of SOS System. 
Whenever any girl is in danger, they can use the app.

**Major features of Suraksha are:**
         1.The app can be invoked using **Google Assistant**.
         2.Once the app is opened, the user can simply press the **Volume Up** button to send the current location.
         3.The location will be sent as SMS to the 2 registered number which is taken during registration.
         4.The message is in 3 form: <ul>
  <li> Coordinates of the location.</li>
                   <li>Exact location</li>
  <li>Google Map link, so that the recepient can reach quickly.</li></ul>
         5. The user can check the current status of the place, i.e. when a women is new to certain place, and is also alone, she would be definitely be afraid, so she can check whether the area in which she is, is safe or not. 
        6. Along with checking for current location, the user will get information about every unsafe location in 10km radius.

We have built the same using Flutter as the front-end and back-end. For database, we have used Firebase. For sending sms, we have used sms library of flutter. For getting the user coordinates, we have used gps library of flutter and for reverse geocoding i.e., converting the coordinates into proper string format address, we have used geocoder package of flutter.
