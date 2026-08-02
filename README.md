# Project Overview – Quran Circle Teacher Mobile Application

## Introduction

This project is a mobile application designed specifically for Quran memorization circles inside a mosque.

The primary goal of the application is to simplify the daily work of Quran circle teachers by providing a fast and easy way to:

* Manage attendance
* Record student recitations
* Conduct Juz examinations
* Access student information
* Allow assistant teachers to perform recitation assessments

The application is intended for daily use inside the mosque and must prioritize speed, simplicity, clarity, and ease of use.

The target users are teachers and assistant teachers, many of whom may not be highly technical, therefore every workflow should require the minimum possible number of steps.

The application is Arabic-first and all interfaces must be fully RTL.

---

# Release Notes

## Version 1.3.0

* Added new examiner role flow for QR-based student lookup and Juz exam management
* Added paginated student and exam lists for examiner workflows
* Improved recitation form with date selection and new failed rating support
* Added safer date validation for exam and recitation filters
* Improved form reset behavior for Juz exam creation

---

# User Roles

The application contains three different user roles.

## 1. Main Teacher (Circle Teacher)

The main teacher is responsible for a specific Quran circle and has access to:

* Viewing assigned circles
* Taking attendance
* Recording recitations for students
* Viewing student details
* Viewing recitation history
* Conducting Juz exams
* Performing quick recitations outside the circle screen

---

## 2. Assistant Teacher (Recitation Examiner)

The assistant teacher does not manage attendance or circles.

The assistant teacher's responsibility is assessing student recitations and Juz exams.

The assistant teacher can:

* Scan student QR codes
* Search students using student IDs
* View student information
* Record recitations with a new failed rating option
* Conduct Juz exams

The assistant teacher has a much simpler interface than the main teacher.

## 3. Examiner Role

The examiner role is a dedicated workflow for managing students and Juz exams.

The examiner can:

* Browse the mosque student list with pagination
* Scan QR codes to open a student directly
* View a student's Juz exam history with pagination
* Create new Juz exams with a resettable form
* Filter Juz exam lists by date, rating, and part number

---

# Core Business Concept

A mosque contains multiple Quran circles.

Each circle contains:

* A teacher
* Multiple students
* A study cycle or academic season

Teachers interact with students daily in two primary activities:

1. Attendance tracking
2. Quran recitation assessment

The application is built around these two activities.

---

# Main Teacher Workflow

## Step 1: Login

The teacher logs in using:

* Username
* Password

After successful login, the teacher enters the application.

---

## Step 2: View Assigned Circles

The teacher sees all active Quran circles assigned to him.

Each circle displays:

* Circle name
* Academic cycle
* Category
* Number of enrolled students

The teacher selects the circle he is currently teaching.

---

## Step 3: Circle Workspace

After opening a circle, the teacher enters the circle workspace.

The workspace contains two main sections:

### Attendance

For recording daily attendance.

### Recitations

For recording Quran recitations.

---

# Attendance Management

Attendance is recorded daily.

When the attendance screen opens:

* Today's date is automatically selected.
* All students in the circle are displayed.

For every student, the teacher selects one attendance status.

Available statuses:

* Present
* Late
* Absent
* Excused Absence

The interface must allow attendance for an entire circle to be completed in less than one minute.

The teacher saves attendance when finished.

---

# Student Recitations

The second major function of the application is recording recitations.

The teacher opens a student profile and creates a new recitation record.

The application supports three different recitation types.

---

## Recitation Type 1: Pages

The teacher records:

* Starting page
* Ending page

The application calculates page count automatically.

The teacher then selects:

* Good
* Very Good
* Excellent
* Failed

Optional notes can be added.

---

## Recitation Type 2: Full Surah

The teacher selects a Quran Surah.

The system contains all 114 Surahs.

For each Surah the system stores:

* Arabic name
* Meccan or Medinan
* Number of verses
* Start page
* End page

Only Arabic names should be displayed.

The teacher selects the Surah and then assigns a rating.

---

## Recitation Type 3: Range of Verses

The teacher:

* Selects a Surah
* Chooses starting verse
* Chooses ending verse

Then assigns a rating and optional notes.

---

# Student Information

Teachers can open detailed student profiles.

A student profile includes:

* Full name
* Student code
* Birth date
* School grade
* Father's name
* Mother's name
* Parent phone numbers
* Student phone number (if available)
* Address
* Additional notes

The profile also displays recitation history.

---

# Recitation History

Teachers can review all previous recitations for a student.

Each recitation record contains:

* Date
* Recitation type
* Rating
* Awarded points
* Recitation details

This allows teachers to track student progress over time.

---

# Quick Recitation Mode

The main teacher also has access to a Quick Recitation screen.

This allows recording a recitation without first entering a specific circle.

The experience is identical to the Assistant Teacher workflow.

---

# Assistant Teacher Workflow

The assistant teacher has a simplified experience.

After login, the assistant teacher lands directly on the Recitation screen.

No circle management exists.

No attendance functionality exists.

---

## Student Identification

The assistant teacher can identify students in two ways.

### Method 1: QR Code

The student presents a QR code.

The assistant teacher scans it.

The system automatically loads the student information.

---

### Method 2: Student ID

The assistant teacher manually enters the student code.

The system loads the student profile.

---

## Recitation Assessment

After identifying the student, the assistant teacher records a recitation using the exact same process as the main teacher.

Supported types:

* Pages
* Surah
* Verse Range

The assistant teacher can also assign ratings and notes.

---

# Juz Examinations

The application supports Juz examinations.

A teacher selects a student and records a passed Juz exam.

The teacher chooses:

* Juz Number (1–30)
* Rating
* Notes

The system already contains metadata for every Juz including:

* Juz name
* Start page
* End page
* Starting Surah
* Starting Verse

When a Juz number is selected, its information should appear automatically.

The teacher then completes the evaluation.

---

# Design Goals

The application must be designed around speed and simplicity.

Key design principles:

* Arabic-first
* RTL layout
* Minimal typing
* Large touch targets
* Fast daily workflows
* Simple navigation
* Clear visual hierarchy
* Modern and professional appearance
* Suitable for mosque and educational environments

The application should feel calm, trustworthy, and easy to use, even for users with limited technical experience.

The most important UX objective is reducing the number of taps and decisions required to complete attendance and recitation tasks.
