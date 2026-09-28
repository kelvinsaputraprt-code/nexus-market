import 'package:flutter/material.dart';

import '../data/address_manager.dart';

class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F5FC),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'My Addresses',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: addressManager,
        builder: (context, _) {
          final addresses =
              addressManager.addresses;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Shipping Addresses',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Pilih alamat yang ingin kamu gunakan '
                'untuk pengiriman.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 18),

              ...addresses.map(
                (address) {
                  return _buildAddressCard(
                    context,
                    address,
                  );
                },
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showAddAddressDialog(
                      context,
                    );
                  },
                  icon: const Icon(
                    Icons.add_location_alt_outlined,
                  ),
                  label: const Text(
                    'Add New Address',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddressCard(
    BuildContext context,
    ShippingAddress address,
  ) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      elevation: address.isDefault ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: address.isDefault
              ? Colors.deepPurple.withValues(
                  alpha: 0.25,
                )
              : Colors.grey.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple
                        .withValues(
                      alpha: 0.09,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.deepPurple,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              address.label,
                              style:
                                  const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          if (address.isDefault)
                            Container(
                              margin:
                                  const EdgeInsets
                                      .only(
                                left: 8,
                              ),
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration:
                                  BoxDecoration(
                                color: Colors
                                    .green
                                    .withValues(
                                  alpha: 0.10,
                                ),
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  20,
                                ),
                              ),
                              child: const Text(
                                'Default',
                                style: TextStyle(
                                  color:
                                      Colors.green,
                                  fontSize: 10,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Text(
                        address.recipientName,
                        style: TextStyle(
                          color:
                              Colors.grey.shade700,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'default') {
                      addressManager
                          .setDefault(
                        address.id,
                      );
                    }

                    if (value == 'delete') {
                      _confirmDelete(
                        context,
                        address,
                      );
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      if (!address.isDefault)
                        const PopupMenuItem(
                          value: 'default',
                          child: Row(
                            children: [
                              Icon(
                                Icons
                                    .star_outline,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Set as Default',
                              ),
                            ],
                          ),
                        ),
                      if (!address.isDefault ||
                          addressManager
                                  .addresses
                                  .length >
                              1)
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons
                                    .delete_outline,
                                color: Colors.red,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Delete',
                              ),
                            ],
                          ),
                        ),
                    ];
                  },
                ),
              ],
            ),

            const SizedBox(height: 14),

            const Divider(),

            const SizedBox(height: 10),

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.home_outlined,
                  size: 19,
                  color: Colors.grey.shade600,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    address.address,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 9),

            Row(
              children: [
                Icon(
                  Icons.phone_outlined,
                  size: 18,
                  color: Colors.grey.shade600,
                ),

                const SizedBox(width: 10),

                Text(
                  address.phone,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAddressDialog(
    BuildContext context,
  ) {
    final labelController =
        TextEditingController();

    final nameController =
        TextEditingController(
      text: 'Kelvin',
    );

    final addressController =
        TextEditingController();

    final phoneController =
        TextEditingController();

    bool setAsDefault = false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return AlertDialog(
              title: const Text(
                'Add New Address',
              ),
              content:
                  SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    TextField(
                      controller:
                          labelController,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Address Label',
                        hintText:
                            'Contoh: Rumah',
                        prefixIcon: Icon(
                          Icons
                              .label_outline,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    TextField(
                      controller:
                          nameController,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Recipient Name',
                        prefixIcon: Icon(
                          Icons
                              .person_outline,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    TextField(
                      controller:
                          addressController,
                      maxLines: 3,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Full Address',
                        hintText:
                            'Contoh: Jl. ...',
                        prefixIcon: Icon(
                          Icons
                              .location_on_outlined,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    TextField(
                      controller:
                          phoneController,
                      keyboardType:
                          TextInputType.phone,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Phone Number',
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    CheckboxListTile(
                      contentPadding:
                          EdgeInsets.zero,
                      value: setAsDefault,
                      onChanged: (value) {
                        setDialogState(() {
                          setAsDefault =
                              value ?? false;
                        });
                      },
                      title: const Text(
                        'Set as default address',
                      ),
                      controlAffinity:
                          ListTileControlAffinity
                              .leading,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text(
                    'Cancel',
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    final label =
                        labelController.text
                            .trim();

                    final name =
                        nameController.text
                            .trim();

                    final address =
                        addressController
                            .text
                            .trim();

                    final phone =
                        phoneController.text
                            .trim();

                    if (label.isEmpty ||
                        name.isEmpty ||
                        address.isEmpty ||
                        phone.isEmpty) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Semua data alamat wajib diisi.',
                          ),
                        ),
                      );
                      return;
                    }

                    addressManager
                        .addAddress(
                      label: label,
                      recipientName:
                          name,
                      address: address,
                      phone: phone,
                      setAsDefault:
                          setAsDefault,
                    );

                    Navigator.pop(
                      dialogContext,
                    );

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Alamat berhasil ditambahkan.',
                        ),
                        backgroundColor:
                            Colors.green,
                      ),
                    );
                  },
                  child: const Text(
                    'Save Address',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    ShippingAddress address,
  ) {
    if (addressManager.addresses.length <= 1) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Minimal harus ada satu alamat.',
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Address?',
          ),
          content: Text(
            'Hapus alamat "${address.label}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                addressManager
                    .removeAddress(
                  address.id,
                );

                Navigator.pop(
                  dialogContext,
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );
  }
}