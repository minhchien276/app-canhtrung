import 'package:flutter_ovumb_app_version1/data/models/store/address.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/address/address_provider.dart';

class AddressRepository {
  final _provider = AddressProvider();

  Future<List<Address>?> getAllAddress() => _provider.getAllAddress();

  Future<bool> insert(Address address) => _provider.insert(address);

  Future<bool> update(Address address) => _provider.update(address);

  Future<bool> updateStatus({
    required int addressId,
  }) =>
      _provider.updateStatus(addressId);

  Future<bool> delete(int addressId) => _provider.delete(addressId);

  Stream<List<Address>> allAddress() => _provider.addressStream;
}
