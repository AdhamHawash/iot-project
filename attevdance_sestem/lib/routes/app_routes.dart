
import 'package:attevdance_sestem/screens/attendance_details_screen.dart';
import 'package:attevdance_sestem/screens/attendance_list_screen.dart';
import 'package:attevdance_sestem/screens/fingerprint_screen.dart';
import 'package:attevdance_sestem/screens/otp_screen.dart';
import 'package:attevdance_sestem/screens/select_instructor_screen.dart';
import 'package:attevdance_sestem/screens/select_section_screen.dart';
import 'package:flutter/material.dart';


class AppRoutes {
static const selectInstructor = '/';
static const otp = '/otp';
static const section = '/section';
static const fingerprint = '/fingerprint';
static const list = '/list';
static const details = '/details';


static Map<String, WidgetBuilder> routes = {
selectInstructor: (_) => const SelectInstructorScreen(),
otp: (_) => const OtpScreen(),
section: (_) => const SelectSectionScreen(),
fingerprint: (_) => const FingerprintScreen(),
list: (_) => const AttendanceListScreen(),
details: (_) => const AttendanceDetailsScreen(),
};
}