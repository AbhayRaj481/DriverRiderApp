

part of '../rider.dart';


class RiderMapHeader extends StatefulWidget {
  final Function(String)? onPickupChanged;
  final Function(String)? onDestinationChanged;
  const RiderMapHeader({super.key, this.onPickupChanged, this.onDestinationChanged});

  @override
  State<RiderMapHeader> createState() => _RiderMapHeaderState();
}

class _RiderMapHeaderState extends State<RiderMapHeader> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 1)
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: context.getTopNotchHeight(),),
          // Pickup
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _pickupController,
                    onChanged: widget.onPickupChanged,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: 'Pickup Location',
                      border: OutlineInputBorder(
                          borderRadius: AppStyles.borderRadius_1
                      ),
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 5
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Swap button
          // Pickup to Destination and vice-versa
          IconButton(
              onPressed: (){},
              icon: Icon(
                  Icons.swap_vert_circle,
                size: 28,
                color: AppColors.black.withValues(alpha: .6),
              )
          ),
          // Destination
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _destinationController,
                    onChanged: widget.onDestinationChanged,
                    maxLines: 1,
                    decoration: InputDecoration(
                      labelText: 'Destination',
                      border: OutlineInputBorder(
                          borderRadius: AppStyles.borderRadius_1
                      ),
                      prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5
                        )
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
