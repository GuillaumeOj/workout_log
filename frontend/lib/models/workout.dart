class Equipment {
  Equipment({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class CreateMovement {
  CreateMovement({
    required this.name,
    required this.position,
    this.durationSeconds,
    this.repetition,
    this.equipment,
  });

  String name;
  int position;
  int? durationSeconds;
  int? repetition;
  List<Equipment>? equipment;
}

class CreateRound {
  CreateRound({
    required this.position,
    this.durationSeconds,
    this.repetition,
    this.movements,
  });

  int position;
  int? durationSeconds;
  int? repetition;
  List<CreateMovement>? movements;
}

class CreateWorkout {
  CreateWorkout({
    this.name,
    this.description,
    this.rounds,
  });

  String? name;
  String? description;
  List<CreateRound>? rounds;
}
