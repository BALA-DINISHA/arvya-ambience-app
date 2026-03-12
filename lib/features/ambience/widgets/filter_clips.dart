import 'package:flutter/material.dart';

class FilterChips extends StatefulWidget {
  final Function(String?) onTagSelected;

  const FilterChips({super.key, required this.onTagSelected});

  @override
  State<FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  String? selectedTag;
  final List<String> tags = const ['Focus', 'Calm', 'Sleep', 'Reset'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip('All', null),
          const SizedBox(width: 8),
          ...tags.map((tag) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildChip(tag, tag),
          )),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String? value) {
    final isSelected = selectedTag == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTag = isSelected ? null : value;
        });
        widget.onTagSelected(selectedTag);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _getTagColor(value) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? _getTagColor(value) : Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: _getTagColor(value).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1E2B3A),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Color _getTagColor(String? tag) {
    switch (tag) {
      case 'Focus':
        return const Color(0xFF4A90E2); // Soft blue
      case 'Calm':
        return const Color(0xFF50C878); // Emerald green
      case 'Sleep':
        return const Color(0xFF9B59B6); // Purple
      case 'Reset':
        return const Color(0xFFF39C12); // Orange
      default:
        return const Color(0xFF95A5A6); // Gray
    }
  }
}