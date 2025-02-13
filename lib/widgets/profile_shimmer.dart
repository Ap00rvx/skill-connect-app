import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **Shimmer Profile Image**
            Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.grey[300],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // **Shimmer Name & Email Fields**
            _shimmerLabel(width: 80),
            _shimmerTextBox(height: 20, width: double.infinity),
            const SizedBox(height: 15),
            _shimmerLabel(width: 80),
            _shimmerTextBox(height: 20, width: double.infinity),
            const SizedBox(height: 25),

            // **Shimmer Portfolio & Bio Fields**
            _shimmerLabel(width: 130),
            _shimmerTextBox(height: 18, width: double.infinity),
            const SizedBox(height: 15),
            _shimmerLabel(width: 80),
            _shimmerTextBox(height: 50, width: double.infinity), // Bio
            const SizedBox(height: 25),

            // **Shimmer Skills Section**
            _shimmerLabel(width: 60),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(3, (index) => _shimmerChip()),
            ),
            const SizedBox(height: 25),

            // **Shimmer Button**
            Center(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            _shimmerTextBox(height: 70, width: double.infinity),
            const SizedBox(height: 10),
            _shimmerTextBox(height: 70, width: double.infinity),
            const SizedBox(height: 10),
            _shimmerTextBox(height: 70, width: double.infinity),
            const SizedBox(height: 10),
            _shimmerTextBox(height: 70, width: double.infinity),
          ],
        ),
      ),
    );
  }

  // **Helper Widget: Shimmer Label (Title for each field)**
  Widget _shimmerLabel({required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 14,
        width: width,
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    );
  }

  // **Helper Widget: Shimmer Text Box**
  Widget _shimmerTextBox({required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  // **Helper Widget: Shimmer Chip (Skill Tag)**
  Widget _shimmerChip() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 30,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
