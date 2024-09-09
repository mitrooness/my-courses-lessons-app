import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preparia_ma/pages/dashboard_page.dart';
import '../api_service.dart';
import '../models/course.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _widgetList = [
    DashboardPage(),
    DashboardPage(), // Placeholder for other pages
    DashboardPage(), // Placeholder for other pages
    DashboardPage()  // Placeholder for other pages
  ];
  int _currentIndex = 0;
  late Future<List<Course>> futureCourses;

  @override
  void initState() {
    super.initState();
    futureCourses = APIService().fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: SafeArea(
        child: _currentIndex == 0 ? _buildHomePage() : _widgetList[_currentIndex],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.lightBlue,
      automaticallyImplyLeading: false,
      title: Text('Preparia.ma'),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }

  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCoursesSection(),
            SizedBox(height: 20),
            _buildForumsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Courses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to all courses page
              },
              child: Text(
                'See all',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          height: 150,
          child: FutureBuilder<List<Course>>(
            future: futureCourses,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Failed to load courses: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No courses available'));
              } else {
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data!.map((course) => _buildCourseCard(course)).toList(),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCourseCard(Course course) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              image: DecorationImage(
                image: NetworkImage(course.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.status,
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                Text(
                  course.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  course.author,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForumsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Forums',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to all forums page
              },
              child: Text(
                'See all',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        _buildForumCard('Politics News', 'Politics is a set of activities associated with the governance ...', '3 Discussions'),
        _buildForumCard('Ask Anything Random Here', 'Hey everyone! This forum will be focused on community engage...', '3 Discussions'),
        _buildForumCard('Mobile Application', 'A mobile application also referred to as...', '5 Discussions'),
      ],
    );
  }

  Widget _buildForumCard(String title, String description, String discussions) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage('https://www.example.com/forum_image.jpg'), // Replace with your image URL
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: Text(discussions),
      ),
    );
  }
}
