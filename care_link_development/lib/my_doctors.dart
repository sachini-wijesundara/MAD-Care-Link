import 'package:care_link_development/doctors/doctor_appointment.dart';
import 'package:care_link_development/doctors/doctor_detail.dart';
import 'package:care_link_development/model/doctor.dart';
import 'package:flutter/material.dart';

class MyDoctorsScreen extends StatefulWidget {
  const MyDoctorsScreen({super.key});

  @override
  State<MyDoctorsScreen> createState() => _MyDoctorsScreenState();
}

class _MyDoctorsScreenState extends State<MyDoctorsScreen> {
  List<DoctorModel> _allDoctors = [];
  List<DoctorModel> _filteredDoctors = [];
  String _selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    // Initialize doctors data
    _loadDoctors();
  }

  void _loadDoctors() {
    // Using the sample doctors from doctor_model.dart
    setState(() {
      _allDoctors = getSampleDoctors();
      _filteredDoctors = _allDoctors;
    });
  }
  // List<DoctorModel> doctors = [
  //   DoctorModel(
  //     name: 'Dr. Tranquilli',
  //     specialty: 'Specialist Medicine',
  //     experience: '6 Years',
  //     rating: 87,
  //     stories: 69,
  //     image: 'assets/doctor1.png',
  //     time: '10:00 AM',
  //     isFavorite: false,
  //   ),
  //   DoctorModel(
  //     name: 'Dr. Bonebrake',
  //     specialty: 'Specialist Dentist',
  //     experience: '8 Years',
  //     rating: 59,
  //     stories: 82,
  //     image: 'assets/doctor2.png',
  //     time: '12:00 AM',
  //     isFavorite: true,
  //   ),
  //   DoctorModel(
  //     name: 'Dr. Luke Whitesell',
  //     specialty: 'Specialist Cardiology',
  //     experience: '7 Years',
  //     rating: 57,
  //     stories: 76,
  //     image: 'assets/doctor3.png',
  //     time: '11:00 AM',
  //     isFavorite: false,
  //   ),
  //   DoctorModel(
  //     name: 'Dr. Shoemaker',
  //     specialty: 'Specialist Pathology',
  //     experience: '5 Years',
  //     rating: 67,
  //     stories: 63,
  //     image: 'assets/doctor1.png',
  //     time: '01:00 PM',
  //     isFavorite: true,
  //   ),
  // ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // List<Doctor> filteredDoctors =
    //     doctors
    //         .where(
    //           (doc) =>
    //               doc.name.toLowerCase().contains(searchQuery.toLowerCase()),
    //         )
    //         .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),

        title: const Text('My Doctors', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Doctor List
            ...List.generate(
              _filteredDoctors.length,
              (index) => _buildDoctorCard(_filteredDoctors[index]),
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

  // Widget _buildDoctorCard(Doctor doctor, int index) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 16),
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(14),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.shade200,
  //           blurRadius: 6,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Doctor Image
  //             ClipRRect(
  //               borderRadius: BorderRadius.circular(8),
  //               child: Image.asset(
  //                 doctor.image,
  //                 width: 70,
  //                 height: 70,
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Expanded(
  //                         child: Text(
  //                           doctor.name,
  //                           style: const TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 16,
  //                           ),
  //                         ),
  //                       ),
  //                       IconButton(
  //                         icon: Icon(
  //                           doctor.isFavorite
  //                               ? Icons.favorite
  //                               : Icons.favorite_border,
  //                           color: doctor.isFavorite ? Colors.red : Colors.grey,
  //                         ),
  //                         onPressed: () {
  //                           setState(() {
  //                             doctors[index].isFavorite =
  //                                 !doctors[index].isFavorite;
  //                           });
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                   Text(
  //                     doctor.specialty,
  //                     style: const TextStyle(color: Colors.blue),
  //                   ),
  //                   Text('${doctor.experience} experience'),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 12),
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) {
  //                   return DoctorDetailPage(doctor: doctor,);
  //                 },
  //               ),
  //             );
  //           },
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.blue[800],
  //             minimumSize: const Size(100, 36),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(6),
  //             ),
  //           ),
  //           child: const Text(
  //             'Book Now',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ),
  //         const SizedBox(height: 8),
  //         Row(
  //           children: [
  //             Icon(Icons.thumb_up, color: Colors.blue[300], size: 16),
  //             const SizedBox(width: 4),
  //             Text('${doctor.rating}%'),
  //             const SizedBox(width: 12),
  //             const Icon(Icons.circle, size: 6, color: Colors.grey),
  //             const SizedBox(width: 6),
  //             Text('${doctor.stories} Patient Stories'),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class Doctor {
  final String name;
  final String specialty;
  final String experience;
  final int rating;
  final int stories;
  final String image;
  final String time;
  bool isFavorite;

  Doctor({
    required this.name,
    required this.specialty,
    required this.experience,
    required this.rating,
    required this.stories,
    required this.image,
    required this.time,
    this.isFavorite = false,
  });
}
