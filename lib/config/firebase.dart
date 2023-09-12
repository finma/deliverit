import 'package:firebase_database/firebase_database.dart';

DatabaseReference userRef = FirebaseDatabase.instance.ref().child('users');
DatabaseReference driverRef = FirebaseDatabase.instance.ref().child('drivers');

String serverToken =
    'key=AAAAYQwGXaY:APA91bG-sws_GPeMsEkUNx-uthw7lZx7fROrbyxWZgnTa4eiOcws1_yMEKm0UtMhpXLwaUMw9lDGub7U6Tk8TBfrXrQ7LCDgn_fcI7xUjxZheDtpOQKE6qfqCbtMGaxMzEB7SexhgabO';

int driverRequestTimeout = 30;
