import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobseeker_app/widgets/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _controller = PageController();
  int currentpage = 0;

  final List<Map<String, String>> onboardingdata = [
    {
      "image": "assets/image/onboarding_1.png",
      "title": "Welcome to WorkScout",
      "description":
          "Discover your dream job with WorkScout. Whether You're seasoned professional or just starting your career, we connect you with the best oppurtunities tailored just for you"
    },
    {
      "image": "assets/image/onboarding_2.png",
      "title": "Personalized Job Matches",
      "description":
          "We Understand your unique skills and preferences. Our advanced algorithm ensure you receive job recommendations that match your profile perfectly."
    },
    {
      "image": "assets/image/onboarding_3.png",
      "title": "Stay Connected and Informed",
      "description":
          "Never miss an opportunity with real time notifications and updates. Stay ahead in your career with the latest job openings and industry insights."
    }
  ];
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorsApp.primarylight, // transparan biar nyatu
      statusBarIconBrightness:
          Brightness.dark, // ubah ke light/dark sesuai background
    ));
  }

  Widget _buildOnboardingPage(String image, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            color: ColorsApp.primarylight,
            child: Image.asset(
              image,
              height: 400,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: ColorsApp.primarylight,
      body: Padding(
        padding: EdgeInsets.only(bottom: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: PageView.builder(
              controller: _controller,
              itemCount: onboardingdata.length,
              onPageChanged: (index) {
                setState(() {
                  currentpage = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildOnboardingPage(
                  onboardingdata[index]["image"]!,
                  onboardingdata[index]["title"]!,
                  onboardingdata[index]["description"]!,
                );
              },
            )),
            SmoothPageIndicator(
              controller: _controller,
              count: onboardingdata.length,
              effect: ExpandingDotsEffect(
                dotColor: ColorsApp.primarylight,
                activeDotColor: ColorsApp.primarydark,
                dotWidth: 8,
                dotHeight: 8,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: ElevatedButton(
                  onPressed: () {
                    if (currentpage < onboardingdata.length - 1) {
                      _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease);
                    } else {
                      Navigator.pushReplacementNamed(context, "/landing");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsApp.primarydark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(90),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      minimumSize: Size(double.infinity, 60)),
                  child: Text(
                    currentpage == onboardingdata.length - 1
                        ? "Get Started"
                        : "Next",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Prompt",
                        fontWeight: FontWeight.w600,
                        color: ColorsApp.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
