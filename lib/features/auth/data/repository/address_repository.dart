import 'package:dartz/dartz.dart';
import 'package:drinks_app/core/error_handling/faliure.dart';
import 'package:drinks_app/features/auth/data/models/address_model.dart';

/// Abstract repository for address operations
abstract class AddressRepository {
  Future<Either<Failure, String>> addAddress({
    required String userId,
    required AddressModel address,
  });

  Future<Either<Failure, void>> updateAddress({
    required String userId,
    required String addressId,
    required AddressModel address,
  });

  Future<Either<Failure, void>> deleteAddress({
    required String userId,
    required String addressId,
  });

  Future<Either<Failure, AddressModel>> getAddress({
    required String userId,
    required String addressId,
  });

  Future<Either<Failure, List<AddressModel>>> getAllAddresses({
    required String userId,
  });

  Future<Either<Failure, void>> setDefaultAddress({
    required String userId,
    required String addressId,
  });
}
