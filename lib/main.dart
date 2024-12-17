import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shop_fire/providers/theme_mode_provider.dart';
import 'package:shop_fire/screens/auth/auth_screen.dart';
import 'package:shop_fire/screens/cart/providers/cart_provider.dart';
import 'package:shop_fire/screens/home/home_screen.dart';
import 'firebase_options.dart';

// import 'package:shop_fire/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

final kcolorScheme = ColorScheme.fromSeed(
  seedColor: Colors.indigo,
  secondary: Colors.pink,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(themeModeProvider);
      ThemeData theme = ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark().copyWith(primary: Colors.teal),
        switchTheme: const SwitchThemeData(
          thumbColor: MaterialStatePropertyAll(Colors.cyan),
        ),
      );
      if (!ref.read(themeModeProvider.notifier).isDark) {
        theme = ThemeData().copyWith(
          colorScheme: kcolorScheme,
          appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kcolorScheme.background,
            foregroundColor: kcolorScheme.primary,
          ),
          useMaterial3: true,
        );
      }
      return MaterialApp(
        title: 'shop',
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.hasData) {
              return Consumer(
                builder: (context, ref, child) {
                  ref.read(cartProvider.notifier).loadCartItems();
                  ref.read(themeModeProvider.notifier).loadDarkMode();
                  return const HomeScreen();
                },
              );
            }
            return const AuthScreen();
          },
        ),
      );
    });
  }
}




            //   appBar: AppBar(
            //     actions: [
            //       IconButton(
            //         onPressed: () {
            //           FirebaseAuth.instance.signOut();
            //         },
            //         icon: const Icon(Icons.exit_to_app),
            //       ),
            //       IconButton(
            //         onPressed: () {
            //           Navigator.of(context).push(
            //             MaterialPageRoute(
            //               builder: (context) => const AddProductScreen(),
            //             ),
            //           );
            //         },
            //         icon: const Icon(Icons.add),
            //       ),
            //     ],
            //   ),
            //   body: Center(
            //     child: Text('account: ${user!.email}!'),
            //   ),
            // );