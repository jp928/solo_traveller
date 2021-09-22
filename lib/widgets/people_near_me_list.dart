import 'package:flutter/material.dart';
import 'package:solo_traveller/futures/get_people_near_me_future.dart';
import 'package:solo_traveller/models/person.dart';
import 'package:solo_traveller/screens/people_profile_screen.dart';
import 'package:solo_traveller/widgets/photo_hero.dart';

class PeopleNearMeList extends StatefulWidget {
  @override
  _MomentListState createState() => _MomentListState();
}

class _MomentListState extends State<PeopleNearMeList> {
  var _people = <Person>[];
  bool loading = false;
  late ScrollController _scrollController;

  String _chosenDistance = '2000';

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        int pageNum = (_people.length / 20).ceil() + 1;
        _retrievePeople(pageNum);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    // Retrieve first
    _retrievePeople(1, isRefresh: true);

    _scrollController = new ScrollController(initialScrollOffset: 5.0);
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _retrievePeople(int pageNum, {bool isRefresh = false}) async {
    var _newPeople =
        await getPeopleNearMe(pageNum: pageNum, distance: _chosenDistance);
    setState(() {
      if (isRefresh) {
        _people = _newPeople;
      } else {
        _people.insertAll(_people.length, _newPeople);
      }

      if (loading) {
        loading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SafeArea(
            top: false,
            child: Container(
              alignment: Alignment.center,
              child: Column(children: <Widget>[
                Container(
                  width: 150,
                  padding: const EdgeInsets.all(0.0),
                  child: DropdownButton<String>(
                    value: _chosenDistance,
                    isExpanded: true,
                    elevation: 5,
                    style: TextStyle(color: Colors.black),
                    items: <Map<String, String>>[
                      {'key': '2 KM', 'value': '2000'},
                      {'key': '5 KM', 'value': '5000'},
                      {'key': '10 KM', 'value': '10000'},
                      {'key': '20 KM', 'value': '20000'},
                      {'key': '50 KM', 'value': '50000'},
                      {'key': '100 KM', 'value': '100000'},
                    ].map<DropdownMenuItem<String>>((Map<String, String> item) {
                      return DropdownMenuItem<String>(
                        value: item['value'],
                        child: Text(item['key']!),
                      );
                    }).toList(),
                    hint: Text(
                      'Please choose a distance from you',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        _people = [];
                        loading = true;
                        _chosenDistance = value;
                      });

                      _retrievePeople(1, isRefresh: true);
                    },
                  ),
                ),
                Expanded(
                  child: _people.length == 0
                      ? Center(
                          child: Column(
                            children: [
                              Padding(padding: EdgeInsets.only(top: 32)),
                              loading
                                  ? new CircularProgressIndicator()
                                  : IconButton(
                                      icon: const Icon(Icons.refresh_outlined),
                                      tooltip: 'Refresh',
                                      onPressed: () {
                                        _retrievePeople(1, isRefresh: true);
                                      },
                                    )
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          child: GridView.builder(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            itemCount: _people.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  MediaQuery.of(context).orientation ==
                                          Orientation.landscape
                                      ? 3
                                      : 2,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 8,
                              childAspectRatio: 1,
                            ),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              Person person = _people[index];

                              return GestureDetector(
                                onTap: () {
                                  // Navigator.of(context).pushNamed(RouteName.GridViewCustom);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height:
                                      MediaQuery.of(context).size.width / 2 -
                                          40,
                                  margin: EdgeInsets.only(top: 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          width: 96,
                                          height: 96,
                                          child: PhotoHero(
                                            photo: person.profileImage,
                                            id: person.id.toString(),
                                            width: 96,
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  new MaterialPageRoute(
                                                    builder: (context) =>
                                                    new PeopleProfileScreen(),

                                                    settings: RouteSettings(
                                                      arguments: person,
                                                    ),
                                                  )
                                              );
                                            },
                                          )
                                      ),
                                      Text(
                                          '${person.firstName ?? 'Anonymous'} ${person.lastName ?? ''}'),
                                      Divider(
                                        height: 0.5,
                                        thickness: 0.5,
                                        indent: 0,
                                        endIndent: 0,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          onRefresh: () async {
                            await _retrievePeople(1, isRefresh: true);
                          },
                        ),
                ),
              ]),
            )),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
