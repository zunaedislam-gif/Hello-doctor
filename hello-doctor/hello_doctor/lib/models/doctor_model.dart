class WorkHistory {
  final String hospitalName;
  final String position;
  final String department;
  final String duration;

  const WorkHistory({
    required this.hospitalName,
    required this.position,
    required this.department,
    required this.duration,
  });
}

class PatientReview {
  final String patientName;
  final double rating;
  final String date;
  final String comment;

  const PatientReview({
    required this.patientName,
    required this.rating,
    required this.date,
    required this.comment,
  });
}

class TipArticle {
  final String title;
  final String category;
  final String readTime;
  final String snippet;

  const TipArticle({
    required this.title,
    required this.category,
    required this.readTime,
    required this.snippet,
  });
}

class Doctor {
  final String id;
  final String name;
  final String degrees;
  final String specialty;
  final int experience;
  final double rating;
  final int reviewsCount;
  final double consultationFee;
  final double followUpFee;
  final String bmdcNumber;
  final String gender;
  final bool isAvailableToday;
  final String bio;
  final String timing;
  final String appointmentTiming;
  final String avgCallDuration;
  final List<WorkHistory> experienceList;
  final List<PatientReview> reviewsList;
  final List<TipArticle> tipsList;

  const Doctor({
    required this.id,
    required this.name,
    required this.degrees,
    required this.specialty,
    required this.experience,
    required this.rating,
    required this.reviewsCount,
    required this.consultationFee,
    required this.followUpFee,
    required this.bmdcNumber,
    required this.gender,
    required this.isAvailableToday,
    required this.bio,
    required this.timing,
    required this.appointmentTiming,
    required this.avgCallDuration,
    required this.experienceList,
    required this.reviewsList,
    required this.tipsList,
  });

  // Calculate rating breakdown for 1-5 stars
  Map<int, double> get ratingBreakdown {
    if (reviewsList.isEmpty) return {5: 0.0, 4: 0.0, 3: 0.0, 2: 0.0, 1: 0.0};
    final Map<int, int> counts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var r in reviewsList) {
      int star = r.rating.round().clamp(1, 5);
      counts[star] = (counts[star] ?? 0) + 1;
    }
    final Map<int, double> breakdown = {};
    counts.forEach((star, count) {
      breakdown[star] = count / reviewsList.length;
    });
    return breakdown;
  }
}

// Global list of highly detailed dummy doctors
final List<Doctor> dummyDoctors = [
  Doctor(
    id: "doc_1",
    name: "Dr. Sarah Rahman",
    degrees: "MBBS, FCPS (Medicine), MD",
    specialty: "General Physician",
    experience: 8,
    rating: 4.9,
    reviewsCount: 124,
    consultationFee: 500,
    followUpFee: 300,
    bmdcNumber: "BMDC/Reg-847291",
    gender: "Female",
    isAvailableToday: true,
    bio: "Dr. Sarah Rahman is an experienced General Physician specialized in chronic lifestyle diseases, metabolic health, hypertension, and family health consults. She prioritizes compassionate care and holistic digital diagnostics.",
    timing: "05:00 PM - 09:00 PM (Daily)",
    appointmentTiming: "Sat - Thu, 04:00 PM - 08:30 PM",
    avgCallDuration: "12 mins",
    experienceList: [
      WorkHistory(
        hospitalName: "Dhaka Medical College Hospital",
        position: "Registrar",
        department: "Medicine",
        duration: "2018 - 2021 (3 years)",
      ),
      WorkHistory(
        hospitalName: "Square Hospital Dhaka",
        position: "Senior Specialist",
        department: "Internal Medicine",
        duration: "2021 - Present",
      ),
    ],
    reviewsList: [
      PatientReview(
        patientName: "Karim Uddin",
        rating: 5.0,
        date: "July 2, 2026",
        comment: "Excellent consult! She listended to my symptoms very patiently and explained the dosage carefully.",
      ),
      PatientReview(
        patientName: "Sultana Yasmin",
        rating: 4.8,
        date: "June 28, 2026",
        comment: "Highly professional doctor, the digital prescription arrived within 5 minutes of the call.",
      ),
      PatientReview(
        patientName: "Asif Iqbal",
        rating: 5.0,
        date: "June 15, 2026",
        comment: "Great experience. Follow up consult fee is also very reasonable.",
      ),
    ],
    tipsList: [
      TipArticle(
        title: "Managing Hypertension Naturally",
        category: "Cardio & General",
        readTime: "4 mins read",
        snippet: "Learn the crucial dietary pivots, low-sodium tips, and daily breathing exercises that can assist in stabilizing elevated BP metrics.",
      ),
      TipArticle(
        title: "The Importance of Hydration in Monsoon",
        category: "Healthy Living",
        readTime: "3 mins read",
        snippet: "Stay safe from waterborne pathogens by following these clean boiling standards and maintaining correct electrolyte levels.",
      ),
    ],
  ),
  Doctor(
    id: "doc_2",
    name: "Dr. Fahim Anjum",
    degrees: "MBBS, DGO, MCPS (Gynecology)",
    specialty: "Gynecology",
    experience: 10,
    rating: 4.8,
    reviewsCount: 98,
    consultationFee: 600,
    followUpFee: 400,
    bmdcNumber: "BMDC/Reg-928173",
    gender: "Male",
    isAvailableToday: false,
    bio: "Dr. Fahim Anjum is a senior consultant gynecologist and obstetrician. He holds advanced certifications in reproductive endocrinology and specializes in high-risk pregnancies and modern digital prenatal advisory.",
    timing: "06:00 PM - 10:00 PM (Mon & Wed)",
    appointmentTiming: "Sun, Mon, Wed, 05:00 PM - 09:00 PM",
    avgCallDuration: "15 mins",
    experienceList: [
      WorkHistory(
        hospitalName: "Sir Salimullah Medical College",
        position: "Assistant Professor",
        department: "Obstetrics & Gynecology",
        duration: "2017 - 2022 (5 years)",
      ),
      WorkHistory(
        hospitalName: "Labaid Specialized Hospital",
        position: "Consultant Gynecology",
        department: "Maternity",
        duration: "2022 - Present",
      ),
    ],
    reviewsList: [
      PatientReview(
        patientName: "Nusrat Jahan",
        rating: 5.0,
        date: "June 25, 2026",
        comment: "Very polite, reassuring doctor. Highly recommended for maternal guidance.",
      ),
      PatientReview(
        patientName: "Farhana Chowdhury",
        rating: 4.5,
        date: "June 12, 2026",
        comment: "Gave great dietary plans for post-natal recovery. Very comprehensive advice.",
      ),
    ],
    tipsList: [
      TipArticle(
        title: "Prenatal Nutrition Guide",
        category: "Maternity Care",
        readTime: "5 mins read",
        snippet: "What micronutrients are indispensable during your first trimester? Explore folate, iron, and vitamin D requirements.",
      ),
    ],
  ),
  Doctor(
    id: "doc_3",
    name: "Dr. Naila Khan",
    degrees: "MBBS, MD (Pediatrics), MPH",
    specialty: "Pediatrics",
    experience: 12,
    rating: 4.9,
    reviewsCount: 210,
    consultationFee: 700,
    followUpFee: 400,
    bmdcNumber: "BMDC/Reg-735912",
    gender: "Female",
    isAvailableToday: true,
    bio: "Dr. Naila Khan has over 12 years of experience caring for neonates, infants, and pediatric wellness. She is a prominent advocate of child nutrition, immunization programs, and developmental milestones tracking.",
    timing: "04:00 PM - 08:00 PM (Daily)",
    appointmentTiming: "Sat - Thu, 03:00 PM - 07:00 PM",
    avgCallDuration: "10 mins",
    experienceList: [
      WorkHistory(
        hospitalName: "Bangladesh Institute of Child Health (BICH)",
        position: "Senior Registrar",
        department: "Neonatology",
        duration: "2014 - 2019 (5 years)",
      ),
      WorkHistory(
        hospitalName: "Evercare Hospital Dhaka",
        position: "Senior Consultant",
        department: "Pediatrics & Child Health",
        duration: "2019 - Present",
      ),
    ],
    reviewsList: [
      PatientReview(
        patientName: "Rezaul Karim",
        rating: 5.0,
        date: "July 1, 2026",
        comment: "Excellent with kids! My son was very comfortable during the video consultation. She explained the cough syrup dose clearly.",
      ),
      PatientReview(
        patientName: "Tania Sultana",
        rating: 4.9,
        date: "June 24, 2026",
        comment: "Excellent diagnostic eye. Her prescription cured my infant's skin rash within 2 days.",
      ),
    ],
    tipsList: [
      TipArticle(
        title: "Vaccination Timeline for Infants",
        category: "Child Health",
        readTime: "6 mins read",
        snippet: "A comprehensive map of critical vaccines, timelines, and mild post-shot temperature management techniques.",
      ),
    ],
  ),
  Doctor(
    id: "doc_4",
    name: "Dr. Ariful Islam",
    degrees: "MBBS, MD (Cardiology), NICVD",
    specialty: "Cardiology",
    experience: 15,
    rating: 4.9,
    reviewsCount: 315,
    consultationFee: 800,
    followUpFee: 500,
    bmdcNumber: "BMDC/Reg-624819",
    gender: "Male",
    isAvailableToday: false,
    bio: "Dr. Ariful Islam is a distinguished cardiologist with 15 years of hospital and academic experience. He specialized in preventive cardiology, hypertension and arrhythmia management, utilizing high-end mobile diagnostic telemetry.",
    timing: "07:00 PM - 10:00 PM (Sun, Tue, Thu)",
    appointmentTiming: "Sun, Tue, Thu, 06:00 PM - 09:30 PM",
    avgCallDuration: "14 mins",
    experienceList: [
      WorkHistory(
        hospitalName: "National Institute of Cardiovascular Diseases",
        position: "Assistant Professor",
        department: "Clinical Cardiology",
        duration: "2011 - 2018 (7 years)",
      ),
      WorkHistory(
        hospitalName: "United Hospital Dhaka",
        position: "Chief Cardiologist",
        department: "Cardiology & Cardiac Wellness",
        duration: "2018 - Present",
      ),
    ],
    reviewsList: [
      PatientReview(
        patientName: "Mokhlesur Rahman",
        rating: 5.0,
        date: "June 30, 2026",
        comment: "The best heart specialist in the country. His guidance has kept my cholesterol and BP perfectly under check.",
      ),
      PatientReview(
        patientName: "Jahanara Begum",
        rating: 4.8,
        date: "June 18, 2026",
        comment: "Very clear instructions. He did not prescribe unnecessary medical tests.",
      ),
    ],
    tipsList: [
      TipArticle(
        title: "Recognizing Early Cardiac Stress Signs",
        category: "Heart Care",
        readTime: "4 mins read",
        snippet: "Do not dismiss vague chest heaviness or sudden cold sweating. Learn how to act and when an immediate ER consult is required.",
      ),
    ],
  ),
  Doctor(
    id: "doc_5",
    name: "Dr. Tasnim Ahmed",
    degrees: "MBBS, DDV (Dermatology)",
    specialty: "Skin/Derm",
    experience: 7,
    rating: 4.7,
    reviewsCount: 84,
    consultationFee: 500,
    followUpFee: 300,
    bmdcNumber: "BMDC/Reg-947218",
    gender: "Female",
    isAvailableToday: true,
    bio: "Dr. Tasnim Ahmed is a dedicated dermatologist expert in clinical dermatology, pediatric skin disorders, acne management, allergy evaluations, and advanced laser aesthetics counseling.",
    timing: "05:00 PM - 09:00 PM (Sat, Mon, Wed)",
    appointmentTiming: "Sat, Mon, Wed, 04:30 PM - 08:30 PM",
    avgCallDuration: "11 mins",
    experienceList: [
      WorkHistory(
        hospitalName: "Bangabandhu Sheikh Mujib Medical University",
        position: "Resident Specialist",
        department: "Dermatology",
        duration: "2019 - 2022 (3 years)",
      ),
      WorkHistory(
        hospitalName: "Popular Consultation Centre",
        position: "Consultant Dermatologist",
        department: "Skin & Allergy",
        duration: "2022 - Present",
      ),
    ],
    reviewsList: [
      PatientReview(
        patientName: "Naila Khatun",
        rating: 4.7,
        date: "June 29, 2026",
        comment: "Her skin allergy treatment worked wonder. Visibly better skin health in just 5 days.",
      ),
      PatientReview(
        patientName: "Kamrul Hasan",
        rating: 4.5,
        date: "June 20, 2026",
        comment: "Short wait times online, precise diagnostic routine.",
      ),
    ],
    tipsList: [
      TipArticle(
        title: "Shielding Your Skin From UV Pollution",
        category: "Skin & Beauty",
        readTime: "3 mins read",
        snippet: "Understand SPF choices, correct quantities for sub-continental weather, and how often you should re-apply protection.",
      ),
    ],
  )
];
