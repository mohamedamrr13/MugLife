import 'package:dartz/dartz.dart';
import 'package:drinks_app/core/error_handling/faliure.dart';
import 'package:drinks_app/core/services/firestore_service.dart';
import 'package:drinks_app/features/auth/data/models/address_model.dart';
import 'package:drinks_app/features/auth/data/repository/address_repository.dart';

/// Firestore implementation of AddressRepository
class FirestoreAddressRepository implements AddressRepository {
  final FirestoreService _firestoreService;

  FirestoreAddressRepository(this._firestoreService);

  /// Collection path for user addresses: users/{userId}/addresses
  String _getAddressesPath(String userId) => 'users/$userId/addresses';

  @override
  Future<Either<Failure, String>> addAddress({
    required String userId,
    required AddressModel address,
  }) async {
    try {
      final addressId = await _firestoreService.addDocument(
        collectionPath: _getAddressesPath(userId),
        data: address.toMap(),
      );
      return Right(addressId);
    } catch (e) {
      return Left(Failure(message: 'Failed to add address: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateAddress({
    required String userId,
    required String addressId,
    required AddressModel address,
  }) async {
    try {
      await _firestoreService.updateDocument(
        collectionPath: _getAddressesPath(userId),
        documentId: addressId,
        data: address.toMap(),
      );
      return const Right(null);
    } catch (e) {
      return Left(
        Failure(message: 'Failed to update address: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress({
    required String userId,
    required String addressId,
  }) async {
    try {
      await _firestoreService.deleteDocument(
        collectionPath: _getAddressesPath(userId),
        documentId: addressId,
      );
      return const Right(null);
    } catch (e) {
      return Left(
        Failure(message: 'Failed to delete address: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, AddressModel>> getAddress({
    required String userId,
    required String addressId,
  }) async {
    try {
      final doc = await _firestoreService.getDocument(
        collectionPath: _getAddressesPath(userId),
        documentId: addressId,
      );

      if (doc == null || !doc.exists) {
        return Left(Failure(message: 'Address not found'));
      }

      final address = AddressModel.fromDocument(doc);
      return Right(address);
    } catch (e) {
      return Left(Failure(message: 'Failed to get address: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<AddressModel>>> getAllAddresses({
    required String userId,
  }) async {
    try {
      final docs = await _firestoreService.getAllDocuments(
        collectionPath: _getAddressesPath(userId),
      );

      final addresses =
          docs.docs.map((doc) => AddressModel.fromDocument(doc)).toList();

      // Sort by default first, then by creation date
      addresses.sort((a, b) {
        if (a.isDefault && !b.isDefault) return -1;
        if (!a.isDefault && b.isDefault) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });

      return Right(addresses);
    } catch (e) {
      return Left(Failure(message: 'Failed to get addresses: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> setDefaultAddress({
    required String userId,
    required String addressId,
  }) async {
    try {
      // Get all addresses
      final addressesResult = await getAllAddresses(userId: userId);

      await addressesResult.fold(
        (failure) => throw Exception(failure.message),
        (addresses) async {
          // Update all addresses to set isDefault = false
          for (final address in addresses) {
            if (address.id != null) {
              await _firestoreService.updateDocument(
                collectionPath: _getAddressesPath(userId),
                documentId: address.id!,
                data: {'isDefault': address.id == addressId},
              );
            }
          }
        },
      );

      return const Right(null);
    } catch (e) {
      return Left(
        Failure(message: 'Failed to set default address: ${e.toString()}'),
      );
    }
  }
}
