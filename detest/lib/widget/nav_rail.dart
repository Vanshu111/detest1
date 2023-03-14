//
import 'package:detest/configure/configure_camra.dart';
import 'package:detest/configure/configure_image.dart';
import 'package:detest/configure/configure_job.dart';
import 'package:detest/configure/configure_rana.dart';
import 'package:detest/constant.dart';
import 'package:flutter/material.dart';

class ConfigScreen extends StatefulWidget {
  final String deviceId;
  final String userName;
  const ConfigScreen(
      {super.key, required this.deviceId, required this.userName});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  int _selectedIndex = 3;

  bool isExpanded = false;
  NavigationRailLabelType labelType = NavigationRailLabelType.selected;
  Widget screens(int index) {
    switch (index) {
      case 0:
        {
          return ConfigureJob(deviceId: widget.deviceId);
        }
      case 1:
        {
          return ConfigureCamera(deviceId: widget.deviceId);
        }
      case 2:
        {
          return ConfigureRana(deviceId: widget.deviceId);
        }
      default:
        return ConfigureImage(
          deviceId: widget.deviceId,
          userName: widget.userName,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.menu),
        elevation: 0,
        centerTitle: true,
        backgroundColor: buttonColor,
        title: const Text('C O N F I G U R E',
            style: TextStyle(
              fontSize: 25,
              color: backgroundColor,
              fontWeight: FontWeight.w900,
            )),
      ),
      body: SafeArea(
        child: Row(
          children: [
            Stack(
              children: [
                NavigationRail(
                  useIndicator: true,
                  indicatorColor: Colors.amber,
                  groupAlignment: -0.75,
                  extended: isExpanded,
                  backgroundColor: buttonColor,
                  unselectedIconTheme:
                      const IconThemeData(color: Colors.black, opacity: 0.5),
                  selectedIconTheme:
                      const IconThemeData(color: borderColor, opacity: 1),
                  unselectedLabelTextStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  selectedLabelTextStyle:
                      const TextStyle(color: backgroundColor),
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: isExpanded
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.all,
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(
                      padding: EdgeInsets.all(8),
                      icon: Icon(Icons.work),
                      label: Text('J O B'),
                    ),
                    NavigationRailDestination(
                      padding: EdgeInsets.all(8),
                      icon: Icon(Icons.camera),
                      label: Text('C A M E R A'),
                    ),
                    NavigationRailDestination(
                      padding: EdgeInsets.all(8),
                      icon: Icon(Icons.computer),
                      label: Text('R A N A'),
                    ),
                    NavigationRailDestination(
                      padding: EdgeInsets.all(8),
                      icon: Icon(Icons.image),
                      label: Text('I M A G E'),
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                ),
                Positioned(
                  right: 15,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: FloatingActionButton.extended(
                        backgroundColor: borderColor,
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        label: !isExpanded
                            ? const Icon(Icons.menu)
                            : const Icon(Icons.arrow_back)),
                  ),
                )
              ],
            ),
            Expanded(
              // child: screens(_selectedIndex),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [screens(_selectedIndex)],
              ),
            )
          ],
        ),
      ),
    );
  }
}


  // boxShadow: _selectedIndex == current
        //     ? const [
        //         BoxShadow(
        //           color: borderColor,
        //           offset: Offset(2.0, 2.0), //(x,y)
        //           blurRadius: 6.0,
        //         ),
        //       ]
        //     : [],