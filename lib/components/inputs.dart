import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:habit_quest/common.dart';

enum HabitTextInputType {
  text,
  number,
  email,
  password,
  address,
  searchOptions,
  searchMultiOptions
}

class HabitTextInput extends StatelessWidget {
  const HabitTextInput({
    super.key,
    this.controller,
    this.label,
    this.type,
    this.bSpacing,
    this.placeholder,
    this.options,
    this.helperText,
    this.description,
    this.searchable = false,
    this.focusNode,
    this.readOnly = false,
    this.validator,
    this.obscureText = false,
    this.onSuffixTap,
    this.textInputAction,
    this.autofillHints,
    this.keyboardType,
    this.onTap,
    this.multiline = false,
    this.showRequired = false,
    this.onValueChanged,
    this.canBeNullWhenEmpty = false,
    this.fillColor,
  });

  final TextEditingController? controller;
  final String? label;
  final HabitTextInputType? type;
  final double? bSpacing;
  final String? placeholder;
  final List<String>? options;
  final String? helperText;
  final String? description;
  final bool searchable;
  final FocusNode? focusNode;
  final bool readOnly;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final VoidCallback? onSuffixTap;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final bool multiline;
  final bool showRequired;
  final bool canBeNullWhenEmpty;
  final ValueChanged<String?>? onValueChanged;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    TextFormField textFormField({SearchController? suggestionsBuilder}) {
      return TextFormField(
        controller: controller,
        readOnly: type == HabitTextInputType.address ||
            type == HabitTextInputType.searchOptions ||
            type == HabitTextInputType.searchMultiOptions ||
            readOnly,
        inputFormatters: [
          if (type == HabitTextInputType.number)
            FilteringTextInputFormatter.digitsOnly,
          if (type == HabitTextInputType.email ||
              type == HabitTextInputType.password ||
              type == HabitTextInputType.number)
            FilteringTextInputFormatter.deny(
              RegExp(r'\s'),
            ),
          if (!multiline) FilteringTextInputFormatter.deny('\n'),
        ],
        maxLines: obscureText ? 1 : 3,
        minLines: 1,
        onTapOutside: (event) {
          if (focusNode != null) {
            focusNode!.unfocus();
          }
        },
        autofillHints: autofillHints,
        obscureText: obscureText,
        style: const TextStyle(
          fontFamily: AppTheme.poppinsFont,
        ),
        keyboardType: () {
          if (type == HabitTextInputType.number) {
            return TextInputType.number;
          }
          if (type == HabitTextInputType.email) {
            return TextInputType.emailAddress;
          }
          return keyboardType;
        }(),
        textInputAction: textInputAction,
        onTap: () {
          if (type == HabitTextInputType.searchOptions) {
            suggestionsBuilder?.openView();
          } else if (type == HabitTextInputType.searchMultiOptions) {
            MultiOptionsSelector.show(
              context,
              options ?? [],
              oldSelectedOption: controller?.text,
            ).then((value) {
              if (value != null) {
                controller?.text = value;
              }
            });
          } else {
            onTap?.call();
          }
        },
        validator: (value) {
          if (canBeNullWhenEmpty && value!.isEmpty) {
            return null;
          }
          if (type == HabitTextInputType.email) {
            return emailValidation(value);
          }
          if (type == HabitTextInputType.password) {
            return passwordValidation(value);
          }
          return validator?.call(value);
        },
        onChanged: (value) {
          onValueChanged?.call(value);
        },
        decoration: InputDecoration(
          isDense: true,
          hintText: placeholder,
          filled: fillColor != null,
          fillColor: fillColor,
          helperText: helperText,
          border: const OutlineInputBorder(),
          suffixIcon: () {
            if (type == HabitTextInputType.password) {
              return InkWell(
                onTap: onSuffixTap,
                child: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              );
            }
            return null;
          }(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text.rich(
            TextSpan(
              text: label,
              children: [
                if (showRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
            style: const TextStyle(
              fontFamily: AppTheme.poppinsFont,
            ),
          ),
          const SizedBox(height: 5),
        ],
        if (type == HabitTextInputType.searchOptions)
          SearchAnchor(
            builder: (context, suggestionsBuilder) => textFormField(
              suggestionsBuilder: suggestionsBuilder,
            ),
            suggestionsBuilder: (context, query) {
              return (options ?? []).where((option) {
                return option.toLowerCase().contains(query.text.toLowerCase());
              }).map((location) {
                return ListTile(
                  title: Text(location),
                  onTap: () {
                    context.pop();
                    controller?.text = location;
                    onValueChanged?.call(location);
                  },
                );
              }).toList();
            },
          )
        else
          textFormField(),
        if (description != null)
          Text(
            description!,
            style: const TextStyle(
              fontFamily: AppTheme.poppinsFont,
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        if (bSpacing != null)
          SizedBox(height: bSpacing! - (description != null ? 8 : 0)),
      ],
    );
  }
}

ButtonStyle fullBtnStyle() {
  return FilledButton.styleFrom(
    fixedSize: const Size.fromWidth(double.maxFinite),
  );
}

class MultiOptionsSelector extends StatefulWidget {
  const MultiOptionsSelector({
    required this.options,
    required this.oldSelectedOption,
    super.key,
  });
  final List<String> options;
  final String oldSelectedOption;

  static Future<String?> show(
    BuildContext context,
    List<String> options, {
    String? oldSelectedOption,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return MultiOptionsSelector(
            options: options,
            oldSelectedOption: oldSelectedOption ?? '',
          );
        },
      ),
    );
  }

  @override
  State<MultiOptionsSelector> createState() => _MultiOptionsSelectorState();
}

class _MultiOptionsSelectorState extends State<MultiOptionsSelector> {
  List<String> selectedOptions = [];
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPrevOptions();
  }

  void loadPrevOptions() {
    if (widget.oldSelectedOption.isNotEmpty) {
      selectedOptions = widget.oldSelectedOption.split(', ');
    }
  }

  @override
  Widget build(BuildContext context) {
    final searched = controller.text.isNotEmpty
        ? widget.options.where((option) {
            return option.toLowerCase().contains(controller.text.toLowerCase());
          }).toList()
        : widget.options;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: TextButton(
          onPressed: () {
            if (selectedOptions.isNotEmpty) {
              context.pop(selectedOptions.join(', '));
            } else {
              context.pop();
            }
          },
          child: const Text('Confirm'),
        ),
        title: const Text(
          'Select one or more options',
          style: TextStyle(
            fontSize: 12,
            fontFamily: AppTheme.poppinsFont,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: CupertinoSearchTextField(
              autofocus: true,
              controller: controller,
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                children: [
                  for (final option in selectedOptions)
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Chip(
                        side: const BorderSide(width: .1),
                        label: Text(option),
                        onDeleted: () {
                          setState(() {
                            selectedOptions.remove(option);
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.only(bottom: 60),
              itemCount: searched.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final option = searched[index];
                return ListTile(
                  selected: selectedOptions.contains(option),
                  selectedTileColor: Colors.grey[200],
                  title: Text(option),
                  trailing: selectedOptions.contains(option)
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () {
                    setState(() {
                      if (selectedOptions.contains(option)) {
                        selectedOptions.remove(option);
                      } else {
                        selectedOptions.add(option);
                      }
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
