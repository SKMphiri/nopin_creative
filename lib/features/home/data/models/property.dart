import 'package:equatable/equatable.dart';

enum PropertyType { land, rent, house }

enum PropertyAttributeType { room, wc, pool, parking, width, length }

class Property extends Equatable {
  final String id;
  final double price;
  final String location;
  final String title;
  final PropertyType type;
  final Map<PropertyAttributeType, int> attributes;
  final bool active;

  const Property(
      {required this.id,
      required this.price,
      required this.title,
      required this.location,
      required this.type,
      required this.attributes,
      required this.active});

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
