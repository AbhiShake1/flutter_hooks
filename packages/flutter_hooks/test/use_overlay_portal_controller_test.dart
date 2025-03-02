import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/src/framework.dart';
import 'package:flutter_hooks/src/hooks.dart';

import 'mock.dart';

void main() {
  testWidgets('debugFillProperties', (tester) async {
    await tester.pumpWidget(
      HookBuilder(builder: (context) {
        useOverlayPortalController();
        return const SizedBox();
      }),
    );

    await tester.pump();

    final element = tester.element(find.byType(HookBuilder));

    expect(
      element
          .toDiagnosticsNode(style: DiagnosticsTreeStyle.offstage)
          .toStringDeep(),
      equalsIgnoringHashCodes(
        'HookBuilder\n'
        ' │ useOverlayPortalController: OverlayPortalController DETACHED\n'
        ' └SizedBox(renderObject: RenderConstrainedBox#00000)\n',
      ),
    );
  });

  group('useOverlayPortalController', () {
    testWidgets('initial values matches with real constructor', (tester) async {
      late OverlayPortalController controller;
      final controller2 = OverlayPortalController();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: HookBuilder(builder: (context) {
            controller = useOverlayPortalController();
            return Column(
              children: [
                OverlayPortal(
                  controller: controller,
                  overlayChildBuilder: (context) =>
                      const Text('Overlay Portal'),
                ),
                OverlayPortal(
                  controller: controller2,
                  overlayChildBuilder: (context) =>
                      const Text('Overlay Portal 2'),
                ),
              ],
            );
          }),
        ),
      ));
      expect(controller, isA<OverlayPortalController>());
      expect(controller.isShowing, controller2.isShowing);
    });

    testWidgets('check show/hide of overlay portal', (tester) async {
      late OverlayPortalController controller;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: HookBuilder(builder: (context) {
            controller = useOverlayPortalController();
            return OverlayPortal(
              controller: controller,
              overlayChildBuilder: (context) => const Text('Overlay Content'),
            );
          }),
        ),
      ));

      expect(controller.isShowing, false);
      expect(find.text('Overlay Content'), findsNothing);

      controller.show();
      await tester.pump();
      expect(controller.isShowing, true);
      expect(find.text('Overlay Content'), findsOneWidget);

      controller.hide();
      await tester.pump();
      expect(controller.isShowing, false);
      expect(find.text('Overlay Content'), findsNothing);
    });
  });
}
