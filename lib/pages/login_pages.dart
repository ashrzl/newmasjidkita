import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_mk_v3/pages/home_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _passwordVisible = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials(); // Load saved credentials on screen load
  }

  // Function to load saved credentials
  void _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('UserName');
    String? savedPassword = prefs.getString('Password');
    bool? rememberMe = prefs.getBool('rememberMe');

    if (mounted) {
      setState(() {
        if (savedUsername != null && savedPassword != null && rememberMe == true) {
          _usernameController.text = savedUsername;
          _passwordController.text = savedPassword;
          _rememberMe = rememberMe!;
        }
      });
    }
  }

  // Function to save credentials
  void _saveCredentials(String UserName, String Password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('UserName', UserName);
      await prefs.setString('Password', Password);
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.remove('UserName');
      await prefs.remove('Password');
      await prefs.setBool('rememberMe', false);
    }
  }

  // Login function
  Future<void> login(String UserName, String password) async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      final response = await http.post(
        Uri.parse('https://api.cmsb-env2.com.my/api/Authentication/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'UserName': UserName, 'password': password}),
      );

      setState(() {
        isLoading = false; // Hide loading indicator
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Response data: $data');

        String? token = data['data']['Token'];
        int? userIdFromApi = data['data']['UserID'];
        String? userNameFromApi = data['data']['UserName'];

        if (token != null && userIdFromApi != null && userNameFromApi != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('Token', token);
          await prefs.setString('UserName', userNameFromApi);
          await prefs.setString('UserId', userIdFromApi.toString());

          // Log the stored values for debugging
          print('Token stored: $token');
          print('UserName stored: $userNameFromApi');
          print('UserId stored: ${userIdFromApi.toString()}');
          print('Token after stored: $token');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content:
            Text('Log Masuk Berjaya'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to the home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          print('Invalid response data: token or user ID is null');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: Invalid response')),
          );
        }
      } else {
        // Handle different status codes appropriately
        String errorMessage = 'Nama Pengguna atau Katalaluan salah!';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content:
          Text(errorMessage,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
            backgroundColor: Colors.red,
          ),
        );
        print('Login failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
      print('Error during login: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }

  Future<void> saveToken(String token) async {
    // Save the token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', '$token');  // Replace 'your-token' with the actual token value
    print('Token stored: $token');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Log Masuk',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        backgroundColor: const Color(0xFF990099),
        elevation: 22,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 70),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Nama Pengguna',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Sila masukkan Nama Pengguna';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Katalaluan',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Sila masukkan Katalaluan';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text('Remember Me'),
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: isLoading // Disable button if loading
                      ? null
                      : () {
                    if (_formKey.currentState?.validate() ?? false) {
                      String UserName = _usernameController.text;
                      String Password = _passwordController.text;
                      login(UserName, Password);
                      _saveCredentials(UserName, Password);
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Log Masuk',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF990099),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                // Or Divider
                // Row(
                //   children: [
                //     Expanded(child: Divider(color: Colors.black26)),
                //     Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //       child: Text('Atau Log Masuk'),
                //     ),
                //     Expanded(child: Divider(color: Colors.black26)),
                //   ],
                // ),
                SizedBox(height: 30.0),
                // Google Sign In Button (Placeholder)
                // IconButton(
                //   onPressed: () {
                //     // Implement Google Sign-In feature here
                //   },
                //   icon: Image.asset(
                //     'assets/google.png',
                //     height: 50,
                //   ), // Update with your logo path
                // ),
                const SizedBox(height: 30),
                // Align(
                //   alignment: Alignment.center,
                //   child: RichText(
                //     text: TextSpan(
                //       text: 'Belum ada akaun? ',
                //       style: TextStyle(color: Colors.black54),
                //       children: <TextSpan>[
                //         TextSpan(
                //           text: 'Daftar',
                //           style: TextStyle(color: Colors.blue),
                //           recognizer: TapGestureRecognizer()
                //             ..onTap = () {
                //               // Implement your registration link
                //             },
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}