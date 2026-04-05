part of '../rider.dart';


class RiderMapBottomSheet extends StatelessWidget {
  final String? pickupAddress;
  final String? destinationAddress;
  final VoidCallback? onSearch;
  const RiderMapBottomSheet({
    super.key,
    this.pickupAddress,
    this.destinationAddress,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.6,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black26),
          ],
        ),
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          padding: const EdgeInsets.all(20),
          children: [
            const Center(
              child: Icon(Icons.drag_handle, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            const Text(
              'Route Details:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildLocationRow(
              'Pickup',
              pickupAddress ?? "",
            ),
            const Divider(),
            _buildLocationRow(
              'Destination',
              destinationAddress ?? "",
            ),

            const SizedBox(height: 21,),
            Row(
              children: [
                Expanded(child:
                CustomMaterialButton(
                  text: 'Search',
                  onPressed: onSearch,
                )
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow(String title, String address) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: title == 'Pickup' ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text('$title: $address')),
        ],
      ),
    );
  }
}
