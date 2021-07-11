import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:getlead_mt/Model/ContactsModel.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pull_to_refresh/src/smart_refresher.dart';
import 'package:http/http.dart'as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage=1;
  int totalPages;
  String res;

  List<Data> datas=[];
  List<Datum> list=[];

  String token="Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvYXBwLmdldGxlYWQuY28udWtcL2FwaVwvYWdlbnQtYXBwXC9sb2dpbiIsImlhdCI6MTYyMTA3MjE4NSwibmJmIjoxNjIxMDcyMTg1LCJqdGkiOiJtR2ZmTzB4YVJZbzJKaFpaIiwic3ViIjo1NjYsInBydiI6Ijg3ZTBhZjFlZjlmZDE1ODEyZmRlYzk3MTUzYTE0ZTBiMDQ3NTQ2YWEifQ.GezFkm4kHE2nsNnXx22EQcQmvhVQGzVjcu1Bv1bINCQ";

  final RefreshController refreshController =
  RefreshController(initialRefresh: true);


  Future<bool> getPassengerData({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage=1;
    } else {
      if (currentPage >= totalPages) {
        refreshController.loadNoData();
        return false;
      }
    }

    var url="https://demo1.getlead.co.uk/api/agent-app/dashboard-tasks?page=$currentPage";

    final response = await http.post(url,
        headers: {"Authorization":token},
    body: {
      "page":"$currentPage"
    });

    if (response.statusCode == 200) {
      final result = contactModelFromJson(response.body);

      if (isRefresh) {

        datas = result.data.data.cast<Data>();
      }else{
        datas.addAll([]);
      }
      result.data.data.forEach((element) {
        list.add(element);
      });

      // list=result.data.data;



      totalPages = result.data.lastPage;

      print(response.body);
      res=response.body;
      print(totalPages.toString());
      setState(() {
        currentPage++;
      });
      return true;
    } else {
      return false;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPassengerData(isRefresh: true);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,


        onRefresh: () async {
          final result = await getPassengerData(isRefresh: true);
          if (result) {
            // setState(() {
            //   currentPage++;
            //
            // });
            // getPassengerData();
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result = await getPassengerData();
          if (result) {
            // setState(() {
            //   currentPage++;
            //
            // });
            // getPassengerData();
            refreshController.loadComplete();
          } else {
            refreshController.loadFailed();
          }
        },
        child: ListView(
          shrinkWrap: true,
          children: [

            SizedBox(height: MediaQuery.of(context).size.height*0.08,),
            Padding(padding: const EdgeInsets.only(left: 25.0),
              child: Text("Pending Tasks",style: TextStyle(
                  fontSize: 20,
                  color: Colors.blueGrey[600]),
              ),
            ),


            ListView.builder(
              physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: list.length,
              itemBuilder: (context,index){

                return list[index].vchrCustomerName=="No Customer Name"?Container():Padding(
                  padding: const EdgeInsets.only(left: 25.0,right: 25,bottom: 10),
                  child: Card(
                    elevation: 0.001,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                    child: ListTile(
                      leading:
                      (list[index].vchrStatus=="Lost Lead")?
                      CircleAvatar(backgroundColor: Colors.blue[200]):
                      (list[index].vchrStatus=="New Enquiry")?
                      CircleAvatar(backgroundColor: Colors.blue[200]):
                      (list[index].vchrStatus=="Call Back")?
                      CircleAvatar(backgroundColor: Colors.yellow[200]):
                      (list[index].vchrStatus=="Interested")?
                      CircleAvatar(backgroundColor: Colors.blue[200]):
                      (list[index].vchrStatus=="Contacted")?
                      CircleAvatar(backgroundColor: Colors.blue[200]):
                      (list[index].vchrStatus=="New")?
                      CircleAvatar(backgroundColor: Colors.yellow[200]):
                        (list[index].vchrStatus=="Call back Later")?
                      CircleAvatar(backgroundColor: Colors.yellow[200])
                          :(list[index].vchrStatus=="Call Back")?
                      CircleAvatar(backgroundColor: Colors.yellow[200])
                          :CircleAvatar(backgroundColor: Colors.red[200]),
                        trailing: Text(list[index].createdDate.toString(),style: TextStyle(color: Colors.grey,letterSpacing: 0.5),),
                        // subtitle:Text(list[index].vchrStatus.toString(),style: TextStyle(color: Colors.red[200]),),
                        subtitle:
                        (list[index].vchrStatus=="Lost Lead")?
                        Text(list[index].vchrStatus.toString(),
                            style: TextStyle(color: Color(0xFF457DAA))):
                        (list[index].vchrStatus=="New Enquiry")?
                        Text(list[index].vchrStatus.toString(),
                            style: TextStyle(color: Color(0xFF457DAA))):
                        (list[index].vchrStatus=="Contacted")?
                        Text(list[index].vchrStatus.toString(),
                            style: TextStyle(color: Color(0xFF457DAA))):
                        (list[index].vchrStatus=="Interested")?
                        Text(list[index].vchrStatus.toString(),
                            style: TextStyle(color: Color(0xFF457DAA))):
                          (list[index].vchrStatus=="Call back Later")?
                        Text(list[index].vchrStatus.toString(),
                            style: TextStyle(color: Color(0xFFE0C15A))):
                          (list[index].vchrStatus=="New")?
                        Text(list[index].vchrStatus.toString(),
                            style: TextStyle(color: Color(0xFFE0C15A)))
                            :(list[index].vchrStatus=="Call Back")?
                        Text(list[index].vchrStatus.toString(),style: TextStyle(
                          color: Color(0xFFE0C15A),)
                        )
                            :Text(list[index].vchrStatus.toString(),style:TextStyle(
                            color: Colors.red[200],)),
                        title: Text(list[index].vchrCustomerName.toString(),style: GoogleFonts.openSans(

                            color: Colors.blueGrey[600],
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w600),
                        )
                    ),
                  ),
                );
              }),
            // Color(0xFF021538)

          ],
        ),
      ),);
  }
}

