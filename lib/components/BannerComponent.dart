import 'package:flutter/material.dart';
import 'dart:async';

class BannerComponent extends StatefulWidget {
  const BannerComponent({super.key});

  @override
  _BannerComponentState createState() => _BannerComponentState();
}

class _BannerComponentState extends State<BannerComponent> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _images = [
    'assets/images/educacionbanner1.jpeg',
    'assets/images/educacionbanner2.jpeg',
    'assets/images/educacionbanner3.jpeg',
  ];

  final List<String> _titles = [
    "Bienvenido a Educación",
    "Explora Nuestros Cursos",
    "Únete a Nuestra Comunidad",
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500), // Más suave
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Image.asset(
                      _images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black54,
                            Colors.black26,
                            Colors.transparent
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 20,
                      child: Text(
                        _titles[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _images.map((image) {
                  int index = _images.indexOf(image);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    width: _currentPage == index ? 16.0 : 10.0,
                    height: _currentPage == index ? 16.0 : 10.0,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.blueAccent
                          : Colors.grey[400],
                      shape: BoxShape.circle,
                    ),
                    child: AnimatedScale(
                      scale: _currentPage == index ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(),
                    ),
                  );
                }).toList(),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  setState(() {
                    if (_currentPage > 0) {
                      _currentPage--;
                    } else {
                      _currentPage = _images.length - 1;
                    }
                    _pageController.animateToPage(
                      _currentPage,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  });
                },
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onPressed: () {
                  setState(() {
                    if (_currentPage < _images.length - 1) {
                      _currentPage++;
                    } else {
                      _currentPage = 0;
                    }
                    _pageController.animateToPage(
                      _currentPage,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
