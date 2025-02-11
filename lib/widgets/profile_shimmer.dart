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
                  radius: 70,
                  backgroundColor: Colors.grey[300],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // **Shimmer Name & Email Fields**
            _shimmerTextBox(height: 20, width: 250),
            const SizedBox(height: 10),
            _shimmerTextBox(height: 20, width: 200),
            const SizedBox(height: 20),

            // **Shimmer Portfolio & Bio Fields**
            _shimmerTextBox(height: 15, width: double.infinity),
            const SizedBox(height: 10),
            _shimmerTextBox(height: 15, width: double.infinity),
            const SizedBox(height: 20),

            // **Shimmer Skills Section**
            _shimmerTextBox(height: 15, width: 100),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: List.generate(3, (index) => _shimmerChip()),
            ),
            const SizedBox(height: 20),

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
          ],
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
