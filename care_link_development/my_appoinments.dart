import 'package:care_link_development/model/appoinment.dart';
import 'package:care_link_development/providers/appoinment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppoinmentsScreen extends StatefulWidget {
  const MyAppoinmentsScreen({super.key});

  @override
  State<MyAppoinmentsScreen> createState() => _MyAppoinmentsScreenState();
}

class _MyAppoinmentsScreenState extends State<MyAppoinmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Appointments'),
        backgroundColor: Colors.white,
      ),
      body: Expanded(
        child: Consumer<AppoinmentProvider>(
          builder: (context, appointmentProvider, child) {
            if (appointmentProvider.appointments.isEmpty) {
              return const Center(
                child: Text(
                  'No appointments available',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children:
                  appointmentProvider.appointments.map((appointment) {
                    return Column(
                      children: [
                        PatientCard(
                          patientId: appointment.user.username,
                          date: appointment.appointmentDay,
                          time: appointment.appointmentTime,
                          doctorName: appointment.doctorName,
                          specialty: appointment.specialty,
                          appointmentNo: appointment.appointmentNo,
                          appointment: appointment,
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  final String patientId;
  final String date;
  final String time;
  final String doctorName;
  final String specialty;
  final String appointmentNo;
  final AppointmentModel appointment;

  const PatientCard({
    super.key,
    required this.patientId,
    required this.date,
    required this.time,
    required this.doctorName,
    required this.specialty,
    required this.appointmentNo,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  patientId,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'edit') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Edit pressed for $patientId')),
                      );
                    } else if (value == 'delete') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                              'Are you sure you want to delete this appointment?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await context
                                      .read<AppoinmentProvider>()
                                      .deleteAppoinment(appointment);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Appointment deleted successfully!',
                                      ),
                                    ),
                                  );
                                },
                                child:
                                    context
                                            .watch<AppoinmentProvider>()
                                            .isLoading
                                        ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                        : const Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Date - $date'), Text('Time - $time')],
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87),
                children: [
                  TextSpan(
                    text: doctorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  TextSpan(text: ' - $specialty'),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Appointment NO - $appointmentNo',
              style: const TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
