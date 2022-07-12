import 'package:bike_cafe/models/Storage/address/getaddressmodel.dart';
import 'package:bike_cafe/models/Vechile/getbrand.dart';
import 'package:bike_cafe/models/Vechile/vechileDetailsModel.dart';
import 'package:bike_cafe/services/api.dart';

class Repository {
  final APIService apiProvider;

  Repository(this.apiProvider);

  // Getzone
  Future<Vechicletypemodel?> getVechiceltype({required String token}) =>
      apiProvider.getuservechiletype(token: token);

  // Get state
  // Future<VechiletypeBrand?> getbrand() =>
  //     apiProvider.getuserbrandbyvechicletype();
}
