part of 'address_cubit.dart';

@immutable
sealed class AddressState {}

final class AddressInitial extends AddressState {}

final class AddressLoading extends AddressState {}

final class AddressAdded extends AddressState {
  final String addressId;
  AddressAdded({required this.addressId});
}

final class AddressUpdated extends AddressState {}

final class AddressDeleted extends AddressState {}

final class AddressDefaultSet extends AddressState {}

final class AddressSingleLoaded extends AddressState {
  final AddressModel address;
  AddressSingleLoaded({required this.address});
}

final class AddressesLoaded extends AddressState {
  final List<AddressModel> addresses;
  AddressesLoaded({required this.addresses});
}

final class AddressFailure extends AddressState {
  final String errMessage;
  AddressFailure({required this.errMessage});
}
