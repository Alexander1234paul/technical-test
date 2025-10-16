import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:test/data/models/pokemon_dto.dart';
import 'presentation/pages/preference_list_page.dart';
import 'presentation/pages/preference_detail_page.dart';
import 'presentation/pages/api_item_list_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/prefs',
  routes: [
    GoRoute(
      path: '/prefs',
      builder: (context, state) => const PreferenceListPage(),
    ),

    GoRoute(
      path: '/prefs/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return PreferenceDetailPage(preferenceId: id);
      },
    ),

    GoRoute(
      path: '/api-list',
      builder: (context, state) => const ApiItemListPage(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Gustos App',
      theme: ThemeData.light(),
    );
  }
}
