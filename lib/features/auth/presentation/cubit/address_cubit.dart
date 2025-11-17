import 'package:bloc/bloc.dart';
import 'package:drinks_app/features/auth/data/models/address_model.dart';
import 'package:drinks_app/features/auth/data/repository/address_repository.dart';
import 'package:flutter/foundation.dart';

part 'address_state.dart';

/// Cubit for managing user addresses
class AddressCubit extends Cubit<AddressState> {
  final AddressRepository _addressRepository;

  AddressCubit(this._addressRepository) : super(AddressInitial());

  /// Add a new address for the user
  Future<void> addAddress({
    required String userId,
    required AddressModel address,
  }) async {
    emit(AddressLoading());

    final result = await _addressRepository.addAddress(
      userId: userId,
      address: address,
    );

    result.fold(
      (failure) => emit(AddressFailure(errMessage: failure.message)),
      (addressId) {
        emit(AddressAdded(addressId: addressId));
        // Automatically load all addresses after adding
        getAllAddresses(userId: userId);
      },
    );
  }

  /// Update an existing address
  Future<void> updateAddress({
    required String userId,
    required String addressId,
    required AddressModel address,
  }) async {
    emit(AddressLoading());

    final result = await _addressRepository.updateAddress(
      userId: userId,
      addressId: addressId,
      address: address,
    );

    result.fold(
      (failure) => emit(AddressFailure(errMessage: failure.message)),
      (_) {
        emit(AddressUpdated());
        // Automatically load all addresses after updating
        getAllAddresses(userId: userId);
      },
    );
  }

  /// Delete an address
  Future<void> deleteAddress({
    required String userId,
    required String addressId,
  }) async {
    emit(AddressLoading());

    final result = await _addressRepository.deleteAddress(
      userId: userId,
      addressId: addressId,
    );

    result.fold(
      (failure) => emit(AddressFailure(errMessage: failure.message)),
      (_) {
        emit(AddressDeleted());
        // Automatically load all addresses after deleting
        getAllAddresses(userId: userId);
      },
    );
  }

  /// Get a specific address
  Future<void> getAddress({
    required String userId,
    required String addressId,
  }) async {
    emit(AddressLoading());

    final result = await _addressRepository.getAddress(
      userId: userId,
      addressId: addressId,
    );

    result.fold(
      (failure) => emit(AddressFailure(errMessage: failure.message)),
      (address) => emit(AddressSingleLoaded(address: address)),
    );
  }

  /// Get all addresses for the user
  Future<void> getAllAddresses({required String userId}) async {
    emit(AddressLoading());

    final result = await _addressRepository.getAllAddresses(userId: userId);

    result.fold(
      (failure) => emit(AddressFailure(errMessage: failure.message)),
      (addresses) => emit(AddressesLoaded(addresses: addresses)),
    );
  }

  /// Set an address as default
  Future<void> setDefaultAddress({
    required String userId,
    required String addressId,
  }) async {
    emit(AddressLoading());

    final result = await _addressRepository.setDefaultAddress(
      userId: userId,
      addressId: addressId,
    );

    result.fold(
      (failure) => emit(AddressFailure(errMessage: failure.message)),
      (_) {
        emit(AddressDefaultSet());
        // Automatically load all addresses after setting default
        getAllAddresses(userId: userId);
      },
    );
  }

  /// Get default address from a list of addresses
  AddressModel? getDefaultAddress(List<AddressModel> addresses) {
    try {
      return addresses.firstWhere((address) => address.isDefault);
    } catch (_) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }
}
