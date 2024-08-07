part of 'hooks.dart';

/// Creates [ScrollController] that will be disposed automatically.
///
/// See also:
/// - [ScrollController]
ScrollController useScrollController({
  double initialScrollOffset = 0.0,
  bool keepScrollOffset = true,
  String? debugLabel,
  ScrollControllerCallback? onAttach,
  ScrollControllerCallback? onDetach,
  List<Object?>? keys,
}) {
  return use(
    _ScrollControllerHook(
      initialScrollOffset: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      debugLabel: debugLabel,
      onAttach: onAttach,
      onDetach: onDetach,
      keys: keys,
    ),
  );
}

class _ScrollControllerHook extends Hook<ScrollController> {
  const _ScrollControllerHook({
    required this.initialScrollOffset,
    required this.keepScrollOffset,
    this.debugLabel,
    this.onAttach,
    this.onDetach,
    List<Object?>? keys,
  }) : super(keys: keys);

  final double initialScrollOffset;
  final bool keepScrollOffset;
  final String? debugLabel;
  final ScrollControllerCallback? onAttach;
  final ScrollControllerCallback? onDetach;

  @override
  HookState<ScrollController, Hook<ScrollController>> createState() =>
      _ScrollControllerHookState();
}

class _ScrollControllerHookState
    extends HookState<ScrollController, _ScrollControllerHook> {
  late final controller = ScrollController(
    initialScrollOffset: hook.initialScrollOffset,
    keepScrollOffset: hook.keepScrollOffset,
    debugLabel: hook.debugLabel,
    onAttach: hook.onAttach,
    onDetach: hook.onDetach,
  );

  @override
  ScrollController build(BuildContext context) => controller;

  @override
  void dispose() => controller.dispose();

  @override
  String get debugLabel => 'useScrollController';
}
