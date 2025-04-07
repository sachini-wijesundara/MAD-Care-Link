class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String education;
  final String experience;
  final String about;
  final List<String> availableDays;
  final List<String> availableTimes;
  final double consultationFee;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.education,
    required this.experience,
    required this.about,
    required this.availableDays,
    required this.availableTimes,
    required this.consultationFee,
  });

  // Add a method to easily filter doctors by name or specialty
  bool matchesSearch(String query) {
    final lowercaseQuery = query.toLowerCase();
    return name.toLowerCase().contains(lowercaseQuery) ||
        specialty.toLowerCase().contains(lowercaseQuery) ||
        hospital.toLowerCase().contains(lowercaseQuery);
  }
}

// Sample doctors data
List<DoctorModel> getSampleDoctors() {
  return [
    DoctorModel(
      id: "1",
      name: "Dr. Sarah Johnson",
      specialty: "Cardiology",
      hospital: "Central Hospital",
      imageUrl: "assets/doctor1.png", // Replace with actual asset path
      rating: 4.9,
      reviewCount: 124,
      education: "MBBS, MD - Cardiology",
      experience: "12 years",
      about:
          "Dr. Sarah Johnson is a specialist in cardiovascular diseases with extensive experience in treating heart conditions. She has performed over 500 cardiac procedures and is dedicated to providing comprehensive care.",
      availableDays: ["Monday", "Wednesday", "Friday"],
      availableTimes: ["9:00 AM", "11:00 AM", "2:00 PM", "4:00 PM"],
      consultationFee: 3500.00,
    ),
    DoctorModel(
      id: "2",
      name: "Dr. Michael Lee",
      specialty: "Pediatrics",
      hospital: "Children's Medical Center",
      imageUrl: "assets/doctor2.png", // Replace with actual asset path
      rating: 4.8,
      reviewCount: 98,
      education: "MBBS, MD - Pediatrics",
      experience: "8 years",
      about:
          "Dr. Michael Lee is a compassionate pediatrician who specializes in child development and pediatric care. He is known for his gentle approach and ability to make children feel comfortable during examinations.",
      availableDays: ["Tuesday", "Thursday", "Saturday"],
      availableTimes: ["10:00 AM", "12:00 PM", "3:00 PM"],
      consultationFee: 2800.00,
    ),
    DoctorModel(
      id: "3",
      name: "Dr. Emily Chen",
      specialty: "Dental",
      hospital: "Smile Dental Clinic",
      imageUrl: "assets/doctor3.png", // Replace with actual asset path
      rating: 4.7,
      reviewCount: 86,
      education: "BDS, MDS - Orthodontics",
      experience: "10 years",
      about:
          "Dr. Emily Chen is an expert in orthodontics and cosmetic dentistry. She is dedicated to helping patients achieve their perfect smile through advanced dental procedures and personalized treatment plans.",
      availableDays: ["Monday", "Tuesday", "Thursday", "Friday"],
      availableTimes: ["9:00 AM", "11:00 AM", "1:00 PM", "3:00 PM", "5:00 PM"],
      consultationFee: 3200.00,
    ),
    DoctorModel(
      id: "4",
      name: "Dr. Robert Wilson",
      specialty: "Eye Care",
      hospital: "Vision Eye Center",
      imageUrl: "assets/doctor4.png", // Replace with actual asset path
      rating: 4.9,
      reviewCount: 115,
      education: "MBBS, MS - Ophthalmology",
      experience: "15 years",
      about:
          "Dr. Robert Wilson is a leading ophthalmologist specializing in cataract surgery and corneal disorders. He has helped thousands of patients improve their vision and eye health using the latest techniques.",
      availableDays: ["Wednesday", "Friday", "Saturday"],
      availableTimes: ["8:00 AM", "10:00 AM", "12:00 PM", "2:00 PM"],
      consultationFee: 3800.00,
    ),
    DoctorModel(
      id: "5",
      name: "Dr. Priya Sharma",
      specialty: "Dermatology",
      hospital: "Skin & Wellness Center",
      imageUrl: "assets/doctor5.png", // Replace with actual asset path
      rating: 4.6,
      reviewCount: 78,
      education: "MBBS, MD - Dermatology",
      experience: "7 years",
      about:
          "Dr. Priya Sharma specializes in medical and cosmetic dermatology. She is passionate about helping patients achieve healthy skin and treats a wide range of skin conditions with individualized care.",
      availableDays: ["Monday", "Wednesday", "Saturday"],
      availableTimes: ["9:30 AM", "11:30 AM", "2:30 PM", "4:30 PM"],
      consultationFee: 3000.00,
    ),
  ];
}
