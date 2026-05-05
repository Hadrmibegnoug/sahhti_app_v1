import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/navigation/navigation_event.dart';
import 'package:sahha_pass/passport_medical/presentation/bloc/navigation/navigation_state.dart';
import 'package:sahha_pass/passport_medical/presentation/screens/chat/conversations_page.dart';
import 'package:sahha_pass/passport_medical/presentation/screens/home/home_page.dart';
import 'package:sahha_pass/passport_medical/presentation/screens/medecin/medecin.dart';
import 'package:sahha_pass/passport_medical/presentation/screens/profile/profile.dart';
import 'package:sahha_pass/passport_medical/presentation/screens/rdv.dart';
import 'package:sahha_pass/passport_medical/presentation/widgets/custom_app_bar.dart';

import '../../../core/constants/app_colors.dart';

class Tabscreen extends StatelessWidget {
  const Tabscreen({super.key});

  static const _pages = [
    HomePage(),
    MedecinListPage(),
    Rdv(),
    ConversationsPage(),
    ProfilePage(),
  ];

  static const _items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home, color: AppColors.primary),
      label: "Accueil",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search, color: AppColors.primary),
      label: "Medecins",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.calendar_today, color: AppColors.primary),
      label: "RDV",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat, color: AppColors.primary),
      label: "Chat",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person, color: AppColors.primary),
      label: "profile",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationBloc(),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          final int index = state is NavigationActive ? state.indexActuel : 0;
          return Scaffold(
            appBar: index == 4 ? null : CustomAppBar(title: "Bonjour Fatima"),
            body: IndexedStack(index: index, children: _pages),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: index,
              selectedIconTheme: IconThemeData(
                color: AppColors.primary,
                size: 30,
              ),
              onTap: (i) =>
                  context.read<NavigationBloc>().add(NavigationOngletChange(i)),
              items: _items,
            ),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:sahha_pass/core/constants/app_colors.dart';
// import 'package:sahha_pass/passport_medical/presentation/screens/chat.dart';
// import 'package:sahha_pass/passport_medical/presentation/screens/medecin/medecin.dart';
// import 'package:sahha_pass/passport_medical/presentation/screens/profile.dart';
// import 'package:sahha_pass/passport_medical/presentation/screens/rdv.dart';

// import '../widgets/custom_app_bar.dart';
// import 'home/home_page.dart';

// class Tabscreen extends StatefulWidget {
//   const Tabscreen({super.key});

//   @override
//   State<Tabscreen> createState() => _TabscreenState();
// }

// class _TabscreenState extends State<Tabscreen> {
//   int _selectedPage = 0;

//   void _selectPage(int index) {
//     setState(() {
//       _selectedPage = index;
//     });
//   }

//   var activePageTitle = "Home";
//   @override
//   Widget build(BuildContext context) {
//     Widget activePage = HomePage();
//     //Widget activePage = DossierMedical();
//     if (_selectedPage == 1) {
//       activePage = Medecin();
//       activePageTitle = "Medecins";
//     } else if (_selectedPage == 2) {
//       activePage = Rdv();
//       activePageTitle = "RDV";
//     } else if (_selectedPage == 3) {
//       activePage = Chat();
//       activePageTitle = "Chat";
//     } else if (_selectedPage == 4) {
//       activePage = Profile();
//       activePageTitle = "Profile";
//     }
//     return Scaffold(
//       appBar: _selectedPage == 4 ? null : CustomAppBar(title: "Bonjour Fatima"),
//       body: activePage,
//       bottomNavigationBar: BottomNavigationBar(
//         onTap: _selectPage,
//         currentIndex: _selectedPage,
//         selectedIconTheme: IconThemeData(color: AppColors.primary, size: 30),
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home, color: AppColors.primary),
//             label: "home",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search, color: AppColors.primary),
//             label: "Medecins",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_today, color: AppColors.primary),
//             label: "RDV",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat, color: AppColors.primary),
//             label: "Chat",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person, color: AppColors.primary),
//             label: "profile",
//           ),
//         ],
//       ),
//     );
//   }
// }
