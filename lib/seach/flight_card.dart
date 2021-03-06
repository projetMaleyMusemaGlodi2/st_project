import 'package:flights_app/seach/flight_model.dart';
import 'package:flights_app/seach/flights_details_screen.dart';
import 'package:flutter/material.dart';

class FlightCard extends StatelessWidget{
  final Flight flight;
  final String fullName;
  final bool isClickable;

  FlightCard({this.flight, this.fullName, @required this.isClickable});

  _cityStyle(cityName){
    return Expanded(
      child: Column(
        children: <Widget>[
          
          Text(cityName, style: TextStyle(fontSize: 18.0),),
          SizedBox(height: 10.0,),
          
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        isClickable?
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context)
                => FlightDetailScreen(
                  passengerName: fullName,
                  //flight: flight,
                )
            )
        ):null;
      },

      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical:20.0),
          //   child: ListView(
          //     children: <Widget>[
          //       Text(flight.agence, style: TextStyle(
          //     color: Colors.black,
          //     fontSize: 40.0,
          //     fontWeight: FontWeight.bold
          // ),),
          child:
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _cityStyle(flight.fromCity),
                    Icon(Icons.airplanemode_active),
                    _cityStyle(flight.toCity),
                  ],
                ),
            //     Text(flight.dateDepart, style: TextStyle(color: Colors.grey, fontSize: 14.0),)
            //   ],
            // ),
          ),
        ),
      ),
    );
  }

}