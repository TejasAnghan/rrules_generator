import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rrules_generator/src/themes/themes.dart';

class CTextField extends StatelessWidget {
  final int? maxLines;
  final bool isPassword;
  final Color fillColor;
  final bool obscureText;
  final bool isUnderline;
  final String? placeholder;
  final FocusNode? focusNode;
  final FocusNode? requestFocus;
  final TextInputType? keyboardType;
  final Function(bool)? iconCallback;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final bool? enabled;
  final Color? errorTextColor;
  // ignore: prefer_typing_uninitialized_variables
  final inputFormatters;
  // ignore: prefer_typing_uninitialized_variables
  final textStyle;

  // ignore: use_key_in_widget_constructors
  const CTextField({
    this.textStyle,
    this.validator,
    this.focusNode,
    this.onChanged,
    this.controller,
    this.placeholder,
    this.maxLines = 1,
    this.requestFocus,
    this.iconCallback,
    this.keyboardType,
    this.textInputAction,
    this.isPassword = false,
    this.obscureText = false,
    this.isUnderline = false,
    this.fillColor = Colors.transparent,
    this.enabled,
    this.errorTextColor,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: TextFormField(
        enabled: enabled,
        // cursorWidth: 1.0,
        // cursorHeight: 30,
        maxLines: maxLines,
        validator: validator,
        focusNode: focusNode,
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        cursorColor: Themes.primaryColor,
        textInputAction: textInputAction,
        // scrollPhysics: Themes.defaultPhysics,
        style: textStyle,
        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(requestFocus),
        textAlignVertical: TextAlignVertical.center,
        onTap: () {},
        decoration: InputDecoration(
          filled: true,
          isDense: true,
          contentPadding: const EdgeInsets.only(top: 30, right: 10, left: 10),
          fillColor: fillColor,
          hintText: placeholder,
          errorStyle: TextStyle(color: errorTextColor ?? Colors.white),
          hintStyle: const TextStyle(fontSize: 16).apply(color: Colors.grey),
          errorBorder: border(Themes.errorColor),
          focusedBorder: border(Themes.textFieldBorderColor),
          enabledBorder: border(Themes.textFieldBorderColor),
          disabledBorder: border(Themes.textFieldBorderColor),
          border: border(Themes.errorColor),
        ),
      ),
    );
  }

  InputBorder border(Color color) {
    return isUnderline
        ? UnderlineInputBorder(borderSide: BorderSide(color: color))
        : OutlineInputBorder(
            borderSide: BorderSide(color: color),
            borderRadius: BorderRadius.circular(6),
          );
  }
}
