import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(ApiApp());
}

class ApiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PostScreen(),
    );
  }
}

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _post;

  Future<void> fetchRandomPost() async {
    setState(() {
      _isLoading = true;
      _post = null;
    });

    int postId = Random().nextInt(100) + 1; // Random ID between 1-100
    final url = Uri.parse("https://jsonplaceholder.typicode.com/posts/$postId");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _post = json.decode(response.body);
        });
      } else {
        throw Exception("Failed to load post");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRandomPost(); // Automatically fetch on start
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Random Post")),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _post != null
            ? Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _post!['title'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                _post!['body'],
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchRandomPost,
                child: Text("Fetch Another Post"),
              )
            ],
          ),
        )
            : Text("No post found."),
      ),
    );
  }
}
