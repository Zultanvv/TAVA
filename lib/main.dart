import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projek_ta_smarthome/login.dart';
import 'package:projek_ta_smarthome/voice.dart';
import 'firebase_options.dart';

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
    ProfileScreen(),
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
        title: const Text('Smart Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _navigateToProfile,
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      ),
      backgroundColor: Colors.blue[100],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HOME',
          ),
            BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'VOICE',
          ),
          const BottomNavigationBarItem(
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
    return Scaffold(
    body: SafeArea(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Colors.blue[100],
          width: double.infinity,
          padding: const EdgeInsets.all(65.0),
          child: const Column(
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
                    var1Status = var1 ? "ON" : "OFF";
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
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    var2 = !var2;
                    var2Status = var2 ? "ON" : "OFF";
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
                  onOff: var2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    var3 = !var3;
                    var3Status = var3 ? "ON" : "OFF";
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
                  onOff: var3,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    var4 = !var4;
                  });
                },
                child: ControlButton(
                  title: 'Temperature Suhu',
                  status: '19°C',
                  color: const Color.fromARGB(255, 233, 214, 44),
                  icon: const Icon(
                    Icons.wb_sunny_rounded,
                    size: 80,
                  ),
                  onOff: var4,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    ),
    );
  }
}

class ControlButton extends StatelessWidget {
  final String title;
  final String status;
  final Color color;
  final Icon icon;
  final bool onOff;

  
  

  ControlButton({
    required this.title,
    required this.status,
    required this.color,
    required this.icon,
    required this.onOff,
  });

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
                  style: const TextStyle(color: Colors.white, fontSize: 16),
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
                    ),
                  ),
                ),
              ],
            ),
          ),
          icon,
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 5,
          ),
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue),
        ),
        child: const Text(
          'Pemanfaatan kecerdasan buatan, terutama melalui aplikasi berbasis Android, menjadi suatu terobosan yang signifikan dalam mengimplementasikan teknologi Speech Recognition di dalam lingkungan Smart Home. Sistem Aplikasi AI berbasis Android untuk implementasi Speech Recognition dalam bidang IoT Smart Home memberikan solusi inovatif dalam mengintegrasikan perangkat-perangkat yang ada di rumah menjadi suatu ekosistem pintar yang dapat dioperasikan dengan menggunakan suara. Dengan memanfaatkan teknologi ini, pengguna dapat mengontrol perangkat secara verbal di Rumah Pintar, sehingga meningkatkan kenyamanan dan interaksi pengguna.',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _saveNewPassword() async {
    try{
      if (_formKey.currentState!.validate()) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.updatePassword(_newPasswordController.text);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password changed successfully!')),
          );
          
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user is currently signed in.')),
          );
        }

        

        // await user?.updatePassword(_newPasswordController.text);
        // // Implement password change logic here
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully!')),
        );
      }
    } catch(e){
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password changed error! $e')),
      );
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
     
  }
   
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'User',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                
                const SizedBox(height: 0),
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: true,
                   decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blue,
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                 
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                   decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blue,
                          labelText: 'New Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'New Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                   decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blue,
                          labelText: 'Confirm Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm Password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Password tidak cocok';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
    backgroundColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
  ),
  onPressed: () async {
    // Show confirmation dialog
    bool shouldSave = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah Anda ingin menyimpan perubahan?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);  // Return false
              },
              child: Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);  // Return true
              },
              child: Text('Ya'),
            ),
          ],
        );
      },
    );

    if (shouldSave == true) {
      // Proceed with saving if the user confirms
      await _saveNewPassword();  // Panggil fungsi dan tunggu hingga selesai
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
        (Route<dynamic> route) => false,
      );
    }
  },
  child: const Text(
    'Simpan',
    style: TextStyle(color: Colors.white),
  ),
),

                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Konfirmasi'),
                          content: const Text('Apakah Anda ingin keluar?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Tutup dialog
                              },
                              child: const Text('Tidak'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Tutup dialog
                                _logout(context); // Lakukan logout
                              },
                              child: const Text('Ya'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
