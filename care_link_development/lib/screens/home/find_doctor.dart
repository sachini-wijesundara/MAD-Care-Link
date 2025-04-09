import 'package:care_link_development/doctors/doctor_detail.dart';
import 'package:care_link_development/model/doctor.dart';
import 'package:care_link_development/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DoctorModel> _allDoctors = [];
  List<DoctorModel> _filteredDoctors = [];
  String _selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    // Initialize doctors data
    _loadDoctors();
    _searchController.addListener(_filterDoctors);
  }

  void _loadDoctors() {
    // Using the sample doctors from doctor_model.dart
    setState(() {
      _allDoctors = getSampleDoctors();
      _filteredDoctors = _allDoctors;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterDoctors() {
    final query = _searchController.text;
    setState(() {
      if (query.isEmpty && _selectedCategory == "All") {
        _filteredDoctors = _allDoctors;
      } else {
        _filteredDoctors =
            _allDoctors.where((doctor) {
              bool matchesQuery = query.isEmpty || doctor.matchesSearch(query);
              bool matchesCategory =
                  _selectedCategory == "All" ||
                  doctor.specialty == _selectedCategory;
              return matchesQuery && matchesCategory;
            }).toList();
      }
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filterDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF003B73),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFF003B73),
          title: const Text(
            'Doctor Finder',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        endDrawer: const CustomDrawer(),
        body: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 200),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment(0.0, -0.2),
                  colors: [Color(0xFFB3DFFC), Colors.white],
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF003B73),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Colors.grey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: const InputDecoration(
                                      hintText:
                                          'Search doctors, specialties...',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: PageView(
                        controller: PageController(viewportFraction: 0.95),
                        children: [
                          _buildBanner(
                            'assets/360_F_645689490_Fzwptjq0YLCW8JZp.jpg',
                          ),
                          _buildBanner(
                            'assets/360_F_767978440_wES7UvxKFGvz6DIB.jpg',
                          ),
                          _buildBanner(
                            'assets/medical-doctor-over-healthcare-b.jpg',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Column(
                        children: [
                          Text(
                            '📞 01405 600 700',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '24/7 Emergency Ambulance Service',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCategoryButton(
                            context,
                            'assets/tooth.png',
                            Colors.purple,
                            'Dental',
                          ),
                          _buildCategoryButton(
                            context,
                            'assets/heart.png',
                            Colors.green,
                            'Cardiology',
                          ),
                          _buildCategoryButton(
                            context,
                            'assets/eye.png',
                            Colors.orange,
                            'Eye Care',
                          ),
                          _buildCategoryButton(
                            context,
                            'assets/waist.png',
                            Colors.red,
                            'Pediatrics',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Doctor Listing Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedCategory == "All"
                                    ? "All Doctors"
                                    : "$_selectedCategory Specialists",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF003B73),
                                ),
                              ),
                              Text(
                                "${_filteredDoctors.length} doctors",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Doctor cards
                          if (_filteredDoctors.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: Text(
                                  "No doctors found matching your criteria",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            )
                          else
                            ...List.generate(
                              _filteredDoctors.length,
                              (index) =>
                                  _buildDoctorCard(_filteredDoctors[index]),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(DoctorModel doctor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailPage(doctor: doctor),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Doctor image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  doctor.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Icon(Icons.person, size: 40, color: Colors.grey[400]),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Doctor information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.specialty,
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.hospital,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      Text(
                        " ${doctor.rating} ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "(${doctor.reviewCount} reviews)",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF003B73).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF003B73),
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.blue[800],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => Container(
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.white54,
                  size: 50,
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(
    BuildContext context,
    String iconPath,
    Color color,
    String label,
  ) {
    bool isSelected = _selectedCategory == label;

    return GestureDetector(
      onTap: () {
        _selectCategory(label);
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  isSelected ? const Color(0xFF003B73) : color.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
              border:
                  isSelected ? Border.all(color: Colors.white, width: 2) : null,
            ),
            child: Image.asset(
              iconPath,
              color: Colors.white,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.medical_services, color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? const Color(0xFF003B73) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// You need to create a doctor_model.dart file with the Doctor class and getSampleDoctors() function
