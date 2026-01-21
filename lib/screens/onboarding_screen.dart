import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:khataman_app/screens/providers/onboarding_provider.dart';

// class OnboardingScreen extends StatelessWidget {
//   const OnboardingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<OnboardingProvider>(
//       builder: (context, onboardingProvider, child) {
//         return Scaffold(
//           appBar: AppBar(
//             title: Text(
//               'Onboarding - Page ${onboardingProvider.currentPage + 1}',
//             ),
//           ),
//           body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Page ${onboardingProvider.currentPage + 1}',
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: onboardingProvider.currentPage > 0
//                           ? () => onboardingProvider.previousPage()
//                           : null,
//                       child: const Text('Previous'),
//                     ),
//                     const SizedBox(width: 20),
//                     ElevatedButton(
//                       onPressed: onboardingProvider.currentPage < 2
//                           ? () => onboardingProvider.nextPage()
//                           : null,
//                       child: const Text('Next'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(235, 244, 221, 1.000),
      body: Column(),
    );
  }
}
