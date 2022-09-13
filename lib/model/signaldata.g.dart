// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signaldata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignalData _$SignalDataFromJson(Map<String, dynamic> json) => SignalData(
      $enumDecode(_$SignalTypeEnumMap, json['type']),
      json['fromUID'] as String?,
      json['toUID'] as String?,
      json['data'] as String?,
    );

Map<String, dynamic> _$SignalDataToJson(SignalData instance) =>
    <String, dynamic>{
      'type': _$SignalTypeEnumMap[instance.type]!,
      'fromUID': instance.fromUID,
      'toUID': instance.toUID,
      'data': instance.data,
    };

const _$SignalTypeEnumMap = {
  SignalType.OfferRequest: 'OfferRequest',
  SignalType.Offer: 'Offer',
  SignalType.Answer: 'Answer',
  SignalType.Ice: 'Ice',
  SignalType.Welcome: 'Welcome',
};
