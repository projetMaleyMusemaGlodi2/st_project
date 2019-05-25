import 'package:flights_app/MyClasses/clsCritereSelect.dart';
import 'package:flights_app/MyClasses/components.dart';
import 'package:flights_app/MyDesigns/DialogComponents/lieu_to_select.dart';
import 'package:flights_app/MyDesigns/res_aller_simple.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CritereAller extends StatefulWidget {
  @override
  CritereAllerState createState() {
    return new CritereAllerState();
  }
}

class CritereAllerState extends State<CritereAller>
    with TickerProviderStateMixin {
  AnimationController textInputAnimationController;
TextEditingController depart=new TextEditingController(),
arrive=new TextEditingController(),
datedep=new TextEditingController()
;
final f=new DateFormat('yyyy-MM-dd');
DateTime date=DateTime.now();
// void getData(){
//   CritereSelect.arrive=arrive.text;
//   CritereSelect.depart=depart.text;
//   CritereSelect.datedep=f.format(date).toString();

// }
Future<Null> _selectDate(BuildContext context) async{
  final DateTime picked = await
  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2099),

                  );
                  setState(() {
                   date =picked;
                   CritereSelect.datedep=date==null? '':f.format(date).toString();
                  });
}

  @override
  void initState() {
    super.initState();
    //textInputAnimationController = new AnimationController(
       // vsync: this, duration: Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    textInputAnimationController.dispose();
    super.dispose();
  }
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
              autovalidate: _autoValidate,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 64.0, 8.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.arrow_right,color: Colors.blueAccent,),
                  Componentss.iconaddcons(context),
                  
                  
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        maxLines: 2,
                        controller: depart,
                        decoration: InputDecoration(
                          //icon:Componentss.iconaddcons(context),
                          //labelText: "Depart",
                          hintText: 'Depart:\n'+CritereSelect.depart.toString()
                        ),
                        onTap: (){
                          CritereSelect.est_Depart_Ou_Arrive=1;
                          showMyDialog("Depart");
                          
                        },
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 64.0, 8.0),
              child: Row(
                children: <Widget>[
                  Componentss.iconaddcons(context),
                  Icon(Icons.arrow_right,color: Colors.blueAccent,),
                  Expanded(
                    child:  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          
                          maxLines: 2,
                          controller: arrive,
                          decoration: InputDecoration(
                            // icon:Componentss.iconaddcons(context),
                            //labelText: "Destination",
                            hintText: 'destination:\n ${CritereSelect.arrive}'
                          ),
                          onTap: () {
                       CritereSelect.est_Depart_Ou_Arrive=2;
                            showMyDialog('Destination');}
                          ),
                    ),
                        
                    
                  ),
                  
                ],
              ),
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Icon(Icons.date_range, color: Colors.blue),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 16.0),
                                      child: TextField(
                                         maxLines: 2,
                                       controller: datedep,
                                       decoration: InputDecoration(
                                         //icon: Icon(Icons.date_range,color: Colors.grey,),
                                         hintText: 'Date Depart :\n'+(date==null? '':f.format(date).toString()),
                                         
                                       ),
                                       onTap:(){_selectDate(context);
                                  
                                       },
                                      ),
                                    ),
                                  ),
                                  // Expanded(
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.only(left: 16.0),
                                  //     child: TypeableTextFormField(
                                  //       animation: _buildInputAnimation(begin: 0.75, end: 0.95),
                                  //       finalText: "29 July 2017",
                                  //       decoration: InputDecoration(labelText: "Arrival"),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              //Expanded(child: Container()),
                              
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
                            child: FloatingActionButton(
                              onPressed: () {
                                _validateInputs();
                                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                                //     builder: (BuildContext context) =>
                                //         FlightListScreen(fullName: nameController.text,catEngin:CritereSelect.refCatEngin,arrive:CritereSelect.arrive,depart: CritereSelect.depart,datedep: CritereSelect.datedep,)));
                                
                              },
                              child: Icon(Icons.timeline, size: 36.0),
                            ),
                          ),
                          TextFormField(
                                
                                maxLines: 1,
                        validator: validateDestination,
                      onSaved: (String val) {
                        //_password = val;
                      },
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  
                    void showMyDialog(String title) {
                      showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                          title: new Text("$title",textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blue,
                              )),
                          content:
                              new Container(
                                  height: MediaQuery.of(context).size.height, 
                                  width: MediaQuery.of(context).size.width,
                                  child: LieuSelect()),
                           
                        ));
                    }
// bool _value1 = false;
  bool _autoValidate = false;
 void _validateInputs() {
    if (_formKey.currentState.validate()) {
      //    If all data are correct then save data to out variables
      _formKey.currentState.save();
      //save user in the database
      CritereSelect.course=1;
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        GetHoraireAller()));
    } else {
      //    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }



    String validateDestination(String value) {
    if (CritereSelect.arrive==CritereSelect.depart)
      return 'la destination doit être différente du depart';
    else if (DateTime.parse(CritereSelect.datedep).isBefore(DateTime.now()))
    return 'Cette date est déjà passée';
    else
      return null;
  }

}
