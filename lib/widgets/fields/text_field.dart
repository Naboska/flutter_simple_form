import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_form/flutter_simple_form.dart';

export 'package:flutter/services.dart';

typedef STextFieldDecorationBuilder = InputDecoration Function(
  SFieldState<String, STextField> field,
  InputDecoration decoration,
);

class STextField extends SFieldWidget<String> {
  /// Build custom decoration.
  final STextFieldDecorationBuilder? decorationBuilder;

  /// [TextField.decoration].
  final InputDecoration decoration;

  /// [TextField.keyboardType].
  final TextInputType? keyboardType;

  /// [TextField.textInputAction].
  final TextInputAction? textInputAction;

  /// [TextField.textCapitalization].
  final TextCapitalization textCapitalization;

  /// [TextField.style].
  final TextStyle? style;

  /// [TextField.strutStyle].
  final StrutStyle? strutStyle;

  /// [TextField.textAlign].
  final TextAlign textAlign;

  /// [TextField.textAlignVertical].
  final TextAlignVertical? textAlignVertical;

  /// [TextField.textDirection].
  final TextDirection? textDirection;

  /// [TextField.autofocus].
  final bool autofocus;

  /// [TextField.obscuringCharacter].
  final String obscuringCharacter;

  /// [TextField.obscureText].
  final bool obscureText;

  /// [TextField.autocorrect].
  final bool autocorrect;

  /// [TextField.smartDashesType].
  final SmartDashesType? smartDashesType;

  /// [TextField.smartQuotesType].
  final SmartQuotesType? smartQuotesType;

  /// [TextField.enableSuggestions].
  final bool enableSuggestions;

  /// [TextField.maxLines].
  final int? maxLines;

  /// [TextField.minLines].
  final int? minLines;

  /// [TextField.expands].
  final bool expands;

  /// [TextField.readOnly].
  final bool readOnly;

  /// [TextField.toolbarOptions].
  final ToolbarOptions? toolbarOptions;

  /// [TextField.showCursor].
  final bool? showCursor;

  /// [TextField.maxLength].
  final int? maxLength;

  /// [TextField.maxLengthEnforcement].
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// [TextField.onChanged].
  final ValueChanged<String>? onChanged;

  /// [TextField.onEditingComplete].
  final VoidCallback? onEditingComplete;

  /// [TextField.onSubmitted].
  final ValueChanged<String>? onSubmitted;

  /// [TextField.onAppPrivateCommand].
  final AppPrivateCommandCallback? onAppPrivateCommand;

  /// [TextField.inputFormatters].
  final List<TextInputFormatter>? inputFormatters;

  /// [TextField.enabled].
  final bool? enabled;

  /// [TextField.cursorWidth].
  final double cursorWidth;

  /// [TextField.cursorHeight].
  final double? cursorHeight;

  /// [TextField.cursorRadius].
  final Radius? cursorRadius;

  /// [TextField.cursorColor].
  final Color? cursorColor;

  /// [TextField.selectionHeightStyle].
  final ui.BoxHeightStyle selectionHeightStyle;

  /// [TextField.selectionWidthStyle].
  final ui.BoxWidthStyle selectionWidthStyle;

  /// [TextField.keyboardAppearance].
  final Brightness? keyboardAppearance;

  /// [TextField.scrollPadding].
  final EdgeInsets scrollPadding;

  /// [TextField.enableInteractiveSelection].
  final bool? enableInteractiveSelection;

  /// [TextField.selectionControls].
  final TextSelectionControls? selectionControls;

  /// [TextField.dragStartBehavior].
  final DragStartBehavior dragStartBehavior;

  /// [TextField.onTap].
  final GestureTapCallback? onTap;

  /// [TextField.mouseCursor].
  final MouseCursor? mouseCursor;

  /// [TextField.buildCounter].
  final InputCounterWidgetBuilder? buildCounter;

  /// [TextField.scrollPhysics].
  final ScrollPhysics? scrollPhysics;

  /// [TextField.scrollController].
  final ScrollController? scrollController;

  /// [TextField.autofillHints].
  final Iterable<String>? autofillHints;

  /// [TextField.clipBehavior].
  final Clip clipBehavior;

  /// [TextField.restorationId].
  final String? restorationId;

  /// [TextField.scribbleEnabled].
  final bool scribbleEnabled;

  /// [TextField.enableIMEPersonalizedLearning].
  final bool enableIMEPersonalizedLearning;

  const STextField({
    required super.name,
    super.key,
    this.decorationBuilder,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.toolbarOptions,
    this.showCursor,
    this.autofocus = false,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection,
    this.selectionControls,
    this.onTap,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const <String>[],
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scribbleEnabled = true,
    this.enableIMEPersonalizedLearning = true,
  });

  /// Adds an error from the [SFormFieldState.errorMessage] to the current decorator.
  static InputDecoration buildErrorDecoration(
    SFieldState<String, STextField> field,
    InputDecoration decoration,
  ) {
    final errorMessage = field.state.errorMessage;
    final isValid = field.state.isTouched || field.formState.isSubmitting
        ? errorMessage == null
        : true;

    return decoration.copyWith(errorText: isValid ? null : errorMessage);
  }

  @override
  SFieldState<String, STextField> createState() => STextFieldState();
}

class STextFieldState extends SFieldState<String, STextField> {
  final focusNode = FocusNode();
  final controller = TextEditingController();

  String get _currentValue => controller.text;

  @override
  void initState() {
    super.initState();

    void touchListener() {
      touch();
      focusNode.removeListener(touchListener);
    }

    focusNode.addListener(touchListener);
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void notify() {
    super.notify();
    if (_currentValue == state.value) return;
    controller.text = state.value ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: setValue,
      decoration: widget.decorationBuilder?.call(this, widget.decoration) ??
          widget.decoration,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      textDirection: widget.textDirection,
      readOnly: widget.readOnly,
      toolbarOptions: widget.toolbarOptions,
      showCursor: widget.showCursor,
      autofocus: widget.autofocus,
      obscuringCharacter: widget.obscuringCharacter,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      enableSuggestions: widget.enableSuggestions,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      onAppPrivateCommand: widget.onAppPrivateCommand,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor,
      selectionHeightStyle: widget.selectionHeightStyle,
      selectionWidthStyle: widget.selectionWidthStyle,
      keyboardAppearance: widget.keyboardAppearance,
      scrollPadding: widget.scrollPadding,
      dragStartBehavior: widget.dragStartBehavior,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      selectionControls: widget.selectionControls,
      onTap: widget.onTap,
      mouseCursor: widget.mouseCursor,
      buildCounter: widget.buildCounter,
      scrollController: widget.scrollController,
      scrollPhysics: widget.scrollPhysics,
      autofillHints: widget.autofillHints,
      clipBehavior: widget.clipBehavior,
      restorationId: widget.restorationId,
      scribbleEnabled: widget.scribbleEnabled,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
    );
  }
}
