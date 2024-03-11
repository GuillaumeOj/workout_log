class CreateMovement {
  CreateMovement({
    required this.name,
    required this.position,
    this.durationSeconds,
    this.repetitions,
  });

  String name;
  int position;
  int? durationSeconds;
  int? repetitions;

  Map<String, dynamic> toJson() => {
        "name": name,
        "position": position,
        "durationSeconds": durationSeconds,
        "repetitions": repetitions,
      };
}

class CreateRound {
  CreateRound({
    required this.position,
    this.durationSeconds,
    this.repetitions,
    this.movements,
  });

  int position;
  int? durationSeconds;
  int? repetitions;
  List<CreateMovement>? movements;

  Map<String, dynamic> toJson() => {
        "position": position,
        "durationSeconds": durationSeconds,
        "repetitions": repetitions,
        "movements": movements?.map((x) => x.toJson()).toList(),
      };
}

class CreateWorkout {
  CreateWorkout({
    this.name,
    this.description,
    required this.workoutType,
    this.rounds,
  });

  String? name;
  String? description;
  String workoutType;
  List<CreateRound>? rounds;

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "workoutType": workoutType,
        "rounds": rounds?.map((x) => x.toJson()).toList(),
      };
}
