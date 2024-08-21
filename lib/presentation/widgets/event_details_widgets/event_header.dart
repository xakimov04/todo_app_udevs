import 'package:flutter/material.dart';
import 'package:todo_app_udevs/domain/entities/event.dart';

class EventHeader extends StatelessWidget {
  final Event event;
  final VoidCallback onEdit;

  const EventHeader({super.key, required this.event, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 230.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            color: Color(event.color),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                event.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.access_time_filled, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    '${event.time.substring(10, 16)} - ${event.endTime.substring(10, 16)}', // Display start and end times only
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    event.location,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            children: [
              IconButton(
                icon: Image.asset(
                  "assets/icons/edit.png",
                  width: 18,
                  height: 18,
                  fit: BoxFit.cover,
                ),
                onPressed: onEdit,
              ),
              const Text(
                "Edit",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
