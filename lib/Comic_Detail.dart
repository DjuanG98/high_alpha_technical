import 'package:flutter/material.dart';

class ComicsDetail extends StatefulWidget {
  final String detail, title, alt, img, month, day, year;
  ComicsDetail({Key key, this.detail, this.title, this.img, this.alt, this.month, this.day, this.year}) : super(key: key);
  _ComicsDetail createState() => _ComicsDetail();

}

class _ComicsDetail extends State<ComicsDetail> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
  contentBox(context){
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10.0,top: 5.0
              + 5.0, right: 10.0 ,bottom: 20.0
          ),
          margin: EdgeInsets.only(top: 5.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular (20),
            boxShadow: [
              BoxShadow(color: Colors.black,offset: Offset(0,10),
              blurRadius: 10
              ),
            ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close),
                ),
              ),
              ListTile(
                title: (Text(widget.title + '\n' + widget.month + '/'  + widget.day + '/' + widget.year, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, height: 1.7))),
                subtitle: (Text(widget.detail, style: TextStyle(fontSize: 15, height: 1.5),)),
                leading: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 70,
                    minHeight: 70,
                    maxWidth: 500,
                    maxHeight: 500,
                  ),
                  child: Image.network(
                      widget.img, fit: BoxFit.fill,
                  ),
                ),
              ),
              ],
          ),
        ),
      ],
    );
  }
}




