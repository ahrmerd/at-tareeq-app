import 'package:at_tareeq/app/data/models/section_or_interest.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/decorations.dart';
import 'package:flutter/material.dart';

class LectureDetailsForm extends StatefulWidget {
  final void Function(String title, int sectionId, String description) onSubmit;
  final List<SectionOrInterest> sections;
  final String? label;
  const LectureDetailsForm(
      {super.key, required this.onSubmit, required this.sections, this.label});

  @override
  State<LectureDetailsForm> createState() => _LectureDetailsFormState();
}

class _LectureDetailsFormState extends State<LectureDetailsForm> {
  String _titleField = "";
  String _descriptionField = "";
  int _sectionId = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (val) {
                _titleField = val;
              },
              decoration: myInputDecoration(
                  label: 'Lecture Title', icon: Icon(Icons.title)),
            ),
            const VerticalSpace(20),
            TextField(
              onChanged: (val) {
                _descriptionField = val;
              },
              minLines: 3,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              decoration: myInputDecoration(
                  label: 'Description', icon: Icon(Icons.description)),
            ),
            const VerticalSpace(20),
            DropdownButtonFormField<SectionOrInterest>(
                decoration: myInputDecoration(label: 'Section'),
                items: widget.sections
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name),
                        ))
                    .toList(),
                onChanged: ((value) {
                  if (value != null) {
                    _sectionId = value.id;
                  }
                })),
            const VerticalSpace(20),
            MyButton(
                filled: true,
                maxWidth: true,
                onTap: () =>
                    widget.onSubmit(_titleField, _sectionId, _descriptionField),
                child: Text(widget.label ?? 'Submit'))
          ],
        ),
      )),
    );
  }
}
