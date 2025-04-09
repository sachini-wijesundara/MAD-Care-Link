import 'package:care_link_development/model/appoinment.dart';
import 'package:care_link_development/providers/appoinment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ManageAppointmentsScreen extends StatefulWidget {
  const ManageAppointmentsScreen({super.key});

  @override
  State<ManageAppointmentsScreen> createState() =>
      _ManageAppointmentsScreenState();
}

class _ManageAppointmentsScreenState extends State<ManageAppointmentsScreen> {
  final List<String> _specializations = [
    'Dentist',
    'Cardiologist',
    'Neurologist',
    'Eye Specialist',
    'Pediatrician',
  ];
  String _selectedSpecialization = 'Dentist';

  final List<Doctor> _doctors = [
    Doctor(name: 'Doctor 001', timeslots: ['12:00 - 15:00', '18:00 - 20:00']),
    Doctor(name: 'Doctor 002', timeslots: ['10:00 - 12:00', '16:00 - 18:00']),
  ];

  @override
  void initState() {
    _refreshOrders();
    super.initState();
  }

  Future<void> _refreshOrders() async {
    await context.read<AppoinmentProvider>().fetchAppoinments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Manage Appointments'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment(0.0, -0.2),
            colors: [Color(0xFFB3DFFC), Colors.white],
          ),
        ),
        child:
            context.watch<AppoinmentProvider>().isLoading
                ? Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  ),
                )
                : SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Expanded(
                        child: Consumer<AppoinmentProvider>(
                          builder: (context, appointmentProvider, child) {
                            if (appointmentProvider.appointments.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No appointments available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            }
                            return ListView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              children:
                                  appointmentProvider.appointments.map((
                                    appointment,
                                  ) {
                                    return Column(
                                      children: [
                                        PatientCard(
                                          patientId: appointment.user.username,
                                          date: appointment.appointmentDay,
                                          time: appointment.appointmentTime,
                                          doctorName: appointment.doctorName,
                                          specialty: appointment.specialty,
                                          appointmentNo:
                                              appointment.appointmentNo,
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
                    ],
                  ),
                ),
      ),
    );
  }
}

class Doctor {
  final String name;
  final List<String> timeslots;

  Doctor({required this.name, required this.timeslots});
}

class DoctorCard extends StatefulWidget {
  final Doctor doctor;
  const DoctorCard({super.key, required this.doctor});

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTimeslot;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.doctor.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => _selectedDay == day,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children:
                widget.doctor.timeslots.map((slot) {
                  final isSelected = _selectedTimeslot == slot;
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time, size: 16),
                        const SizedBox(width: 4),
                        Text(slot),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        _selectedTimeslot = val ? slot : null;
                      });
                    },
                    selectedColor: Colors.blue[200],
                    backgroundColor: Colors.grey[200],
                  );
                }).toList(),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${widget.doctor.name} appointment saved for ${_selectedDay != null ? _selectedDay.toString().split(" ")[0] : "(no date)"} at ${_selectedTimeslot ?? "(no time)"}',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
              ),
              child: const Text('Save'),
            ),
          ),
        ],
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
                                          child: CircularProgressIndicator(),
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
