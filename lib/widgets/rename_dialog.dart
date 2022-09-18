import 'package:flutter/material.dart';

class RenameDialog extends StatelessWidget {
  final TextEditingController textEditingController;
  final void Function() onSubmit;
  const RenameDialog({
    super.key,
    required this.textEditingController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return SimpleDialog(
      title: Text(
        "Rename list",
        style: theme.textTheme.headline1!.copyWith(fontSize: 20),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  cursorColor: theme.primaryColor,
                  cursorWidth: 3,
                  cursorRadius: const Radius.circular(15),
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "New name",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: onSubmit,
                icon: const Icon(
                  Icons.drive_file_rename_outline_rounded,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
