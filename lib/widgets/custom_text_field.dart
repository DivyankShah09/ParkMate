import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkmate/widgets/styles.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.onChange,
    required this.validator,
    this.hintText,
    this.obscureText = false,
    this.controller,
    required this.label,
    this.isLoading = false,
    this.keyboardType = TextInputType.text,
  });
  final Function(String) onChange;
  final String? Function(String?) validator;
  final String? hintText;
  final bool obscureText;
  final String label;
  final TextEditingController? controller;
  final bool isLoading;
  final TextInputType keyboardType;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;
  bool isObscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    isObscureText = widget.obscureText;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      onChanged: widget.onChange,
      validator: widget.validator,
      obscureText: isObscureText,
      inputFormatters: widget.keyboardType == TextInputType.number
          ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
          : null,
      decoration: InputDecoration(
        label: Text(widget.label),
        hintText: widget.hintText,
        border: const OutlineInputBorder(
          borderRadius: Corners.medBorder,
        ),
        suffixIcon: widget.isLoading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      )),
                ],
              )
            : _obscureText == false
                ? null
                : IconButton(
                    icon: Icon(
                      isObscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isObscureText = !isObscureText;
                      });
                    },
                  ),
        contentPadding: const EdgeInsets.all(Insets.med),
      ),
    );
  }
}
