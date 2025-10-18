import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:test/presentation/atoms/app_loader_atom.dart';
import 'package:test/presentation/atoms/app_error_atom.dart';

void main() {
  testWidgets('Muestra loader con mensaje', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AppLoaderAtom(message: 'Cargando Pokémon...')),
    );

    expect(find.text('Cargando Pokémon...'), findsOneWidget);
    expect(
      find.byType(CircularProgressIndicator),
      findsNothing,
    ); // loader custom
  });

  testWidgets('Muestra error y botón de reintentar', (tester) async {
    var retried = false;

    await tester.pumpWidget(
      MaterialApp(
        home: AppErrorAtom(
          message: 'No se pudo cargar',
          onRetry: () => retried = true,
        ),
      ),
    );

    expect(find.text('No se pudo cargar'), findsOneWidget);
    await tester.tap(find.text('Reintentar'));
    expect(retried, isTrue);
  });
}
