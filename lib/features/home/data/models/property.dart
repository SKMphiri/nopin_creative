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

const quickOptions = ["Arrendar", "Comprar", "Terreno", "Casas"];

final List<Property> properties = [
  const Property(
      id: "0",
      price: 125000,
      title: "Casa Moderna para Arrendar, T3",
      location: "Belo Horizonte, Maputo",
      type: PropertyType.rent,
      attributes: {
        PropertyAttributeType.room: 4,
        PropertyAttributeType.wc: 4,
        PropertyAttributeType.pool: 1,
        PropertyAttributeType.parking: 1
      },
      active: true),
  const Property(
      id: "0",
      price: 125000,
      title: "Terreno de 2 hectares",
      location: "Belo Horizonte, Maputo",
      type: PropertyType.land,
      attributes: {
        PropertyAttributeType.width: 50,
        PropertyAttributeType.length: 20
      },
      active: true),
];