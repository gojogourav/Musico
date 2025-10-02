import 'package:flutter/material.dart';
import 'dart:ui' as ui; // Import the dart:ui library for ImageFilter

import 'package:musico/presentation/home/HomePage.dart'; // Make sure this path is correct

class BlurredNavbarPage extends StatefulWidget {
  const BlurredNavbarPage({super.key});

  @override
  State<BlurredNavbarPage> createState() => _BlurredNavbarPageState();
}

class _BlurredNavbarPageState extends State<BlurredNavbarPage> {
  int _selectedIndex = 0;

  // Your list of pages
  static final List<Widget> _pages = <Widget>[
    const Homepage(),
    _buildPageContent('Search Page'),
    _buildPageContent('Profile Page'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // This is still crucial
      body: Stack(
        children: [
          // Your main page content remains here
          _pages[_selectedIndex],

          // --- REPLACED GRADIENT WITH BLUR EFFECT ---
          Align(
            alignment: Alignment.bottomCenter,
            
            // ClipRRect is used to contain the blur effect and add rounded corners
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  // You must provide a partly transparent background for the blur to be visible
                  color: Colors.black,
                  height: 100, // Adjust the height of the blur area
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withAlpha(153),
      ),
    );
  }

  // Helper method to build scrollable content for demonstration
  static Widget _buildPageContent(String title) {
    return ListView.builder(
      // padding: const EdgeInsets.only(bottom: 150.0),
      itemCount: 50,
      itemBuilder: (context, index) => ListTile(
        title: Text(
          '$title - Item ${index + 1}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}