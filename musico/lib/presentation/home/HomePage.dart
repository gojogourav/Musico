import 'package:flutter/material.dart';
import 'package:musico/core/assets/app_vectors.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "👋 Hi Gourav,",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        "Good Afternoon",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),

                  Spacer(),
                  const Row(
                    children: [
                      Icon(
                        Icons.notifications,
                        size: 28,
                        color: Color.fromARGB(99, 255, 255, 255),
                      ),
                      SizedBox(width: 16),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 40.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              HorizontalButtons(),
              SizedBox(height: 20),
              Text("Featuring Today", style: TextStyle(fontSize: 28)),
              SizedBox(height: 20),
              const _HorizontalBanners(),
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontalButtons extends StatefulWidget {
  const HorizontalButtons({super.key});

  @override
  State<HorizontalButtons> createState() => _HorizontalButtonsState();
}

class _HorizontalButtonsState extends State<HorizontalButtons> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      'All',
      'Music',
      'Podcasts',
      'Gaming',
      'Sports',
      'News',
      'Live',
      'Comedy',
      'Technology',
      'Fashion',
    ];

    return SizedBox(
      height: 45.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final bool isSelected = _selectedIndex == index;

          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isSelected
                  ? const Color.fromARGB(54, 158, 158, 158)
                  : Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              elevation: 0,
            ),
            onPressed: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Text(
              categories[index],
              style: TextStyle(
                color: const Color.fromARGB(111, 255, 255, 255),
                fontSize: 16,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BannerItem {
  final String imageUrl;
  final String title;
  final String? subtitle;
  final String? title2;

  const _BannerItem({
    required this.imageUrl,
    required this.title,
    this.title2,
    this.subtitle,
  });
}

class _HorizontalBanners extends StatefulWidget {
  const _HorizontalBanners({super.key});

  @override
  State<_HorizontalBanners> createState() => _HorizontalBannersState();
}

class _HorizontalBannersState extends State<_HorizontalBanners> {
  @override
  Widget build(BuildContext context) {
    final List<_BannerItem> bannerImages = [
      const _BannerItem(
        imageUrl: AppVectors.banner,
        subtitle: "New",
        title: "English",
        title2: "Songs",
      ),
      const _BannerItem(
        imageUrl: AppVectors.banner,
        title: 'Live Now',
        subtitle: 'Gaming Stream',
      ),
    ];

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: bannerImages.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 300,
            height: 150,
            child: Stack(
              children: [
                Image.asset(bannerImages[index].imageUrl, fit: BoxFit.cover),

                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("New", style: TextStyle(fontSize: 16)),
                      Text("English", style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
                      Text("Songs",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
