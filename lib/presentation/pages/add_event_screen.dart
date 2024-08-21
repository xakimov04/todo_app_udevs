import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app_udevs/core/utils/constants.dart';
import 'package:todo_app_udevs/domain/entities/event.dart';
import 'package:todo_app_udevs/presentation/blocs/event_bloc/event_bloc.dart';
import 'package:todo_app_udevs/presentation/widgets/add_event_screen/color_picker_dialog.dart';
import 'package:todo_app_udevs/presentation/widgets/add_event_screen/labelled_text_field.dart';
import 'package:todo_app_udevs/presentation/widgets/add_event_screen/priority_color_picker.dart';

class AddEventScreen extends StatefulWidget {
  final Event? event;
  final DateTime? dateTime;

  const AddEventScreen({super.key, this.event, this.dateTime});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  Color _selectedColor = Colors.red;

  DateTime? _selectedStartTime;
  DateTime? _selectedEndTime;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _nameController.text = widget.event!.name;
      _descriptionController.text = widget.event!.description;
      _locationController.text = widget.event!.location;
      _selectedStartTime = widget.event!.dateTime;
      _selectedEndTime = widget.event!.endTime as DateTime?; 
      _startTimeController.text = _formatDateTime(_selectedStartTime!);
      _endTimeController.text = _formatDateTime(_selectedEndTime!);
      _selectedColor = Color(widget.event!.color);
    } else {
      // Set the current time as the default start time
      _selectedStartTime = DateTime.now();
      _startTimeController.text = _formatDateTime(_selectedStartTime!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (_) => ColorPickerDialog(
        initialColor: _selectedColor,
        onColorSelected: (color) {
          setState(() {
            _selectedColor = color;
          });
        },
      ),
    );
  }

  bool _validateFields() {
    return _nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _startTimeController.text.isNotEmpty &&
        _endTimeController.text.isNotEmpty;
  }

  void _addOrUpdateEvent() {
    if (_validateFields() &&
        _selectedStartTime != null &&
        _selectedEndTime != null) {
      final event = Event(
        id: widget.event?.id,
        name: _nameController.text,
        description: _descriptionController.text,
        location: _locationController.text,
        time: _startTimeController.text, // Store the start time in 'time'
        endTime: _endTimeController.text, // Store the end time in 'endTime'
        color: _selectedColor.value,
        dateTime: _selectedStartTime!,
      );

      if (widget.event == null) {
        context.read<EventBloc>().add(AddNewEvent(event));
      } else {
        context.read<EventBloc>().add(UpdateExistingEvent(event));
      }
      Navigator.of(context).pop(event);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickDateTime(TextEditingController controller,
      {required bool isStartTime}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartTime && _selectedStartTime != null
          ? _selectedStartTime!
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            isStartTime && _selectedStartTime != null
                ? _selectedStartTime!
                : DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          final selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          controller.text = _formatDateTime(selectedDateTime);

          if (isStartTime) {
            _selectedStartTime = selectedDateTime;
          } else {
            _selectedEndTime = selectedDateTime;
          }
        });
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} "
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 80,
        color: Colors.transparent,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _addOrUpdateEvent,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              widget.event == null ? 'Add' : 'Update',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelledTextField(
                label: 'Event name',
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              LabelledTextField(
                label: 'Event description',
                controller: _descriptionController,
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              LabelledTextField(
                label: 'Event location',
                controller: _locationController,
                suffixIcon: Icons.location_on,
              ),
              const SizedBox(height: 16),
              PriorityColorPicker(
                selectedColor: _selectedColor,
                onTap: _showColorPicker,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                child: LabelledTextField(
                  label: 'Event start date & time',
                  controller: _startTimeController,
                  suffixIcon: Icons.access_time,
                  onTap: () =>
                      _pickDateTime(_startTimeController, isStartTime: true),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                child: LabelledTextField(
                  label: 'Event end date & time',
                  controller: _endTimeController,
                  suffixIcon: Icons.access_time,
                  onTap: () =>
                      _pickDateTime(_endTimeController, isStartTime: false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
