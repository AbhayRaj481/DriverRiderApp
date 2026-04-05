

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

  //RoutesName.chooseLocationByMapScreen
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
          Row(
            children: [
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
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        IconButton(
                            onPressed: () async {
                              var data = await context.push(RoutesName.chooseLocationByMapScreen) as Map;
                              _pickupController.text = data["address"];
                              if(widget.onPickupChanged != null) widget.onPickupChanged!(data["address"]);
                              setState(() {});
                            },
                            icon: Icon(
                                Icons.pin_drop_outlined,
                              color: AppColors.black,
                              size: 21,
                            )
                        )
                      ],
                    ),


                    if(_pickupController.text.trim().isNotEmpty)...[
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
                          const SizedBox(width: 5,),
                          IconButton(
                              onPressed: () async {
                                var data = await context.push(RoutesName.chooseLocationByMapScreen) as Map;
                                _destinationController.text = data["address"];
                                if(widget.onDestinationChanged != null) widget.onDestinationChanged!(data["address"]);
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.pin_drop_outlined,
                                color: AppColors.black,
                                size: 21,
                              )
                          )
                        ],
                      )
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
