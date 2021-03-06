import 'dart:async';
import 'dart:convert';
import 'package:flights_app/MyClasses/pub.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Commentaires extends StatefulWidget {
  final String refAlert;

  const Commentaires({Key key, this.refAlert}) : super(key: key);
  @override
  _CommentairesState createState() => _CommentairesState();
}

class _CommentairesState extends State<Commentaires> {
  TextEditingController cComment = new TextEditingController();
  Future addComment() async {
    var uri = Uri.parse(PubCon.cheminPhp + "insertDetailAlert.php");
    var request = new http.MultipartRequest("POST", uri);
    request.fields['refAgence'] = PubCon.userNomComplet;
    request.fields['refMessage'] = widget.refAlert.toString();
    request.fields['message'] = cComment.text;
    var response = await request.send();
    if (response.statusCode == 200) {
      cComment.clear();
      Fluttertoast.showToast(
          msg: 'Envoi réussi',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.white,
          textColor: Colors.blue);
      
      _charger();
    } else {
      print("Echec d'enregistrement");
    }
  }

  @override
  void initState() {
    super.initState();
    // _myPreferences.init().then((value){
    //   setState((){
    //     _myPreferences=value;

    //   });
    //   });
// listmemoview=[];
// listgetmemoview=[""];
// listmemonbre=[];
// listgetmemonbre=[""];
// listmemodetail=[];
// listgetmemodetail=[""];
    // _view=new List<String>();
    //_view=[""];

    _charger();
    //_view.sort();
  }

//connection to json// chargement des donnees
  //String _query = "";
  List<String> _username = [""];
  List<String> _date = [""];
  List<String> _detail = [""];
  Future<List> _charger() async {
    final response =
        await http.post(PubCon.cheminPhp + "GetDetailPublication.php", body: {
      "refMessage": widget.refAlert.toString(),
    });
    //print(response.body);
    var datauser = json.decode(response.body);
    if (datauser.length == 0) {
      setState(() {
        _username = ["Aucune Interaction"];
      });
    } else {
      _username.clear();
      _date.clear();
      _detail.clear();
      //clearItems();
      setState(() {
        for (int h = 0; h < datauser.length; h++) {
          _username.add(datauser[h]['refAgence'].toString());
          //addStrings(item,viewKey, listmemoview);
          _date.add(datauser[h]['date_det'].toString());
          //addStrings(nbre,nbreKey, listmemonbre);
          _detail.add(datauser[h]['message'].toString());
          //addStrings(detail,detailKey, listmemodetail);
        }
      });
    }
    return datauser;
  }

//create a list Widget
  Widget _createListView() {
    return new Flexible(
      child: new ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _username.length == null ? 0 : _username.length,
        itemBuilder: (BuildContext context, int index) {
          //return new Text(_view[index]);
          return new Column(
            //color: Colors.white12,
            children: <Widget>[
              Divider(),
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 5,
                      child: ListTile(
                        title: Text('${_username[index]}'),
                        subtitle:
                            Text('${_detail[index]} \n'),
                      )),
                ],
              ),
              Text("${_date[index]}"),
              Divider(),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: new Text('Commentaires',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.blue,
      ),

      //body here
      body: Column(
        children: <Widget>[
          Divider(),
          Container(
            color: Colors.white12,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: TextField(
                    focusNode: FocusNode(),
                    maxLines: 2,
                    controller: cComment,
                    decoration: new InputDecoration(
                        hintText: "Exprimez-vous ici",
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(20.0))),
                  ),
                ),
                Expanded(
                  child: new IconButton(
                    tooltip: 'Envoyer',
                    icon: Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      addComment();
                    },
                  ),
                )
              ],
            ),
          ),
          Divider(),
//Chargement des commentaires ici
          _createListView(),
        ],
      ),
    );
  }
}
