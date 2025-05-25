class Service {
  final List<String> action;
  final List<String> reaction;

  Service({required this.action, required this.reaction});

  // Méthode pour convertir un Service en Map
  Map<String, dynamic> toMap() {
    return {
      'action': action,
      'reaction': reaction,
    };
  }

  // Méthode pour créer un Service à partir d'un Map
  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      action: List<String>.from(map['action']),
      reaction: List<String>.from(map['reaction']),
    );
  }

  @override
  String toString() {
    return 'Service(action: $action, reaction: $reaction)';
  }
}

Future<List<Map<String, dynamic>>> convertJsonToServices(dynamic data) async {
  List<Map<String, dynamic>> t = List<Map<String, dynamic>>.from(
    (data as Map<String, dynamic>).entries.map((entry) => {
          entry.key: {
            'actions': entry.value['actions'],
            'reactions': entry.value['reactions'],
            'is_connected': entry.value['is_connected'],
            'url': entry.value['url'],
          }
        }),
  );
  return t;
}

Future<List<Map<String, dynamic>>> convertJsonToServicesConnected(
    dynamic data) async {
  return List<Map<String, dynamic>>.from(
    (data as List<dynamic>).map((entry) => {
          'action': entry['action'],
          'description': entry['description'],
          'url': entry['url'],
          'service': entry['service'],
          'reactions': List<Map<String, dynamic>>.from(
            entry['reactions'].map((reaction) => {
                  'reaction': reaction['reaction'],
                  'description': reaction['description'],
                  'imageUrl': reaction['imageUrl'],
                }),
          ),
          'time':
              entry['time'], // Ajoute l'heure directement si elle est requise
        }),
  );
}

Future<List<Map<String, dynamic>>> convertJsonToRecentEvent(
    dynamic data) async {
  return List<Map<String, dynamic>>.from(
    (data as List<dynamic>).map((entry) => {
          'eventId': entry['eventId'],
          'description': entry['description'],
          'url': entry['url'],
          'name': entry['name'],
          'author': entry['author'],
          'userId': entry['userId'],
          'createdAt': entry[
              'createdAt'], // Ajoute l'heure directement si elle est requise
        }),
  );
}

Future<List<Map<String, dynamic>>> convertJsonToServicesConnectionOnly(
    dynamic data) async {
  List<Map<String, dynamic>> t = List<Map<String, dynamic>>.from(
      (data as Map<String, dynamic>).entries.map((entry) => {
            entry.key: {
              'is_connected': entry.value['is_connected'],
              'url': entry.value['url'],
            }
          }));
  return t;
}

class ServicesModel {
  final Map<String, Service> services;

  ServicesModel({required this.services});

  // Méthode pour convertir le modèle en Map
  Map<String, dynamic> toMap() {
    return {
      'services': services.map((key, value) => MapEntry(key, value.toMap())),
    };
  }

  // Méthode pour créer un ServicesModel à partir d'un Map
  factory ServicesModel.fromMap(Map<String, dynamic> map) {
    return ServicesModel(
      services: Map.from(map)
          .map((key, value) => MapEntry(key, Service.fromMap(value))),
    );
  }
}
