part of '../screen_lib.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  
  @override
  void initState() {
    LocationTracker().init().then((isEnable){
      if(isEnable){
        LocationTracker().startTracking(driverId:"RajuDriver");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    LocationTracker().dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FirebaseStreamBuilder(
          path: "drivers/RajuDriver/location",
          builder: (context,event){
            return Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 10),
              child: Text("${(event.snapshot.value)}"),
            )
            );
          }
      ),
    );
  }
}

