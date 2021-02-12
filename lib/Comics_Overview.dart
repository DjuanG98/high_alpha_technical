import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:high_alpha_technical/Comic_Model.dart';
import 'Comic_Detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final FirebaseAuth auth = FirebaseAuth.instance;
Future<ComicModel> comicModel;

int count;

Future<ComicModel> getComic() async{
  final response = await http.get(Uri.https('xkcd.com', 'info.0.json'));

  if (response.statusCode == 200){
    return ComicModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Comic');
  }
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ComicsOverview());
}



class ComicsOverview extends StatefulWidget {
  ComicsOverview({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ComicsOverview createState() => _ComicsOverview();

}

class _ComicsOverview extends State<ComicsOverview> {


  @override
  void initState() {
    super.initState();
    comicModel = getComic();
  }


  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).orientation == Orientation.landscape)
      count = 3;
    else
      count = 1;
    return new Scaffold(
      appBar: AppBar(
        title: Text("Comics Overview"),
        actions: <Widget>[
          Builder(builder: (BuildContext context){
            return TextButton(
              child: const Text('Sign Out',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                final User user = auth.currentUser;
                if (user == null){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('no user'),
                  ));
                  return;
                }
                await auth.signOut();
                Navigator.pop(context);
                final String uid = user.email;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(uid + ' has signed out'),
                )
                );
              },
            );
          }
          )
        ],
      ),
      body: FutureBuilder<ComicModel>(
            future: comicModel,
            builder: (context, snapshot){
              if (snapshot.hasData){
                return (GridView.builder(
                  shrinkWrap: true,
                    padding: const EdgeInsets.all(6.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: count,
                      childAspectRatio: count*1.5.toDouble(),
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5.0,
                          child: ListTile(
                            onTap: (){
                              showDialog(context: context, builder: (context) => ComicsDetail(detail:snapshot.data.alt , title:snapshot.data.safe_title, img: snapshot.data.img, month: snapshot.data.month, day: snapshot.data.day, year: snapshot.data.year, ),
                              );
                            },
                            title: Text(
                              snapshot.data.safe_title, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            ) ,
                            subtitle: Text(
                              snapshot.data.month + '/'  + snapshot.data.day + '/' + snapshot.data.year, style: TextStyle(fontSize: 15),
                            ),
                            leading: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 50,
                                minHeight: 50,
                                maxWidth: 500,
                                maxHeight: 500,
                              ),
                              child: Container(
                                child:  Image.network(
                                  snapshot.data.img, fit: BoxFit.cover,
                                ),
                              )
                            ),
                          ),
                      );
                    }
                )
                );
              }else if (snapshot.hasError){
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          )
      );
  }

}