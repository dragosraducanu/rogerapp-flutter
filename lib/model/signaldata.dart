// ignore_for_file: constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'signaldata.g.dart';

@JsonSerializable(explicitToJson: true)
class SignalData {
  final SignalType type;
  final String? fromUID;
  final String? toUID;
  final String? data;

  SignalData(this.type, this.fromUID, this.toUID, this.data);

  factory SignalData.fromJson(Map<String, dynamic> json) => _$SignalDataFromJson(json);

  Map<String, dynamic> toJson() => _$SignalDataToJson(this);
}

enum SignalType {
  /// requests an offer from a client
  OfferRequest,

  /// sent by a user whenever they want to offer a connection
  Offer,

  /// sent by a user whenever they want to answer an offer
  Answer,
  Ice,

  /// Connection established message
  Welcome,
}
