import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {

  String location; //Location name for UI
  String time; //Time in given location
  String flag; //URL to asset flag icon
  String url; //URL for API endpoint
  bool isDayTime;

  WorldTime({ this.location, this.flag, this.url });

  Future<void> getTime() async {

    while (true) {
      try {
        Response response = await get(Uri.https('worldtimeapi.org', 'api/timezone/$url'));

        Map data = jsonDecode(response.body);

        //print(data['datetime']);
        //Get Properties from DateTime Data
        String dateTime = data['datetime'];
        String offsetHrs = data['utc_offset'].substring(1, 3);
        String offsetMins = data['utc_offset'].substring(4, 6);

        //Create DateTime Object
        DateTime now = DateTime.parse(dateTime);
        now = now.add(Duration(hours: int.parse(offsetHrs), minutes: int.parse(offsetMins)));

        //set time property
        time = DateFormat.jm().format(now);

        isDayTime = (now.hour > 6 && now.hour < 20) ? true : false;

        break;
      }
      on FormatException {
        //print("FormatException");
        continue;
      }
      catch (e) {
        isDayTime = true;
        time = " ";
        location = "Could Not Get Time Data";
        break;
      }
    }
  }

}