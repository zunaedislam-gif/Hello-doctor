# Hello Doctor Backend Data Schema & System Architecture

This document outlines the database schema, data models, encryption mandates, performance indexing strategies, and recommended system architecture for the **Hello Doctor** clinical telemedicine, medicine delivery, and home diagnostics platform.

---

## 1. System Architecture & Recommended Tech Stack

For an MVP deployment, **Firebase** is highly recommended due to its generous free tier, rapid development velocity, and unified services. It allows the platform to run seamlessly with minimal initial infrastructure overhead:

*   **Firebase Authentication**: Streamlined sign-in with phone-based OTP (essential for verification in Bangladesh/South Asia) and standard email/password methods.
*   **Cloud Firestore**: Flexible, highly scalable NoSQL database with support for nested structures, local offline persistence, and powerful query filtering.
*   **Firebase Storage**: Secure object storage for uploading patient insurance cards, BMDC medical licenses, prescription PDFs, and diagnostic test reports.
*   **Firebase Cloud Messaging (FCM)**: Out-of-the-box push notifications for real-time video consult alerts, prescription reminders, and medicine delivery status updates.
*   **Realtime Database**: Highly responsive real-time state synchronization, perfect for establishing WebRTC video-calling signaling paths and active chat presence.

### Transition Plan to Custom SQL
When user metrics, query complexities, or database operations scale beyond free-tier boundaries, the architecture can be seamlessly transitioned to a **Node.js (Express or NestJS) backend paired with a PostgreSQL database** (e.g., hosted on GCP Cloud SQL or Supabase), while maintaining the mobile and web client interactions.

---

## 2. Key Database Constraints & Performance Standards

### Encryption at Rest
To comply with medical data privacy guidelines (such as HIPAA / digital healthcare standards), specific tables contain sensitive personal identifiable information (PII) or protected health information (PHI) that **MUST** be encrypted at rest. These are marked with a 🔒 lock icon.

### Query Indexing
To preserve high performance and low-latency rendering across the mobile app and simulation viewports, fields that are frequently queried, filtered, or sorted **MUST** have explicit indexes configured. These are marked with a ⚡ bolt icon.

---

## 3. Database Schema / Collections Reference

### 1. `users`
Represents the core authentication and credential registry for all platform actors.
*   **Database Engine Mapping**: `/users` collection (Firestore) or `users` table (SQL)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `user_id` | `VARCHAR(50)` | **Primary Key** | Unique system user ID | ⚡ Index |
| `email` | `VARCHAR(100)` | Unique | User's email address | 🔒 Encrypted (PII) / ⚡ Index |
| `phone` | `VARCHAR(20)` | Unique | User's authenticated phone number | 🔒 Encrypted (PII) / ⚡ Index |
| `password_hash` | `VARCHAR(255)` | Nullable | Encrypted password (for email log-in) | 🔒 One-way Hashed |
| `role` | `ENUM` | `patient`, `doctor`, `pharmacy`, `diagnostic`, `admin` | User's authorization level | ⚡ Index |
| `status` | `ENUM` | `active`, `pending`, `suspended` | Portal access permission status | ⚡ Index |
| `profile_photo_url` | `VARCHAR(500)` | Nullable | URL to user's profile avatar | |
| `fcm_token` | `VARCHAR(255)` | Nullable | Cloud Messaging token for push targets | |
| `created_at` | `TIMESTAMP` | Default: `now()` | Timestamp of registration | |
| `updated_at` | `TIMESTAMP` | Default: `now()` | Timestamp of last modification | |

---

### 2. `patients` 🔒 (Highly Sensitive)
Contains comprehensive medical records, insurance policies, and biographics for registered patients.
*   **Database Engine Mapping**: `/patients` collection (Firestore) or `patients` table (SQL)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `patient_id` | `VARCHAR(50)` | **Primary Key** (FK: `users.user_id`) | Extends parent user profile | ⚡ Index |
| `full_name` | `VARCHAR(100)` | | Patient's full legal name | 🔒 Encrypted (PII) |
| `dob` | `DATE` | | Date of Birth | 🔒 Encrypted (PII) |
| `gender` | `VARCHAR(15)` | | Gender identifier (`Male`/`Female`/`Other`) | |
| `blood_type` | `VARCHAR(5)` | | Blood Group (`A+`, `O-`, etc.) | |
| `allergies` | `ARRAY<TEXT>` | | Declared drug or food allergies | 🔒 Encrypted (PHI) |
| `chronic_conditions` | `ARRAY<TEXT>` | | Diagnosed chronic illnesses | 🔒 Encrypted (PHI) |
| `medical_history_text` | `TEXT` | Nullable | Additional historic medical files/text | 🔒 Encrypted (PHI) |
| `insurance_provider` | `VARCHAR(150)`| Nullable | Active health insurance provider | |
| `insurance_policy_number`| `VARCHAR(100)`| Nullable | Policy/member registration number | 🔒 Encrypted (PHI) |
| `insurance_card_front_url`| `VARCHAR(500)`| Nullable | Storage URL of card front side photo | 🔒 Protected URL |
| `insurance_card_back_url` | `VARCHAR(500)`| Nullable | Storage URL of card back side photo | 🔒 Protected URL |
| `insurance_verified` | `BOOLEAN` | Default: `false` | Status of claim desk validation | ⚡ Index |
| `address` | `TEXT` | Nullable | Resident billing/delivery address | 🔒 Encrypted (PII) |
| `city` | `VARCHAR(100)` | Nullable | Resident serviceable city | ⚡ Index |

---

### 3. `doctors`
Stores professional profiles, pricing rates, and validation structures for medical specialists.
*   **Database Engine Mapping**: `/doctors` collection (Firestore) or `doctors` table (SQL)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `doctor_id` | `VARCHAR(50)` | **Primary Key** (FK: `users.user_id`) | Extends parent user profile | ⚡ Index |
| `full_name` | `VARCHAR(100)` | | Doctor's full professional name | ⚡ Index |
| `specialty` | `VARCHAR(100)` | FK: `specialties.name` | Core medical specialty | ⚡ Index |
| `sub_specialties` | `ARRAY<TEXT>` | | Extended sub-specialties | |
| `bmdc_license_number` | `VARCHAR(50)` | Unique | Bangladesh Medical & Dental Council ID | 🔒 Encrypted / ⚡ Index |
| `license_doc_url` | `VARCHAR(500)` | | Storage path to license certification | 🔒 Protected URL |
| `experience_years` | `INT` | | Cumulative professional practice years | |
| `consultation_fee` | `DECIMAL(10,2)` | | Charging fee for standard live visit | |
| `follow_up_fee` | `DECIMAL(10,2)` | | Charging fee for follow-up consults | |
| `bio` | `TEXT` | Nullable | Professional summary, degrees & profile | |
| `is_online` | `BOOLEAN` | Default: `false` | Active telemedicine availability state | ⚡ Index |
| `rating_avg` | `DECIMAL(3,2)` | Default: `5.00` | Running rating average (1.00 to 5.00) | ⚡ Index |
| `rating_count` | `INT` | Default: `0` | Sum total of reviews received | |
| `doctor_code` | `VARCHAR(15)` | Unique | Short shareable lookup code | ⚡ Index |

---

### 4. `doctor_experience`
Tracks clinical positions, historically completed residencies, and institutional associations.
*   **Database Engine Mapping**: `/doctor_experience` (Firestore Subcollection) or `doctor_experience` (SQL Table)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(50)` | **Primary Key** | Unique experience row ID | |
| `doctor_id` | `VARCHAR(50)` | FK: `doctors.doctor_id` | Associated doctor profile | ⚡ Index |
| `institution_name` | `VARCHAR(200)` | | Name of clinic, hospital, or medical center| |
| `position` | `VARCHAR(150)` | | Held title (e.g. Senior Registrar) | |
| `department` | `VARCHAR(150)` | | Department of work | |
| `start_date` | `DATE` | | Start date of tenure | |
| `end_date` | `DATE` | Nullable | End date of tenure (null if current) | |

---

### 5. `pharmacies`
Registries of licensed pharmacy outlets participating in medicine dispensing & door deliveries.
*   **Database Engine Mapping**: `/pharmacies` collection (Firestore) or `pharmacies` table (SQL)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `pharmacy_id` | `VARCHAR(50)` | **Primary Key** (FK: `users.user_id`) | Extends parent user profile | ⚡ Index |
| `pharmacy_name` | `VARCHAR(150)` | | Corporate or retail brand name | ⚡ Index |
| `owner_name` | `VARCHAR(100)` | | Owner / Managing director's name | |
| `trade_license_number`| `VARCHAR(100)` | Unique | DGDA Pharmacy trade license | 🔒 Encrypted |
| `license_doc_url` | `VARCHAR(500)` | | Storage path to license scan | 🔒 Protected URL |
| `address` | `TEXT` | | Primary headquarters address | |
| `city` | `VARCHAR(100)` | | Headquarters operational city | ⚡ Index |
| `branches` | `ARRAY<JSON>` | | [{`branch_name`, `address`, `city`}] | |

---

### 6. `diagnostic_centres`
Details of diagnostic laboratories fulfilling pathology orders, imaging, and home collections.
*   **Database Engine Mapping**: `/diagnostic_centres` collection (Firestore) or `diagnostic_centres` table (SQL)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `lab_id` | `VARCHAR(50)` | **Primary Key** (FK: `users.user_id`) | Extends parent user profile | ⚡ Index |
| `center_name` | `VARCHAR(150)` | | Diagnostic brand name | ⚡ Index |
| `contact_person` | `VARCHAR(100)` | | Authorized point of contact | |
| `license_number` | `VARCHAR(100)` | Unique | DGHS laboratory verification code | 🔒 Encrypted |
| `license_doc_url` | `VARCHAR(500)` | | Storage path to license scan | 🔒 Protected URL |
| `address` | `TEXT` | | Head laboratory address | |
| `city` | `VARCHAR(100)` | | Headquarters operational city | ⚡ Index |
| `branches` | `ARRAY<JSON>` | | [{`branch_name`, `address`, `city`}] | |

---

### 7. `appointments`
Manages telemedicine consultations scheduling, pricing, status flows, and video room handshakes.
*   **Database Engine Mapping**: `/appointments` collection (Firestore) or `appointments` table (SQL)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `appointment_id` | `VARCHAR(50)` | **Primary Key** | Unique appointment identifier | ⚡ Index |
| `patient_id` | `VARCHAR(50)` | FK: `patients.patient_id` | Patient booking the session | ⚡ Index (Composite) |
| `doctor_id` | `VARCHAR(50)` | FK: `doctors.doctor_id` | Practicing specialist booked | ⚡ Index (Composite) |
| `scheduled_time` | `TIMESTAMP` | | Allocated appointment date-time slot | ⚡ Index (Composite) |
| `status` | `ENUM` | `scheduled`, `ongoing`, `completed`, `cancelled` | Status of clinical session lifecycle | ⚡ Index |
| `video_room_id` | `VARCHAR(100)` | | WebRTC tokenized communication channel ID | |
| `doctor_notes` | `TEXT` | Nullable | Primary complaints/notes from checkup | 🔒 Encrypted (PHI) |
| `fee_charged` | `DECIMAL(10,2)` | | Absolute gross cost charged | |
| `payment_status` | `ENUM` | `pending`, `paid`, `refunded` | Status of transactional processing | |
| `created_at` | `TIMESTAMP` | Default: `now()` | Date the booking was logged | |

> 💡 **Recommended Composite Indexes**:
> *   `doctor_id` + `scheduled_time` + `status` (for swift calendar generation and appointment overlap checking)
> *   `patient_id` + `scheduled_time` (for populating historical records chronologically)

---

### 8. `prescriptions` 🔒 (Highly Sensitive)
The official medical prescription compiled and signed by the consulting specialist.
*   **Database Engine Mapping**: `/prescriptions` collection (Firestore) or `prescriptions` table (SQL)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `prescription_id` | `VARCHAR(50)` | **Primary Key** | Unique signed clinical Rx ID | ⚡ Index |
| `appointment_id` | `VARCHAR(50)` | FK: `appointments.id` | Associated live consultation session | ⚡ Index |
| `patient_id` | `VARCHAR(50)` | FK: `patients.patient_id` | Receiving patient profile | ⚡ Index |
| `doctor_id` | `VARCHAR(50)` | FK: `doctors.doctor_id` | Prescribing medical practitioner | ⚡ Index |
| `chief_complaints`| `ARRAY<TEXT>` | | Reported symptoms & physical indicators| 🔒 Encrypted (PHI) |
| `diagnosis` | `ARRAY<TEXT>` | | Presumptive or verified diagnoses | 🔒 Encrypted (PHI) |
| `on_examination_text`| `TEXT` | Nullable | Vital stats, BP, pulse taken | 🔒 Encrypted (PHI) |
| `medications` | `ARRAY<JSON>` | | Array of [{`name`, `dosage`, `frequency`, `duration`, `instructions`}] | 🔒 Encrypted (PHI) |
| `advice_text` | `TEXT` | Nullable | Additional diet/exercise guidance | 🔒 Encrypted (PHI) |
| `follow_up_date` | `DATE` | Nullable | Recommended date for next checkup | |
| `pdf_url` | `VARCHAR(500)` | | Signed digital PDF format path | 🔒 Protected URL |
| `sent_to_pharmacy_id`| `VARCHAR(50)` | Nullable (FK: `pharmacies`) | Connected pharmacy for order placement | ⚡ Index |
| `created_at` | `TIMESTAMP` | Default: `now()` | Generation timestamp of script | |

---

### 9. `pharmacy_orders`
Tracks pharmaceutical orders, prescriptions verification, packaging logs, and deliveries.
*   **Database Engine Mapping**: `/pharmacy_orders` collection (Firestore) or `pharmacy_orders` table (SQL)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `order_id` | `VARCHAR(50)` | **Primary Key** | Unique parcel delivery ID | ⚡ Index |
| `prescription_id` | `VARCHAR(50)` | Nullable (FK: `prescriptions`)| Authenticating prescription (if required)| ⚡ Index |
| `patient_id` | `VARCHAR(50)` | FK: `patients.patient_id` | Ordering consumer | ⚡ Index |
| `pharmacy_id` | `VARCHAR(50)` | FK: `pharmacies.pharmacy_id` | Fulfilling licensed apothecary outlet | ⚡ Index |
| `items` | `ARRAY<JSON>` | | [{`medicine_name`, `qty`, `unit_price`}] | |
| `subtotal` | `DECIMAL(10,2)` | | Cumulative item net totals | |
| `delivery_charge` | `DECIMAL(10,2)` | | Out-of-pocket transportation charge | |
| `total` | `DECIMAL(10,2)` | | Total checkout price | |
| `status` | `ENUM` | `pending`, `verified`, `packing`, `packed`, `out_for_delivery`, `delivered` | Step of package assembly & dispatch | ⚡ Index |
| `payment_type` | `ENUM` | `cod` (Cash on delivery), `online` | Payment channel preference | |
| `created_at` | `TIMESTAMP` | Default: `now()` | Ordering timestamp | |

---

### 10. `diagnostic_orders`
Pathology test bookings, home sample extraction setups, and laboratory status flows.
*   **Database Engine Mapping**: `/diagnostic_orders` collection (Firestore) or `diagnostic_orders` table (SQL)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `order_id` | `VARCHAR(50)` | **Primary Key** | Unique laboratory task ID | ⚡ Index |
| `appointment_id` | `VARCHAR(50)` | Nullable (FK: `appointments`) | Linked tele-consultation | ⚡ Index |
| `patient_id` | `VARCHAR(50)` | FK: `patients.patient_id` | Patient ordering test | ⚡ Index |
| `lab_id` | `VARCHAR(50)` | FK: `diagnostic_centres` | Fulfilling diagnostic brand | ⚡ Index |
| `test_names` | `ARRAY<TEXT>` | | List of catalog tests ordered | |
| `collection_type` | `ENUM` | `home`, `in_lab` | Specimen extraction preference | |
| `collection_datetime`| `TIMESTAMP` | | Scheduled extraction date-time slot | |
| `sample_id_qr` | `VARCHAR(100)` | Nullable | Printed QR identifier for vials/swabs | ⚡ Index |
| `status` | `ENUM` | `pending`, `sample_collected`, `processing`, `report_ready`, `delivered` | Specimen extraction and lab diagnostics stage | ⚡ Index |
| `report_pdf_url` | `VARCHAR(500)` | Nullable | Uploaded laboratory report PDF path | 🔒 Protected URL |
| `verified_by_text` | `VARCHAR(200)` | Nullable | Signing pathologist details | |
| `created_at` | `TIMESTAMP` | Default: `now()` | Booking creation time | |

---

### 11. `feed_posts`
Enables qualified health professionals to write informational medical logs & public tips.
*   **Database Engine Mapping**: `/feed_posts` collection (Firestore) or `feed_posts` table (SQL)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `post_id` | `VARCHAR(50)` | **Primary Key** | Unique social post ID | ⚡ Index |
| `author_user_id` | `VARCHAR(50)` | FK: `users.user_id` | Authoring user ID | ⚡ Index |
| `author_role` | `VARCHAR(30)` | | Author portal role (e.g. `doctor`) | |
| `caption_text` | `TEXT` | | Primary educational or textual content | |
| `media_urls` | `ARRAY<TEXT>` | | Static asset or clip paths | |
| `media_type` | `ENUM` | `image`, `video`, `none` | File type identifier | |
| `created_at` | `TIMESTAMP` | Default: `now()` | Publication date-time | ⚡ Index (Sorted) |

---

### 12. `feed_comments`
Aggregates public queries, discussions, and practitioner feedbacks on feed articles.
*   **Database Engine Mapping**: `/feed_comments` (Firestore Subcollection) or `feed_comments` (SQL Table)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `comment_id` | `VARCHAR(50)` | **Primary Key** | Unique comment ID | |
| `post_id` | `VARCHAR(50)` | FK: `feed_posts.post_id` | Root post parent | ⚡ Index |
| `user_id` | `VARCHAR(50)` | FK: `users.user_id` | Author of comment | |
| `text` | `TEXT` | | Content text of comment | |
| `created_at` | `TIMESTAMP` | Default: `now()` | Comment submission timestamp | |

---

### 13. `feed_likes`
Saves social "like" interactions, preventing multiple reactions from a single user.
*   **Database Engine Mapping**: `/feed_likes` (Firestore Subcollection) or `feed_likes` (SQL Table)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(50)` | **Primary Key** | Unique row ID | |
| `post_id` | `VARCHAR(50)` | FK: `feed_posts.post_id` | Target post | ⚡ Index (Composite) |
| `user_id` | `VARCHAR(50)` | FK: `users.user_id` | Interacting user | ⚡ Index (Composite) |

---

### 14. `chat_threads`
Direct messaging structures facilitating coordination between patients and healthcare endpoints.
*   **Database Engine Mapping**: `/chat_threads` collection (Firestore) or `chat_threads` table (SQL)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `thread_id` | `VARCHAR(50)` | **Primary Key** | Unique messaging room ID | ⚡ Index |
| `participant_ids` | `ARRAY<VARCHAR(50)>`| Unique Array (size = 2) | Member IDs (e.g., patient + pharmacist) | ⚡ Index (Array Contains) |
| `last_message_text`| `TEXT` | Nullable | Preview snippet of last message | |
| `last_message_at` | `TIMESTAMP` | | Timestamp of last activity | ⚡ Index (Sorted) |

---

### 15. `chat_messages`
Real-time text & asset delivery structures.
*   **Database Engine Mapping**: `/chat_messages` (Firestore Subcollection) or `chat_messages` (SQL Table)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `message_id` | `VARCHAR(50)` | **Primary Key** | Unique message ID | |
| `thread_id` | `VARCHAR(50)` | FK: `chat_threads.thread_id` | Associated thread parent | ⚡ Index (Composite) |
| `sender_id` | `VARCHAR(50)` | FK: `users.user_id` | Authoring participant | |
| `text` | `TEXT` | Nullable | Sent text contents | 🔒 Encrypted |
| `image_url` | `VARCHAR(500)` | Nullable | URL to chat shared photo attachment | |
| `created_at` | `TIMESTAMP` | Default: `now()` | Dispatch timestamp | ⚡ Index (Composite) |
| `read` | `BOOLEAN` | Default: `false` | Message read status | |

> 💡 **Recommended Composite Index**:
> *   `thread_id` + `created_at` (to retrieve chronologically ordered chat history)

---

### 16. `reviews`
Stores review logs, ratings, and textual summaries provided by patients following checkups.
*   **Database Engine Mapping**: `/reviews` collection (Firestore) or `reviews` table (SQL)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `review_id` | `VARCHAR(50)` | **Primary Key** | Unique feedback ID | ⚡ Index |
| `doctor_id` | `VARCHAR(50)` | FK: `doctors.doctor_id` | Associated doctor profile | ⚡ Index |
| `patient_id` | `VARCHAR(50)` | FK: `patients.patient_id` | Reviewing patient profile | |
| `appointment_id` | `VARCHAR(50)` | FK: `appointments.appointment_id` | Checked visit session | |
| `rating` | `INT` | Range: `1-5` | Rating numerical value | |
| `comment` | `TEXT` | Nullable | Content text of review | |
| `created_at` | `TIMESTAMP` | Default: `now()` | Review logging timestamp | |

---

### 17. `specialties` (Admin Configured)
Primary registry of serviceable clinical disciplines.
*   **Database Engine Mapping**: `/specialties` collection (Firestore) or `specialties` table (SQL)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(50)` | **Primary Key** | Unique specialty ID | |
| `name` | `VARCHAR(100)` | Unique | Display name (e.g. `Cardiologist`) | ⚡ Index |
| `icon_name` | `VARCHAR(50)` | | Material / Lucide icon glyph mapping ID | |

---

### 18. `lab_test_catalog` (Admin Configured)
The official catalog of tests and pathology diagnostic screenings.
*   **Database Engine Mapping**: `/lab_test_catalog` collection (Firestore) or `lab_test_catalog` table (SQL)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(50)` | **Primary Key** | Unique test catalog item ID | |
| `test_name` | `VARCHAR(150)` | Unique | Clinical test title (e.g. `Lipid Profile`)| ⚡ Index |
| `description` | `TEXT` | | Technical information & guidelines | |
| `base_price` | `DECIMAL(10,2)` | | Default price | |

---

### 19. `cities_zones` (Admin Configured)
Registry of serviceable geopolitical regions to manage physical medicine delivery coverage.
*   **Database Engine Mapping**: `/cities_zones` collection (Firestore) or `cities_zones` table (SQL)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(50)` | **Primary Key** | Unique zone ID | |
| `city_name` | `VARCHAR(100)` | Unique | Serviceable city name (e.g. `Dhaka`) | ⚡ Index |
| `is_serviceable` | `BOOLEAN` | Default: `true` | Platform delivery availability status | |

---

### 20. `audit_logs` (Admin / Compliance Only)
Security and tracking logs capturing administrative updates and system operations.
*   **Database Engine Mapping**: `/audit_logs` collection (Firestore) or `audit_logs` table (SQL)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(50)` | **Primary Key** | Unique ledger entry ID | ⚡ Index |
| `actor_user_id` | `VARCHAR(50)` | FK: `users.user_id` | ID of user performing action | ⚡ Index |
| `action_text` | `TEXT` | | Log statement detailing operation | |
| `target_user_id`| `VARCHAR(50)` | Nullable (FK: `users.user_id`) | ID of user affected by action | ⚡ Index |
| `created_at` | `TIMESTAMP` | Default: `now()` | Absolute entry logging time | ⚡ Index (Sorted) |

---

### 21. `support_tickets`
Customer care and engineering tickets submitted by active application users.
*   **Database Engine Mapping**: `/support_tickets` collection (Firestore) or `support_tickets` table (SQL)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `ticket_id` | `VARCHAR(50)` | **Primary Key** | Unique ticketing system ID | ⚡ Index |
| `user_id` | `VARCHAR(50)` | FK: `users.user_id` | Submitting client ID | ⚡ Index |
| `subject` | `VARCHAR(200)` | | Core problem description | |
| `status` | `ENUM` | `open`, `in_progress`, `resolved` | Active stage of support ticket | ⚡ Index |
| `created_at` | `TIMESTAMP` | Default: `now()` | Issue logging timestamp | |

---

### 22. `support_messages`
Iterative dialogues and messaging exchanges occurring within an active support ticket.
*   **Database Engine Mapping**: `/support_messages` (Firestore Subcollection) or `support_messages` (SQL Table)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(50)` | **Primary Key** | Unique message detail row ID | |
| `ticket_id` | `VARCHAR(50)` | FK: `support_tickets.ticket_id` | Associated support ticket | ⚡ Index |
| `sender_id` | `VARCHAR(50)` | FK: `users.user_id` | Messaging participant (user or staff) | |
| `text` | `TEXT` | | Dialogue message content | |
| `created_at` | `TIMESTAMP` | Default: `now()` | Message timestamp | |

---

### 23. `platform_settings` (Admin Managed)
Key-Value configurations used to tune application-wide features and parameters.
*   **Database Engine Mapping**: `/platform_settings` collection (Firestore) or `platform_settings` table (SQL)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `key` | `VARCHAR(100)` | **Primary Key** | Global setting lookup key (e.g. `vat_percent`)| ⚡ Index |
| `value` | `TEXT` | | Config value string (e.g. `15.0`) | |

---

### 24. `notifications`
Historic logs of push notifications dispatched to user accounts.
*   **Database Engine Mapping**: `/notifications` collection (Firestore) or `notifications` table (SQL)

| Field Name | Data Type | Key / Constraint | Description | Encryption / Index |
| :--- | :--- | :--- | :--- | :--- |
| `id` | `VARCHAR(50)` | **Primary Key** | Unique notification ID | |
| `user_id` | `VARCHAR(50)` | FK: `users.user_id` | Target recipient | ⚡ Index |
| `title` | `VARCHAR(150)` | | Heading text of notification banner | |
| `body` | `TEXT` | | Description/body content | |
| `type` | `VARCHAR(50)` | | Event type (`reminder`/`order`/`feed`) | |
| `read` | `BOOLEAN` | Default: `false` | Read status | ⚡ Index |
| `created_at` | `TIMESTAMP` | Default: `now()` | Delivery timestamp | ⚡ Index (Sorted) |
