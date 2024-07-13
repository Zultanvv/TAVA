import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projek_ta_smarthome/login.dart';
import 'package:projek_ta_smarthome/voice.dart';
import 'firebase_options.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    VoiceControlScreen(),
    InfoScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            SnackBar snackbar = SnackBar(content: Text(val.recognizedWords));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }
          // setState(() {
            
          //   _text = val.recognizedWords;
          // }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: _navigateToProfile,
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none),),
      backgroundColor: Colors.blue[200],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'VOICE',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'INFO',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool var1 = false;
  String var1Status = "OFF";
  bool var2 = false;
  String var2Status = "OFF";
  bool var3 = false;
  String var3Status = "OFF";
  bool var4 = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(65.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.person, size: 100),
              Text('HI USER!', style: TextStyle(fontSize: 20)),
              Text("")
            ],
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    setState(() {
                      var1 = !var1;
                      if (var1Status == "OFF") {
                        var1Status = "ON";
                      } else {
                        var1Status = "OFF";
                      }
                    });
                  },
                  child: ControlButton(
                    title: 'Lampu Ruang Tamu',
                    status: var1Status,
                    color: Colors.green,
                    icon: const Icon(
                      Icons.lightbulb,
                      size: 80,
                    ),
                    onOff: var1,
                  )),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      var2 = !var2;
                      if (var2Status == "OFF") {
                        var2Status = "ON";
                      } else {
                        var2Status = "OFF";
                      }
                    });
                  },
                  child: ControlButton(
                      title: 'Lampu Ruang Keluarga',
                      status: var2Status,
                      color: Colors.red,
                      icon: const Icon(
                        Icons.lightbulb,
                        size: 80,
                      ),
                      onOff: var2)),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      var3 = !var3;
                      if (var3Status == "OFF") {
                        var3Status = "ON";
                      } else {
                        var3Status = "OFF";
                      }
                    });
                  },
                  child: ControlButton(
                      title: 'Kipas Angin',
                      status: var3Status,
                      color: Colors.blue,
                      icon: const Icon(
                        Icons.wind_power_outlined,
                        size: 80,
                      ),
                      onOff: var3)),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      var4 = !var4;
                    });
                  },
                  child: ControlButton(
                      title: 'Temperature Suhu',
                      status: '19°C',
                      color: Color.fromARGB(255, 233, 214, 44),
                      icon: const Icon(
                        Icons.wb_sunny_rounded,
                        size: 80,
                      ),
                      onOff: var4)),
            ],
          ),
        ),
      ],
    );
  }
}

class ControlButton extends StatelessWidget {
  final String title;
  final String status;
  final Color color;
  final Icon icon;
  final bool onOff;

  ControlButton(
      {required this.title,
      required this.status,
      required this.color,
      required this.icon,
      required this.onOff});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                        height: 30,
                        width: 30,
                        color: onOff ? Colors.white : Colors.black,
                        child: Icon(
                          Icons.power_settings_new_outlined,
                          color: onOff ? Colors.green : Colors.white,
                          size: 30,
                        )))
              ],
            ),
          ),
          icon,
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue),
        ),
        child: Text(
          'Pemanfaatan kecerdasan buatan, terutama melalui aplikasi berbasis Android, menjadi suatu terobosan yang signifikan dalam mengimplementasikan teknologi Speech Recognition di dalam lingkungan Smart Home. Sistem Aplikasi AI berbasis Android untuk implementasi Speech Recognition dalam bidang IoT Smart Home memberikan solusi inovatif dalam mengintegrasikan perangkat-perangkat yang ada di rumah menjadi suatu ekosistem pintar yang dapat dioperasikan dengan menggunakan suara. Dengan memanfaatkan teknologi ini, pengguna dapat mengontrol perangkat secara verbal di Rumah Pintar, sehingga meningkatkan kenyamanan dan interaksi pengguna.',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}



class ProfileScreen extends StatelessWidget {
  void _logout(BuildContext context) {
    // Implement your logout logic here (e.g., Firebase sign out)
    // After logging out, navigate back to the login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
