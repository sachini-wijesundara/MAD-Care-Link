import 'package:care_link_development/model/appoinment.dart';
import 'package:care_link_development/model/doctor.dart';
import 'package:care_link_development/providers/appoinment_provider.dart';
import 'package:care_link_development/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

// Convert to StatefulWidget
class DoctorDetailPage extends StatefulWidget {
  final DoctorModel doctor;

  const DoctorDetailPage({super.key, required this.doctor});

  @override
  State<DoctorDetailPage> createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  String? selectedDay;
  String? selectedTime;

  bool get isSelectionValid => selectedDay != null && selectedTime != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003B73),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Doctor Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor header
            Container(
              color: const Color(0xFF003B73),
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  // Doctor image
                  Container(
                    width: 120,
                    height: 120,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        widget.doctor.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                      ),
                    ),
                  ),
                  // Doctor name and specialty
                  Text(
                    widget.doctor.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.doctor.specialty,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  // Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 22),
                      Text(
                        " ${widget.doctor.rating} ",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "(${widget.doctor.reviewCount} reviews)",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Doctor information
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hospital
                  _buildInfoItem(
                    Icons.local_hospital,
                    "Hospital",
                    widget.doctor.hospital,
                  ),

                  // Education
                  _buildInfoItem(
                    Icons.school,
                    "Education",
                    widget.doctor.education,
                  ),

                  // Experience
                  _buildInfoItem(
                    Icons.work,
                    "Experience",
                    widget.doctor.experience,
                  ),

                  // Consultation Fee
                  _buildInfoItem(
                    Icons.attach_money,
                    "Consultation Fee",
                    "Rs. ${widget.doctor.consultationFee.toStringAsFixed(2)}",
                  ),

                  const SizedBox(height: 20),

                  // About
                  const Text(
                    "About Doctor",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003B73),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.doctor.about,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Available Schedule
                  const Text(
                    "Available Schedule",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003B73),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Days
                  Wrap(
                    spacing: 8,
                    children:
                        widget.doctor.availableDays.map((day) {
                          final isSelected = selectedDay == day;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDay = day;
                                selectedTime =
                                    null; // Reset time when day changes
                              });
                            },
                            child: Chip(
                              backgroundColor:
                                  isSelected
                                      ? const Color(0xFF003B73)
                                      : const Color(0xFFB3DFFC),
                              label: Text(
                                day,
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : const Color(0xFF003B73),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 12),

                  // Time slots
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.doctor.availableTimes.length,
                      itemBuilder: (context, index) {
                        final time = widget.doctor.availableTimes[index];
                        final isSelected = selectedTime == time;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTime = time;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? const Color(0xFF003B73)
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF003B73),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              time,
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : const Color(0xFF003B73),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Book Appointment button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          isSelectionValid
                              ? () async {
                                // Print selections to console
                                print('Selected Day: $selectedDay');
                                print('Selected Time: $selectedTime');
                                print('Doctor: ${widget.doctor.name}');
                                print(
                                  'Consultation Fee: Rs.${widget.doctor.consultationFee}',
                                );

                                await context
                                    .read<AppoinmentProvider>()
                                    .createAppoinment(
                                      AppointmentModel(
                                        id:
                                            DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString(),
                                        user:
                                            context.read<UserProvider>().user!,
                                        doctorName: widget.doctor.name,
                                        price: widget.doctor.consultationFee,
                                        bookedDateTime: DateTime.now(),
                                        appointmentDay: selectedDay!,
                                        appointmentTime: selectedTime!,
                                        specialty: widget.doctor.specialty,
                                        appointmentNo:
                                            "${Random().nextInt(9999 - 1000) + 1000}",
                                      ),
                                    );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Appointment booked with ${widget.doctor.name} on $selectedDay at $selectedTime",
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context);
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003B73),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          context.watch<AppoinmentProvider>().isLoading
                              ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                isSelectionValid
                                    ? "Book Appointment"
                                    : "Select Day and Time",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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

  Widget _buildInfoItem(IconData icon, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFB3DFFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF003B73)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
