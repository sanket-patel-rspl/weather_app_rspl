import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../exceptions/exceptions.dart';
import 'location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<Position> getCurrentLocation() async {
    try {
      // Check location permission
      var status = await Permission.location.status;
      if (status == PermissionStatus.granted) {
        return await Geolocator.getCurrentPosition(
            // desiredAccuracy: LocationAccuracy.high,
            );
      } else {
        // Request location permission
        if (await Permission.location.request() == PermissionStatus.granted) {
          return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
        } else if (await Permission.location.request() ==
            PermissionStatus.permanentlyDenied) {
          throw CustomException(
              "Location permission permanentlyDenied, now you need to give location permission from app settings.");
        } else {
          throw CustomException(
              "Location permission denied,Please allow location permission to using the application.");
        }
      }
    } catch (e) {
      if (e is CustomException) {
        throw CustomException(e.errorMessage);
      }
      if (e is LocationServiceDisabledException) {
        throw CustomException(
            "Location services is disable on this device.\nPlease press refresh and turn on Location service");
      }
      throw Exception(e);
    }
  }
}
