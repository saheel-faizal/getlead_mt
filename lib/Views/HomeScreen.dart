import 'package:flutter/material.dart';
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
            Padding(
              padding: const EdgeInsets.all(15.0),
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

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: Colors.red[100],),
                        trailing: Text(list[index].createdDate,style: TextStyle(color: Colors.grey[700],letterSpacing: 0.5),),
                        subtitle:Text(list[index].vchrStatus.toString(),style: TextStyle(color: Colors.red[200]),),
                        title: Text(list[index].vchrCustomerName.toString(),style: TextStyle(letterSpacing: 0.5,
                        color: Color(0xFF021538)))),
                  ),
                );
              }),
          ],
        ),
      ),);
  }
}
