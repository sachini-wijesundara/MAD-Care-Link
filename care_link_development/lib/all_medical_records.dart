import 'dart:io';

import 'package:care_link_development/add_medical_records_1.dart';
import 'package:care_link_development/model/record.dart';
import 'package:care_link_development/providers/recordes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllRecordsScreen extends StatefulWidget {
  const AllRecordsScreen({super.key});

  @override
  State<AllRecordsScreen> createState() => _AllRecordsScreenState();
}

class _AllRecordsScreenState extends State<AllRecordsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment(0.0, -0.2),
            colors: [Color(0xFFB3DFFC), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: const [
                    BackButton(),
                    Text(
                      'All Records',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Record List
              Expanded(
                child: Consumer<RecordesProvider>(
                  builder: (context, recordsProvider, child) {
                    if (recordsProvider.records.isEmpty) {
                      return const Center(child: Text('No records found'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: recordsProvider.records.length,
                      itemBuilder: (context, index) {
                        return _buildRecordCard(
                          recordsProvider.records[index],
                          index,
                        );
                      },
                    );
                  },
                ),
              ),
              // Add a Record Button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const EmptyMedicalRecordScreen();
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Add a record',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordCard(RecordModel record, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        // leading: Container(
        //   width: 50,
        //   height: 50,
        //   decoration: BoxDecoration(
        //     color: Colors.blue[800],
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        //   child: Center(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           record.date.day.toString(),
        //           style: const TextStyle(
        //             color: Colors.white,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //         Text(
        //           '${record.date.month}/${record.date.year}',
        //           style: const TextStyle(color: Colors.white, fontSize: 10),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        title: Text(
          record.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Prescription: ${record.prescription}'),
            if (record.image.isNotEmpty) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(record.image),
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          const Center(child: Text('Failed to load image')),
                ),
              ),
            ],
            const SizedBox(height: 4),
            Text('Date: ${record.date.toString().split(' ')[0]}'),
          ],
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              context.read<RecordesProvider>().removeRecord(record);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Record deleted successfully')),
              );
            }
          },
          itemBuilder:
              (context) => [
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
        ),
      ),
    );
  }
}
